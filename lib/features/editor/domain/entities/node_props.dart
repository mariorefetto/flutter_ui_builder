import 'package:flutter_ui_builder/features/editor/domain/entities/edge_insets_value.dart';

/// Property values of one node with the schema defaults already applied.
///
/// Getters return null when a property is absent or has an unexpected type, so
/// a hand edited document never crashes the preview or the code generator.
class NodeProps {
  const NodeProps(this._values);

  final Map<String, Object?> _values;

  String? string(String name) => _typed<String>(name);

  double? number(String name) => _typed<num>(name)?.toDouble();

  bool? boolean(String name) => _typed<bool>(name);

  /// ARGB color value.
  int? color(String name) => _typed<int>(name);

  String? choice(String name) => _typed<String>(name);

  EdgeInsetsValue? edgeInsets(String name) =>
      EdgeInsetsValue.tryParse(_values[name]);

  /// Like [string] but fails loudly: use for properties with a schema default.
  String requiredString(String name) => _required(name, string(name));

  double requiredNumber(String name) => _required(name, number(name));

  String requiredChoice(String name) => _required(name, choice(name));

  T? _typed<T>(String name) {
    final value = _values[name];
    return value is T ? value : null;
  }

  T _required<T>(String name, T? value) {
    if (value == null) {
      throw StateError('Property "$name" is missing or has the wrong type');
    }
    return value;
  }
}
