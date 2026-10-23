import 'package:flutter_ui_builder/features/editor/domain/entities/component_param.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

/// The parameters of a component as saved: a list of small maps. One that is
/// not understood is dropped, so a hand edited file still opens.
List<Map<String, dynamic>> paramsToJson(List<ComponentParam> params) => [
  for (final param in params)
    {
      'name': param.name,
      'type': param.type.name,
      'defaultValue': param.defaultValue,
    },
];

List<ComponentParam> paramsFromJson(List<Map<String, dynamic>> saved) => [
  for (final item in saved) ?_param(item),
];

ComponentParam? _param(Map<String, dynamic> item) {
  final name = item['name'];
  final type = PropType.values.asNameMap()[item['type']];
  final value = item['defaultValue'];
  if (name is! String || type == null || value == null) return null;
  return ComponentParam(name: name, type: type, defaultValue: value);
}
