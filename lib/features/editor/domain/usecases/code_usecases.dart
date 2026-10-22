import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_file.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/code_export_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/file_dialog_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';

class GenerateCode implements SyncUseCase<List<GeneratedFile>, EditorDocument> {
  const GenerateCode(this._generator);

  final DocumentCodeGenerator _generator;

  @override
  Either<Failure, List<GeneratedFile>> call(EditorDocument params) =>
      _generator.generate(params).map((file) => [file]);
}

class PickExportDirectory implements UseCase<String?, NoParams> {
  const PickExportDirectory(this._dialogs);

  final FileDialogRepository _dialogs;

  @override
  Future<Either<Failure, String?>> call(NoParams params) =>
      _dialogs.pickDirectory();
}

class ExportCodeParams {
  const ExportCodeParams({required this.directory, required this.files});

  final String directory;
  final List<GeneratedFile> files;
}

class ExportCode implements UseCase<List<String>, ExportCodeParams> {
  const ExportCode(this._repository);

  final CodeExportRepository _repository;

  @override
  Future<Either<Failure, List<String>>> call(ExportCodeParams params) =>
      _repository.exportFiles(params.directory, params.files);
}
