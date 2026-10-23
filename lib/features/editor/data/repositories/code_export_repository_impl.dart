import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/local_file_data_source.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_file.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/media_asset.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/code_export_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:path/path.dart' as p;
import 'package:talker/talker.dart';

bool _same(Uint8List a, Uint8List b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

class CodeExportRepositoryImpl implements CodeExportRepository {
  const CodeExportRepositoryImpl(this._files, this._talker);

  final LocalFileDataSource _files;
  final Talker _talker;

  @override
  Future<Either<Failure, List<String>>> exportFiles(
    String directory,
    List<GeneratedFile> files, {
    List<MediaAsset> assets = const [],
  }) async {
    try {
      final paths = [for (final f in files) p.join(directory, f.fileName)];
      for (final path in paths) {
        final existing = await _files.readIfExists(path);
        if (existing != null && !existing.contains(generatedFileMarker)) {
          _talker.warning('Export refused, not a generated file: $path');
          return const Left(StorageFailure(StorageFailureReason.notGenerated));
        }
      }
      // The pictures are read and checked before anything is written, so a
      // conflict or a missing picture leaves the folder as it was.
      final copies = <(String, Uint8List)>[];
      for (final asset in assets) {
        final source = asset.sourcePath;
        if (source == null) continue;
        final bytes = await _files.readBytesIfExists(source);
        if (bytes == null) {
          return const Left(StorageFailure(StorageFailureReason.assetMissing));
        }
        final target = p.join(directory, asset.name);
        final existing = await _files.readBytesIfExists(target);
        if (existing == null) {
          copies.add((target, bytes));
        } else if (!_same(existing, bytes)) {
          _talker.warning('Export refused, different picture at: $target');
          return const Left(StorageFailure(StorageFailureReason.assetConflict));
        }
      }
      for (var i = 0; i < files.length; i++) {
        await _files.write(paths[i], files[i].content);
      }
      for (final (target, bytes) in copies) {
        await _files.writeBytes(target, bytes);
      }
      return Right([...paths, for (final (target, _) in copies) target]);
    } on AppException catch (e) {
      _talker.warning('Export failed: ${e.message}');
      return Left(e.toFailure());
    }
  }
}
