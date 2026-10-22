// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editor_document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditorDocumentModel _$EditorDocumentModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_EditorDocumentModel', json, ($checkedConvert) {
      final val = _EditorDocumentModel(
        name: $checkedConvert('name', (v) => v as String),
        root: $checkedConvert(
          'root',
          (v) => WidgetNodeModel.fromJson(v as Map<String, dynamic>),
        ),
        screens: $checkedConvert(
          'screens',
          (v) =>
              (v as List<dynamic>?)
                  ?.map(
                    (e) =>
                        ProjectScreenModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList() ??
              const <ProjectScreenModel>[],
        ),
        activeIndex: $checkedConvert(
          'activeIndex',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
        schemaVersion: $checkedConvert(
          'schemaVersion',
          (v) => (v as num?)?.toInt() ?? currentSchemaVersion,
        ),
      );
      return val;
    });

Map<String, dynamic> _$EditorDocumentModelToJson(
  _EditorDocumentModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'root': instance.root.toJson(),
  'screens': instance.screens.map((e) => e.toJson()).toList(),
  'activeIndex': instance.activeIndex,
  'schemaVersion': instance.schemaVersion,
};
