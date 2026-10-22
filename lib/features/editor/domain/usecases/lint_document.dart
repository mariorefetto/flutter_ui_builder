import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/problem.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_linter.dart';

class LintDocument implements SyncUseCase<List<Problem>, EditorDocument> {
  const LintDocument(this._linter);

  final DocumentLinter _linter;

  @override
  Either<Failure, List<Problem>> call(EditorDocument params) =>
      Right(_linter.lint(params));
}
