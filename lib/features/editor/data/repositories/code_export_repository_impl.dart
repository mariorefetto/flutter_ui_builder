import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/local_file_data_source.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_file.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/code_export_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:path/path.dart' as p;
import 'package:talker/talker.dart';

class CodeExportRepositoryImpl implements CodeExportRepository {
  const CodeExportRepositoryImpl(this._files, this._talker);

  final LocalFileDataSource _files;
  final Talker _talker;

  @override
  Future<Either<Failure, List<String>>> exportFiles(
    String directory,
    List<GeneratedFile> files,
  ) async {
    try {
      final paths = [for (final f in files) p.join(directory, f.fileName)];
      for (final path in paths) {
        final existing = await _files.readIfExists(path);
        if (existing != null && !existing.contains(generatedFileMarker)) {
          _talker.warning('Export refused, not a generated file: $path');
          return const Left(StorageFailure(StorageFailureReason.notGenerated));
        }
      }
      for (var i = 0; i < files.length; i++) {
        await _files.write(paths[i], files[i].content);
      }
      return Right(paths);
    } on AppException catch (e) {
      _talker.warning('Export failed: ${e.message}');
      return Left(e.toFailure());
    }
  }
}
