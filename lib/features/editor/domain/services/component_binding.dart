import 'package:flutter_ui_builder/features/editor/domain/entities/component_param.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';

/// The key of the stored form of a bound property: `{'param': 'title'}`.
const String bindingKey = 'param';

/// The prefix of the properties of a use of a component that carry the values
/// of its parameters: `arg.title`.
const String argumentPrefix = 'arg.';

/// The name of the parameter a stored property value is bound to, or null
/// when it is an ordinary value.
String? boundParam(Object? stored) =>
    stored is Map && stored[bindingKey] is String
    ? stored[bindingKey] as String
    : null;

/// The stored form of a property bound to the parameter [name].
Map<String, Object?> bindingTo(String name) => {bindingKey: name};

/// The values a use of a component gives, by parameter name.
Map<String, Object?> argumentsOf(WidgetNode use) => {
  for (final entry in use.props.entries)
    if (entry.key.startsWith(argumentPrefix))
      entry.key.substring(argumentPrefix.length): entry.value,
};

/// [root] with each bound property given a value: the one in [arguments] when
/// it has the right kind, or else the parameter's default. This is the
/// component as one use of it looks.
WidgetNode bindArguments(
  WidgetNode root,
  List<ComponentParam> params,
  Map<String, Object?> arguments,
) {
  final byName = {for (final param in params) param.name: param};
  Object? valueOf(String name) {
    final param = byName[name];
    if (param == null) return null;
    final given = arguments[name];
    return _fits(param.type, given) ? given : param.defaultValue;
  }

  WidgetNode visit(WidgetNode node) {
    final props = <String, Object?>{};
    for (final entry in node.props.entries) {
      final name = boundParam(entry.value);
      if (name == null) {
        props[entry.key] = entry.value;
      } else if (valueOf(name) case final value?) {
        props[entry.key] = value;
      }
    }
    return node.copyWith(
      props: props,
      children: [for (final child in node.children) visit(child)],
    );
  }

  return visit(root);
}

bool _fits(PropType type, Object? value) => switch (type) {
  PropType.string => value is String,
  PropType.number => value is num,
  PropType.color => value is int,
  _ => false,
};

/// The names of the parameters some property of [root] is bound to.
Set<String> usedParams(WidgetNode root) => {
  for (final entry in root.props.values) ?boundParam(entry),
  for (final child in root.children) ...usedParams(child),
};

/// A component's tree with a recognisable stand-in value where each parameter
/// is bound, and what to put in the code for each stand-in once it is written.
class ParamStandIns {
  const ParamStandIns(this.root, this.replacements);

  final WidgetNode root;

  /// The code written for a stand-in, mapped to the parameter's name.
  final Map<String, String> replacements;

  /// [code] with every stand-in replaced by the name of its parameter.
  String apply(String code) => replacements.entries.fold(
    code,
    (text, entry) => text.replaceAll(entry.key, entry.value),
  );
}

const double _numberStandIn = 7771;
const int _colorStandIn = 0xFE000000;

/// Replaces each bound property of [root] by a stand-in value that the code
/// generator writes as a literal nobody else writes: a text of its own, a
/// number such as 7771.0, a colour such as 0xFE000000. The generator then puts
/// the parameter's name in the place of the literal, which is how a bound
/// property is written as a variable instead of a value.
ParamStandIns standInsFor(
  WidgetNode root,
  List<ComponentParam> params,
  String Function(Object value, PropType type) literal,
) {
  final values = <String, Object>{};
  final replacements = <String, String>{};
  for (final (index, param) in params.indexed) {
    final value = switch (param.type) {
      PropType.string => '__param_${param.name}__',
      PropType.number => _numberStandIn + index,
      _ => _colorStandIn + index,
    };
    values[param.name] = value;
    replacements[literal(value, param.type)] = param.name;
  }
  WidgetNode visit(WidgetNode node) {
    final props = <String, Object?>{};
    for (final entry in node.props.entries) {
      final name = boundParam(entry.value);
      if (name == null) {
        props[entry.key] = entry.value;
      } else if (values[name] case final value?) {
        props[entry.key] = value;
      }
    }
    return node.copyWith(
      props: props,
      children: [for (final child in node.children) visit(child)],
    );
  }

  return ParamStandIns(visit(root), replacements);
}
