// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_node_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WidgetNodeModel _$WidgetNodeModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_WidgetNodeModel', json, ($checkedConvert) {
      final val = _WidgetNodeModel(
        id: $checkedConvert('id', (v) => v as String),
        type: $checkedConvert('type', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String?),
        props: $checkedConvert(
          'props',
          (v) => v as Map<String, dynamic>? ?? const <String, dynamic>{},
        ),
        children: $checkedConvert(
          'children',
          (v) =>
              (v as List<dynamic>?)
                  ?.map(
                    (e) => WidgetNodeModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList() ??
              const <WidgetNodeModel>[],
        ),
      );
      return val;
    });

Map<String, dynamic> _$WidgetNodeModelToJson(_WidgetNodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'label': ?instance.label,
      'props': instance.props,
      'children': instance.children.map((e) => e.toJson()).toList(),
    };
