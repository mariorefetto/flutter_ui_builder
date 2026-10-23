import 'package:flutter_ui_builder/features/editor/domain/entities/media_asset.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_asset_model.freezed.dart';
part 'media_asset_model.g.dart';

/// JSON representation of a MediaAsset.
@freezed
abstract class MediaAssetModel with _$MediaAssetModel {
  @JsonSerializable(includeIfNull: false, checked: true)
  const factory MediaAssetModel({required String name, String? sourcePath}) =
      _MediaAssetModel;

  factory MediaAssetModel.fromJson(Map<String, dynamic> json) =>
      _$MediaAssetModelFromJson(json);

  factory MediaAssetModel.fromEntity(MediaAsset asset) =>
      MediaAssetModel(name: asset.name, sourcePath: asset.sourcePath);

  const MediaAssetModel._();

  MediaAsset toEntity() => MediaAsset(name: name, sourcePath: sourcePath);
}
