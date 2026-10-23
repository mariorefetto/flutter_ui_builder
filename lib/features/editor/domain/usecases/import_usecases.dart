import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_screen.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_importer.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/document_reconciler.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/source_file_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';

/// Builds a document from Dart code.
class ImportCode implements SyncUseCase<ImportResult, String> {
  const ImportCode(this._importer);

  final CodeImporter _importer;

  @override
  Either<Failure, ImportResult> call(String params) => _importer.import(params);
}

/// Lets the user pick a Dart file and reads it.
class PickDartSource implements UseCase<String?, NoParams> {
  const PickDartSource(this._repository);

  final SourceFileRepository _repository;

  @override
  Future<Either<Failure, String?>> call(NoParams params) =>
      _repository.pickAndRead();
}

class ApplyImportParams {
  const ApplyImportParams({required this.previous, required this.imported});

  final EditorDocument previous;
  final ImportResult imported;
}

/// Turns code that was edited into the new version of the open document.
class ApplyImport implements SyncUseCase<EditorDocument, ApplyImportParams> {
  const ApplyImport(this._reconciler);

  final DocumentReconciler _reconciler;

  @override
  Either<Failure, EditorDocument> call(ApplyImportParams params) =>
      Right(_reconciler.reconcile(params.previous, params.imported));
}

/// The project an import makes: the first screen of the code and, when the
/// code has several widget classes, the rest of them as screens and
/// components of the same project.
class BuildImportedProject
    implements SyncUseCase<EditorDocument, ImportResult> {
  const BuildImportedProject();

  @override
  Either<Failure, EditorDocument> call(ImportResult params) => Right(
    const ScreenEditor().include(params.document, [
      for (final extra in params.extras)
        ProjectScreen(
          name: extra.document.name,
          root: extra.document.root,
          component: extra.document.component,
        ),
    ]),
  );
}
