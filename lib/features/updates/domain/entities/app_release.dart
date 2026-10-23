import 'package:flutter_ui_builder/features/updates/domain/entities/app_version.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_release.freezed.dart';

/// A published version of the app.
@freezed
abstract class AppRelease with _$AppRelease {
  const factory AppRelease({
    required AppVersion version,

    /// The page where the version is described and can be downloaded.
    required String url,

    /// The release is marked as a pre-release.
    @Default(false) bool preRelease,
  }) = _AppRelease;
}
