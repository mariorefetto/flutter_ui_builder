import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_parser.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_value.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_hooks.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/value_reader.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/identifier_names.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';

const String _defaultName = 'imported';
const String _classSuffix = screenClassSuffix;
const String _scaffold = 'Scaffold';
const String _column = 'Column';
const String _placeholder = 'Placeholder';
const String _shrink = 'SizedBox.shrink';
const String _childArgument = 'child';
const String _childrenArgument = 'children';

/// Builds a document from Dart code: the reverse of the code generator.
///
/// It reads a widget class or a single widget expression and maps each
/// constructor call to the widget definition that writes it. Whatever it
/// cannot map is left out and listed, so the result is always something the
/// designer can show.
class CodeImporter {
  CodeImporter(this._registry, this._parser) : _reader = ValueReader(_parser);

  final WidgetRegistry _registry;
  final CodeParser _parser;
  final ValueReader _reader;

  Either<Failure, ImportResult> import(String source) {
    final parsed = _parser.parse(source);
    if (parsed.errors.isNotEmpty) {
      return Left(
        DocumentFailure(
          DocumentFailureReason.codeSyntax,
          parsed.errors.join('\n'),
        ),
      );
    }
    final issues = <ImportIssue>[];
    final widget = parsed.widget;
    final root = widget == null ? null : _convert(widget, issues);
    if (root == null) {
      return const Left(DocumentFailure(DocumentFailureReason.codeNoWidget));
    }
    return _finish(root.renumbered(0), parsed.className, issues);
  }

  Either<Failure, ImportResult> _finish(
    WidgetNode root,
    String? className,
    List<ImportIssue> issues,
  ) {
    var tree = root;
    var broken = _registry.violation(tree);
    // Code for a Material widget often leaves out the Scaffold around it.
    if (broken != null && _registry.contains(_scaffold)) {
      final wrapped = WidgetNode(
        id: '',
        type: _scaffold,
        children: [root],
      ).renumbered(0);
      if (_registry.violation(wrapped) == null) {
        tree = wrapped;
        broken = null;
        issues.add(
          const ImportIssue(
            kind: ImportIssueKind.wrappedInScaffold,
            widgetType: _scaffold,
          ),
        );
      }
    }
    if (broken != null) {
      return Left(
        DocumentFailure(
          DocumentFailureReason.invalidStructure,
          'The code breaks a placement rule: ${broken.name}',
        ),
      );
    }
    return Right(
      ImportResult(
        document: EditorDocument(name: _nameFor(className), root: tree),
        issues: issues,
        named: className != null,
      ),
    );
  }

  String _nameFor(String? className) {
    if (className == null) return _defaultName;
    final name =
        className.endsWith(_classSuffix) &&
            className.length > _classSuffix.length
        ? className.substring(0, className.length - _classSuffix.length)
        : className;
    return pascalCase(name);
  }

  WidgetNode? _convert(CodeValue value, List<ImportIssue> issues) {
    if (value is! CodeCall) return null;
    final definition = _definitionFor(value);
    if (definition == null) return _unknown(value, issues);
    final props = <String, Object?>{};
    final children = <WidgetNode>[];
    final consumed = <String>{};
    importHooks[definition.type]?.call(
      value,
      _reader,
      definition.props,
      props,
      consumed,
    );
    _readNavigation(definition, value, props);
    for (final MapEntry(:key, value: argument) in value.named.entries) {
      if (consumed.contains(key) || argument is CodeFunction) continue;
      final child = _childrenOf(definition, key, argument, issues);
      if (child != null) {
        children.addAll(child);
      } else {
        _readProp(definition, key, argument, props, issues);
      }
    }
    return WidgetNode(
      id: '',
      type: definition.type,
      props: _withoutDefaults(definition, props),
      children: children,
    );
  }

  // A callback that pushes a screen or pops one, as the generator writes it.
  void _readNavigation(
    WidgetDefinition definition,
    CodeCall call,
    Map<String, Object?> props,
  ) {
    if (!definition.props.any((p) => p.name == navigateToProp)) return;
    for (final callback in call.named.values) {
      final target = callback is CodeFunction
          ? _navigationTarget(callback)
          : null;
      if (target != null) {
        props[navigateToProp] = target;
        return;
      }
    }
  }

  String? _navigationTarget(CodeFunction callback) {
    final body = callback.body;
    if (body is! CodeCall || body.name != 'Navigator') return null;
    if (body.constructor == 'pop') return navigateBack;
    if (body.constructor != 'push' || body.positional.length < 2) return null;
    final route = body.positional[1];
    if (route is! CodeCall || route.name != 'MaterialPageRoute') return null;
    final builder = route.named['builder'];
    final screen = builder is CodeFunction ? builder.body : null;
    if (screen is! CodeCall) return null;
    return _screenName(screen.name);
  }

  // `SettingsView` is the screen "Settings".
  String _screenName(String className) =>
      className.endsWith(screenClassSuffix) &&
          className.length > screenClassSuffix.length
      ? className.substring(0, className.length - screenClassSuffix.length)
      : className;

