import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/media_editor.dart';

class MediaParams {
  const MediaParams({
    required this.document,
    this.paths = const [],
    this.name = '',
  });

  final EditorDocument document;

  /// Files to add as pictures.
  final List<String> paths;

  /// The picture to remove.
  final String name;
}

class AddAssets implements SyncUseCase<EditorDocument, MediaParams> {
  const AddAssets(this._editor);

  final MediaEditor _editor;

  @override
  Either<Failure, EditorDocument> call(MediaParams params) =>
      Right(_editor.add(params.document, params.paths));
}

class RemoveAsset implements SyncUseCase<EditorDocument, MediaParams> {
  const RemoveAsset(this._editor);

  final MediaEditor _editor;

  @override
  Either<Failure, EditorDocument> call(MediaParams params) =>
      Right(_editor.remove(params.document, params.name));
}
