import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/screen_templates.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';

class ScreenParams {
  const ScreenParams({
    required this.document,
    required this.name,
    this.to,
    this.template = ScreenTemplate.blank,
  });

  final EditorDocument document;

  /// The screen the operation is about.
  final String name;

  /// The new name, for a rename.
  final String? to;

  /// What a new screen starts from.
  final ScreenTemplate template;
}

class AddScreen implements SyncUseCase<EditorDocument, ScreenParams> {
  const AddScreen(this._editor);

  final ScreenEditor _editor;

  @override
  Either<Failure, EditorDocument> call(ScreenParams params) =>
      _editor.add(params.document, params.name, template: params.template);
}

class OpenScreen implements SyncUseCase<EditorDocument, ScreenParams> {
  const OpenScreen(this._editor);

  final ScreenEditor _editor;

  @override
  Either<Failure, EditorDocument> call(ScreenParams params) =>
      _editor.open(params.document, params.name);
}

class RenameScreen implements SyncUseCase<EditorDocument, ScreenParams> {
  const RenameScreen(this._editor);

  final ScreenEditor _editor;

  @override
  Either<Failure, EditorDocument> call(ScreenParams params) =>
      _editor.rename(params.document, params.name, params.to ?? '');
}

class DeleteScreen implements SyncUseCase<EditorDocument, ScreenParams> {
  const DeleteScreen(this._editor);

  final ScreenEditor _editor;

  @override
  Either<Failure, EditorDocument> call(ScreenParams params) =>
      _editor.delete(params.document, params.name);
}

class DuplicateScreen implements SyncUseCase<EditorDocument, ScreenParams> {
  const DuplicateScreen(this._editor);

  final ScreenEditor _editor;

  @override
  Either<Failure, EditorDocument> call(ScreenParams params) =>
      _editor.duplicate(params.document, params.name);
}

class MakeHomeScreen implements SyncUseCase<EditorDocument, ScreenParams> {
  const MakeHomeScreen(this._editor);

  final ScreenEditor _editor;

  @override
  Either<Failure, EditorDocument> call(ScreenParams params) =>
      _editor.makeHome(params.document, params.name);
}