  // `SizedBox.shrink()` is how the generator writes a missing child.
  WidgetDefinition? _definitionFor(CodeCall call) {
    final exact = _registry.byConstructor(call.qualifiedName);
    if (exact != null) return exact;
    return call.qualifiedName == _shrink
        ? _registry.byConstructor(call.name)
        : null;
  }

  // The nodes an argument holds when it is a child argument of [definition],
  // or null when it is not one.
  List<WidgetNode>? _childrenOf(
    WidgetDefinition definition,
    String argument,
    CodeValue value,
    List<ImportIssue> issues,
  ) {
    final layout = definition.slotLayout;
    final isSlot =
        layout != null &&
        (layout.slots.values.contains(argument) ||
            argument == layout.bodyArgument);
    final policy = definition.childPolicy;
    final isSingle =
        policy == ChildPolicy.single &&
        argument == (definition.childArgument ?? _childArgument);
    final isMany =
        policy == ChildPolicy.multiple &&
        !isSlot &&
        argument == (definition.childArgument ?? _childrenArgument);
    if (isSlot || isSingle) {
      return [?_childNode(definition, value, issues)];
    }
    if (isMany && value is CodeList) {
      return [
        for (final item in value.items) ?_childNode(definition, item, issues),
      ];
    }
    return isMany ? const [] : null;
  }

  WidgetNode? _childNode(
    WidgetDefinition parent,
    CodeValue value,
    List<ImportIssue> issues,
  ) {
    final isFiller = value is CodeCall && value.qualifiedName == _shrink;
    final keepsFiller = !parent.requiresChild && parent.slotLayout == null;
    if (isFiller && !keepsFiller) return null;
    return _convert(value, issues);
  }

  void _readProp(
    WidgetDefinition definition,
    String argument,
    CodeValue value,
    Map<String, Object?> props,
    List<ImportIssue> issues,
  ) {
    final schema = _schemaFor(definition.props, argument);
    if (schema != null) {
      final read = _reader.read(schema, value);
      read == null
          ? issues.add(
              _issue(ImportIssueKind.invalidValue, definition, argument),
            )
          : props[schema.name] = read;
      return;
    }
    final grouped = definition.props.where((p) => p.group == argument).toList();
    if (grouped.isNotEmpty && value is CodeCall) {
      _readGroup(definition, argument, grouped, value, props, issues);
      return;
    }
    issues.add(
      _issue(ImportIssueKind.unsupportedArgument, definition, argument),
    );
  }

  void _readGroup(
    WidgetDefinition definition,
    String group,
    List<PropSchema> members,
    CodeCall call,
    Map<String, Object?> props,
    List<ImportIssue> issues,
  ) {
    for (final MapEntry(:key, :value) in call.named.entries) {
      final schema = _schemaFor(members, key);
      if (schema == null) {
        issues.add(
          _issue(
            ImportIssueKind.unsupportedArgument,
            definition,
            '$group.$key',
          ),
        );
        continue;
      }
      final read = _reader.read(schema, value);
      read == null
          ? issues.add(
              _issue(ImportIssueKind.invalidValue, definition, '$group.$key'),
            )
          : props[schema.name] = read;
    }
  }

  PropSchema? _schemaFor(List<PropSchema> schemas, String argument) {
    for (final schema in schemas) {
      if ((schema.argument ?? schema.name) == argument) return schema;
    }
    return null;
  }

  ImportIssue _issue(
    ImportIssueKind kind,
    WidgetDefinition definition,
    String argument,
  ) => ImportIssue(
    kind: kind,
    widgetType: definition.constructorName,
    argument: argument,
  );

  // A property that holds its default adds nothing to the document, and a
  // value of the wrong kind is dropped.
  Map<String, Object?> _withoutDefaults(
    WidgetDefinition definition,
    Map<String, Object?> props,
  ) => {
    for (final schema in definition.props)
      if (props[schema.name] case final value?)
        if (schema.accepts(value) && !_isDefault(schema, value))
          schema.name: value,
  };

  bool _isDefault(PropSchema schema, Object value) {
    final defaultValue = schema.defaultValue;
    if (defaultValue is num && value is num) return defaultValue == value;
    if (defaultValue is List<Object?> && value is List<Object?>) {
      return defaultValue.length == value.length &&
          [
            for (var i = 0; i < value.length; i++)
              (defaultValue[i] as num) == (value[i] as num),
          ].every((same) => same);
    }
    return defaultValue == value;
  }

  // A widget the builder does not have: its child takes its place, several
  // children go in a Column, and a leaf becomes a Placeholder.
  WidgetNode? _unknown(CodeCall call, List<ImportIssue> issues) {
    issues.add(
      ImportIssue(
        kind: ImportIssueKind.unknownWidget,
        widgetType: call.qualifiedName,
      ),
    );
    final child = call.named[_childArgument];
    if (child != null) return _convert(child, issues);
    final many = call.named[_childrenArgument];
    if (many is CodeList && _registry.contains(_column)) {
      return WidgetNode(
        id: '',
        type: _column,
        children: [for (final item in many.items) ?_convert(item, issues)],
      );
    }
    return _registry.contains(_placeholder)
        ? const WidgetNode(id: '', type: _placeholder)
        : null;
  }
}
