import 'package:flutter_ui_builder/features/updates/domain/entities/app_release.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_version.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'release_model.freezed.dart';
part 'release_model.g.dart';

/// One release as the GitHub API describes it; only what the app uses.
@freezed
abstract class ReleaseModel with _$ReleaseModel {
  const factory ReleaseModel({
    @JsonKey(name: 'tag_name') required String tagName,
    @JsonKey(name: 'html_url') required String htmlUrl,
    @Default(false) bool draft,
    @Default(false) bool prerelease,
  }) = _ReleaseModel;

  factory ReleaseModel.fromJson(Map<String, dynamic> json) =>
      _$ReleaseModelFromJson(json);

  const ReleaseModel._();

  /// The release, or null when its tag is not a version number.
  AppRelease? toEntity() {
    final version = AppVersion.tryParse(tagName);
    if (version == null) return null;
    return AppRelease(version: version, url: htmlUrl, preRelease: prerelease);
  }
}
