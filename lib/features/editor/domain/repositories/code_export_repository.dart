import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_file.dart';

abstract interface class CodeExportRepository {
  /// Writes [files] into [directory] and returns the paths written. A file
  /// that already exists is replaced only if it was generated before.
  Future<Either<Failure, List<String>>> exportFiles(
    String directory,
    List<GeneratedFile> files,
  );
}
