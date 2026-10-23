import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_file.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/media_asset.dart';

abstract interface class CodeExportRepository {
  /// Writes [files] into [directory] and returns the paths written. A file
  /// that already exists is replaced only if it was generated before.
  ///
  /// The [assets] with a source file are copied to their names under
  /// [directory]. One that is already there with the same content is left;
  /// one that is there with other content stops the export before anything
  /// is written.
  Future<Either<Failure, List<String>>> exportFiles(
    String directory,
    List<GeneratedFile> files, {
    List<MediaAsset> assets = const [],
  });
}
