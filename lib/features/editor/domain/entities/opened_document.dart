import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';

/// A document read from disk together with the file it came from.
class OpenedDocument {
  const OpenedDocument({required this.document, required this.path});

  final EditorDocument document;
  final String path;
}
