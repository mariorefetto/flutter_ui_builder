import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';

/// Outcome of a successful edit: the new document and the node the edit is
/// about (the added or moved node, or the former parent of a removed one).
class EditResult {
  const EditResult({required this.document, required this.nodeId});

  final EditorDocument document;
  final String nodeId;
}
