import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_child.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

const String _childArgument = 'child';
const String _childrenArgument = 'children';
const String _missingChild = 'SizedBox.shrink()';

/// Builds a WidgetDefinition whose code is derived from its property schema:
/// every property becomes a named argument of [constructor], children become
/// `child` or `children`, and values equal to the schema default are left out.
WidgetDefinition simpleDefinition({
  required String type,
  required String category,
  List<PropSchema> props = const [],
  ChildPolicy childPolicy = ChildPolicy.none,
  String? constructor,
  String? label,
  bool childRequired = false,
  String? childArgument,
  Set<String>? acceptedChildren,
  Map<String, String> fixedArguments = const {},
  Map<String, String> groups = const {},
  Set<String>? allowedParents,
  Set<String> forbiddenParents = const {},
  Set<String>? requiredAncestors,
  Map<String, String> autoWrap = const {},
  Set<String> imports = const {},
  Set<String> Function(NodeProps props)? importsWhen,
}) {
  final name = constructor ?? type;
  return WidgetDefinition(
    type: type,
    label: label ?? type,
    category: category,
    props: props,
    childPolicy: childPolicy,
    allowedParents: allowedParents,
    forbiddenParents: forbiddenParents,
    requiredAncestors: requiredAncestors,
    autoWrap: autoWrap,
    imports: imports,
    importsWhen: importsWhen,
    requiresChild: childRequired,
    constructor: name,
    childArgument: childArgument,
    childFilter: acceptedChildren == null
        ? null
        : (childType, siblings) => acceptedChildren.contains(childType),
    generateCode: (values, children) {
      final arguments = {
        ...fixedArguments,
        ...propArguments(props, values, groups),
        ..._childArguments(childPolicy, children, childRequired, childArgument),
      };
      return '$name(${dartArguments(arguments)})';
    },
  );
}

/// The named arguments written for [props], with grouped properties nested in
/// their group's constructor. Null values are skipped by dartArguments.
Map<String, String?> propArguments(
  List<PropSchema> props,
  NodeProps values,
  Map<String, String> groups,
) {
  final arguments = <String, String?>{};
  final grouped = <String, List<String>>{};
  for (final schema in props) {
    final literal = _emittedLiteral(schema, values);
    if (literal == null) continue;
    final argument = schema.argument ?? schema.name;
    final group = schema.group;
    if (group == null) {
      arguments[argument] = literal;
    } else {
      grouped.putIfAbsent(group, () => []).add('$argument: $literal');
    }
  }
  for (final MapEntry(:key, :value) in grouped.entries) {
    arguments[key] = '${groups[key] ?? key}(${value.join(', ')})';
  }
  return arguments;
}

Map<String, String?> _childArguments(
  ChildPolicy policy,
  List<GeneratedChild> children,
  bool required,
  String? argument,
) => switch (policy) {
  ChildPolicy.none => const {},
  ChildPolicy.single => {
    argument ?? _childArgument:
        dartChild(children) ?? (required ? _missingChild : null),
  },
  ChildPolicy.multiple => {
    argument ?? _childrenArgument: dartChildren(children),
  },
};

// The literal to write, or null when the property is unset or still equals
// the default that the constructor already has.
String? _emittedLiteral(PropSchema schema, NodeProps values) {
  final literal = _literal(schema, values);
  if (literal == null || schema.alwaysEmit) return literal;
  final defaultValue = schema.defaultValue;
  if (defaultValue == null) return literal;
  final defaultLiteral = _literal(
    schema,
    NodeProps({schema.name: defaultValue}),
  );
  return literal == defaultLiteral ? null : literal;
}

String? _literal(PropSchema schema, NodeProps values) {
  final name = schema.name;
  final raw = switch (schema.type) {
    PropType.string => values.string(name).let(dartString),
    PropType.number =>
      values
          .number(name)
          .let((v) => schema.integer ? '${v.round()}' : dartDouble(v)),
    PropType.boolean => values.boolean(name)?.toString(),
    PropType.color => values.color(name).let(dartColor),
    PropType.choice =>
      values.choice(name).let((v) => _choiceLiteral(schema, v)),
    PropType.edgeInsets => values.edgeInsets(name).let(dartEdgeInsets),
  };
  final template = schema.template;
  return raw == null || template == null
      ? raw
      : template.replaceFirst('{}', raw);
}

// A choice is written as `Enum.value` when an enum is named, as a bare
// identifier when a template builds the name (`Icons.{}`), and otherwise as
// a string.
String _choiceLiteral(PropSchema schema, String value) {
  final literal = schema.literals?[value];
  if (literal != null) return literal;
  final enumType = schema.enumType;
  if (enumType != null) return '$enumType.$value';
  return schema.template == null ? dartString(value) : value;
}
