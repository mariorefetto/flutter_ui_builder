import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/theme_editor.dart';

class ThemeParams {
  const ThemeParams({
    required this.document,
    required this.part,
    this.name = '',
    this.value,
  });

  final EditorDocument document;

  /// The part of the theme: `scheme`, `appBar`, `card`...
  final String part;

  /// The property of the part, for [SetThemeValue].
  final String name;

  /// The new value; null puts the default back.
  final Object? value;
}

class SetThemeValue implements SyncUseCase<EditorDocument, ThemeParams> {
  const SetThemeValue(this._editor);

  final ThemeEditor _editor;

  @override
  Either<Failure, EditorDocument> call(ThemeParams params) =>
      _editor.set(params.document, params.part, params.name, params.value);
}

class ResetThemePart implements SyncUseCase<EditorDocument, ThemeParams> {
  const ResetThemePart(this._editor);

  final ThemeEditor _editor;

  @override
  Either<Failure, EditorDocument> call(ThemeParams params) =>
      _editor.reset(params.document, params.part);
}
