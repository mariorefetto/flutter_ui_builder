import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/project_theme_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_theme.dart';

/// Changes the theme of a project.
class ThemeEditor {
  const ThemeEditor();

  /// Sets the value [name] of the theme part [part]. A null [value] puts the
  /// default back. A part, a property or a value the theme does not know is
  /// refused, so the stored theme only ever holds what can be written out.
  Either<Failure, EditorDocument> set(
    EditorDocument document,
    String part,
    String name,
    Object? value,
  ) {
    final definition = themePartNamed(part);
    final schema = definition?.props.where((p) => p.name == name).firstOrNull;
    if (definition == null || schema == null) return _invalid();
    if (value != null && !schema.accepts(value)) return _invalid();
    final parts = {
      for (final entry in document.theme.parts.entries)
        entry.key: {...entry.value},
    };
    final values = parts.putIfAbsent(part, () => {});
    if (value == null) {
      values.remove(name);
    } else {
      values[name] = value;
    }
    if (values.isEmpty) parts.remove(part);
    return Right(document.copyWith(theme: ProjectTheme(parts: parts)));
  }

  /// Puts the part [part] back to the defaults.
  Either<Failure, EditorDocument> reset(EditorDocument document, String part) {
    if (themePartNamed(part) == null) return _invalid();
    final parts = {...document.theme.parts}..remove(part);
    return Right(document.copyWith(theme: ProjectTheme(parts: parts)));
  }

  Either<Failure, EditorDocument> _invalid() =>
      const Left(DocumentFailure(DocumentFailureReason.invalidStructure));
}
