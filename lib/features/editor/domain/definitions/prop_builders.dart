import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

// Short constructors for the PropSchema entries that definitions repeat.

const String _iconTemplate = 'Icon(Icons.{})';
const String _radiusTemplate = 'BorderRadius.circular({})';
const String _shapeTemplate =
    'RoundedRectangleBorder(borderRadius: BorderRadius.circular({}))';

PropSchema numberProp(
  String name, {
  num? defaultValue,
  bool integer = false,
  bool alwaysEmit = false,
  String? argument,
  String? group,
  String? template,
}) => PropSchema(
  name: name,
  type: PropType.number,
  defaultValue: defaultValue,
  integer: integer,
  alwaysEmit: alwaysEmit,
  argument: argument,
  group: group,
  template: template,
);

PropSchema colorProp(
  String name, {
  int? defaultValue,
  bool alwaysEmit = false,
  String? argument,
  String? group,
}) => PropSchema(
  name: name,
  type: PropType.color,
  defaultValue: defaultValue,
  alwaysEmit: alwaysEmit,
  argument: argument,
  group: group,
);

PropSchema boolProp(
  String name, {
  bool? defaultValue,
  String? argument,
  String? group,
}) => PropSchema(
  name: name,
  type: PropType.boolean,
  defaultValue: defaultValue,
  argument: argument,
  group: group,
);

PropSchema stringProp(
  String name, {
  String? defaultValue,
  bool alwaysEmit = false,
  String? argument,
  String? group,
  String? template,
}) => PropSchema(
  name: name,
  type: PropType.string,
  defaultValue: defaultValue,
  alwaysEmit: alwaysEmit,
  argument: argument,
  group: group,
  template: template,
);

/// A string written as `Text('...')`.
PropSchema textProp(
  String name, {
  String? defaultValue,
  String? argument,
  String? group,
}) => stringProp(
  name,
  defaultValue: defaultValue,
  alwaysEmit: defaultValue != null,
  argument: argument,
  group: group,
  template: 'Text({})',
);

PropSchema choiceProp(
  String name,
  List<String> options, {
  String? defaultValue,
  String? enumType,
  String? argument,
  String? group,
  Map<String, String>? literals,
  bool alwaysEmit = false,
}) => PropSchema(
  name: name,
  type: PropType.choice,
  options: options,
  defaultValue: defaultValue,
  enumType: enumType,
  argument: argument,
  group: group,
  literals: literals,
  alwaysEmit: alwaysEmit,
);

/// An icon picked by name and written as `Icon(Icons.name)`.
PropSchema iconProp(
  String name, {
  String? defaultValue,
  String? argument,
  String? group,
  String? template,
}) => PropSchema(
  name: name,
  type: PropType.choice,
  options: iconOptions,
  defaultValue: defaultValue,
  alwaysEmit: defaultValue != null,
  argument: argument,
  group: group,
  template: template ?? _iconTemplate,
  iconPicker: true,
);

PropSchema insetsProp(
  String name, {
  List<double>? defaultValue,
  bool alwaysEmit = false,
  String? argument,
  String? group,
}) => PropSchema(
  name: name,
  type: PropType.edgeInsets,
  defaultValue: defaultValue,
  alwaysEmit: alwaysEmit,
  argument: argument,
  group: group,
);

/// A corner radius written as `BorderRadius.circular(r)`.
PropSchema radiusProp(
  String name, {
  num? defaultValue,
  bool alwaysEmit = false,
  String? argument,
  String? group,
}) => numberProp(
  name,
  defaultValue: defaultValue,
  alwaysEmit: alwaysEmit,
  argument: argument,
  group: group,
  template: _radiusTemplate,
);

/// A corner radius written as a rounded rectangle `shape`.
PropSchema shapeRadiusProp(String name, {String? group}) =>
    numberProp(name, argument: 'shape', group: group, template: _shapeTemplate);

/// An icon picked by name, written bare (`Icons.name` is built by the widget
/// itself, as for Icon).
PropSchema iconPickerProp(String name, {String? defaultValue}) => PropSchema(
  name: name,
  type: PropType.choice,
  options: iconOptions,
  defaultValue: defaultValue,
  iconPicker: true,
);
