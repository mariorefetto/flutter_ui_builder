// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectScreenModel _$ProjectScreenModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ProjectScreenModel', json, ($checkedConvert) {
      final val = _ProjectScreenModel(
        name: $checkedConvert('name', (v) => v as String),
        root: $checkedConvert(
          'root',
          (v) => WidgetNodeModel.fromJson(v as Map<String, dynamic>),
        ),
        component: $checkedConvert('component', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$ProjectScreenModelToJson(_ProjectScreenModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'root': instance.root.toJson(),
      'component': instance.component,
    };
