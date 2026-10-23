import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/component_param.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/component_binding.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';

/// Whether a property can be bound to a parameter: a string, a number or a
/// colour that is written as a plain literal. A whole number, an icon, a
/// screen, a component or a picture is not.
bool canBindToParam(PropSchema schema) =>
    !schema.integer &&
    !schema.iconPicker &&
    !schema.screenPicker &&
    !schema.componentPicker &&
    !schema.assetPicker &&
    (schema.type == PropType.string ||
        schema.type == PropType.number ||
        schema.type == PropType.color);

final RegExp _identifier = RegExp(r'^[a-z][A-Za-z0-9]*$');

/// Words Dart keeps for itself, which cannot name a parameter.
const Set<String> _reserved = {
  'class',
  'const',
  'final',
  'var',
  'void',
  'new',
  'null',
  'true',
  'false',
  'this',
  'super',
  'key',
  'child',
  'children',
  'context',
  'if',
  'else',
  'for',
  'while',
  'return',
  'switch',
  'case',
  'default',
  'in',
  'is',
  'as',
  'do',
  'try',
  'catch',
  'throw',
  'enum',
  'import',
  'extends',
  'with',
  'late',
  'required',
};

/// Binds the properties of a component to parameters, and frees them again.
/// Only a property of the open component can be bound, and only one whose
/// value is a string, a number or a colour.
class ComponentParamsEditor {
  const ComponentParamsEditor(this._registry);

  final WidgetRegistry _registry;

  /// Whether the property [schema] can be bound to a parameter.
  bool canBind(PropSchema schema) => canBindToParam(schema);

  /// Binds the property [prop] of [nodeId] to the parameter [name], making
  /// the parameter when it is new, with the property's value as its default.
  Either<Failure, EditorDocument> bind(
    EditorDocument document,
    String nodeId,
    String prop,
    String name,
  ) {
    final node = document.root.find(nodeId);
    final schema = node == null || !_registry.contains(node.type)
        ? null
        : _registry
              .definitionFor(node.type)
              .props
              .where((p) => p.name == prop)
              .firstOrNull;
    if (!document.component ||
        node == null ||
        schema == null ||
        !canBind(schema) ||
        !_identifier.hasMatch(name) ||
        _reserved.contains(name)) {
      return _invalid();
    }
    final existing = document.params.where((p) => p.name == name).firstOrNull;
    if (existing != null && existing.type != schema.type) return _invalid();
    final params = existing != null
        ? document.params
        : [
            ...document.params,
            ComponentParam(
              name: name,
              type: schema.type,
              defaultValue: _currentValue(node, schema),
            ),
          ];
    return Right(
      document.copyWith(
        params: params,
        root: _setProp(document.root, nodeId, prop, bindingTo(name)),
      ),
    );
  }

  /// Frees the property [prop] of [nodeId] from its parameter, giving it the
  /// parameter's default as its own value. A parameter nothing is bound to
  /// any more goes.
  Either<Failure, EditorDocument> unbind(
    EditorDocument document,
    String nodeId,
    String prop,
  ) {
    final node = document.root.find(nodeId);
    final name = node == null ? null : boundParam(node.props[prop]);
    final param = document.params.where((p) => p.name == name).firstOrNull;
    if (!document.component || name == null || param == null) return _invalid();
    final root = _setProp(document.root, nodeId, prop, param.defaultValue);
    final used = usedParams(root);
    return Right(
      document.copyWith(
        root: root,
        params: [
          for (final p in document.params)
            if (used.contains(p.name)) p,
        ],
      ),
    );
  }

  // What the property shows now: its own value, or the schema default, or a
  // value of the right kind when there is neither.
  Object _currentValue(WidgetNode node, PropSchema schema) {
    final stored = node.props[schema.name];
    if (schema.accepts(stored) && stored != null) return stored;
    final fallback = schema.defaultValue;
    if (fallback != null) return fallback;
    return switch (schema.type) {
      PropType.string => '',
      PropType.number => 0.0,
      _ => 0xFF000000,
    };
  }

  WidgetNode _setProp(WidgetNode node, String id, String prop, Object? value) =>
      node.id == id
      ? node.copyWith(props: {...node.props, prop: value})
      : node.copyWith(
          children: [
            for (final child in node.children) _setProp(child, id, prop, value),
          ],
        );

  Either<Failure, EditorDocument> _invalid() =>
      const Left(DocumentFailure(DocumentFailureReason.invalidParameter));
}
