import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/opened_document.dart';

abstract interface class DocumentRepository {
  /// Writes [document] to [path].
  Future<Either<Failure, Unit>> save(String path, EditorDocument document);

  /// Asks the user where to save and writes [document] there. Returns the
  /// chosen path, or null when the dialog is dismissed.
  Future<Either<Failure, String?>> saveAs(EditorDocument document);

  /// Asks the user for a project file and reads it. Returns null when the
  /// dialog is dismissed.
  Future<Either<Failure, OpenedDocument?>> open();
}
