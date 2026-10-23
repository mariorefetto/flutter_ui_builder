// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReleaseModel _$ReleaseModelFromJson(Map<String, dynamic> json) =>
    _ReleaseModel(
      tagName: json['tag_name'] as String,
      htmlUrl: json['html_url'] as String,
      draft: json['draft'] as bool? ?? false,
      prerelease: json['prerelease'] as bool? ?? false,
    );

Map<String, dynamic> _$ReleaseModelToJson(_ReleaseModel instance) =>
    <String, dynamic>{
      'tag_name': instance.tagName,
      'html_url': instance.htmlUrl,
      'draft': instance.draft,
      'prerelease': instance.prerelease,
    };
