// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaAssetModel _$MediaAssetModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MediaAssetModel', json, ($checkedConvert) {
      final val = _MediaAssetModel(
        name: $checkedConvert('name', (v) => v as String),
        sourcePath: $checkedConvert('sourcePath', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$MediaAssetModelToJson(_MediaAssetModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sourcePath': ?instance.sourcePath,
    };
