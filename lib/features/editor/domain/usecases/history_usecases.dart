import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/document_history.dart';

class UndoEdit implements SyncUseCase<DocumentHistory, DocumentHistory> {
  const UndoEdit();

  @override
  Either<Failure, DocumentHistory> call(DocumentHistory params) =>
      params.canUndo
      ? Right(params.undo())
      : const Left(TreeFailure(TreeFailureReason.nothingToUndo));
}

class RedoEdit implements SyncUseCase<DocumentHistory, DocumentHistory> {
  const RedoEdit();

  @override
  Either<Failure, DocumentHistory> call(DocumentHistory params) =>
      params.canRedo
      ? Right(params.redo())
      : const Left(TreeFailure(TreeFailureReason.nothingToRedo));
}
