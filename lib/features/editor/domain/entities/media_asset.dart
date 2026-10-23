import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_asset.freezed.dart';

/// A picture of the project. The [name] is how the code refers to it, such as
/// `assets/logo.png`; the [sourcePath] is the file on this computer it was
/// taken from, which the designer draws it from.
@freezed
abstract class MediaAsset with _$MediaAsset {
  const factory MediaAsset({required String name, String? sourcePath}) =
      _MediaAsset;
}
