import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/opened_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/document_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/file_dialog_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_validator.dart';

class SaveDocumentParams {
  const SaveDocumentParams({required this.path, required this.document});

  final String path;
  final EditorDocument document;
}

class SaveDocument implements UseCase<Unit, SaveDocumentParams> {
  const SaveDocument(this._repository);

  final DocumentRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(SaveDocumentParams params) =>
      _repository.save(params.path, params.document);
}

class SaveDocumentAs implements UseCase<String?, EditorDocument> {
  const SaveDocumentAs(this._repository);

  final DocumentRepository _repository;

  @override
  Future<Either<Failure, String?>> call(EditorDocument params) =>
      _repository.saveAs(params);
}

/// Opens a project file and rejects documents that cannot be edited.
class OpenDocument implements UseCase<OpenedDocument?, NoParams> {
  const OpenDocument(this._repository, this._validator);

  final DocumentRepository _repository;
  final DocumentValidator _validator;

  @override
  Future<Either<Failure, OpenedDocument?>> call(NoParams params) async {
    final opened = await _repository.open();
    return opened.flatMap((value) {
      if (value == null) return const Right(null);
      return _validator.validate(value.document).map((_) => value);
    });
  }
}

class RenameDocumentParams {
  const RenameDocumentParams({required this.document, required this.name});

  final EditorDocument document;
  final String name;
}

class RenameDocument
    implements SyncUseCase<EditorDocument, RenameDocumentParams> {
  const RenameDocument();

  @override
  Either<Failure, EditorDocument> call(RenameDocumentParams params) {
    final name = params.name.trim();
    if (name.isEmpty) {
      return const Left(DocumentFailure(DocumentFailureReason.emptyName));
    }
    return Right(params.document.copyWith(name: name));
  }
}

/// Lets the user pick pictures for the project.
class PickImages implements UseCase<List<String>, NoParams> {
  const PickImages(this._dialogs);

  final FileDialogRepository _dialogs;

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) =>
      _dialogs.pickImages();
}
