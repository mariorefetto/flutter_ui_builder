import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_history.freezed.dart';

/// Oldest snapshots are dropped once the undo stack grows past this size.
const int maxHistoryLength = 100;

/// Snapshots of the document for undo and redo.
@freezed
abstract class DocumentHistory with _$DocumentHistory {
  const factory DocumentHistory({
    required EditorDocument present,
    @Default(<EditorDocument>[]) List<EditorDocument> past,
    @Default(<EditorDocument>[]) List<EditorDocument> future,
  }) = _DocumentHistory;

  // Freezed needs this private constructor to allow members and getters.
  const DocumentHistory._();

  bool get canUndo => past.isNotEmpty;

  bool get canRedo => future.isNotEmpty;

  /// Makes [next] the present state and clears the redo stack.
  DocumentHistory record(EditorDocument next) {
    final trimmed = past.length >= maxHistoryLength ? past.sublist(1) : past;
    return DocumentHistory(present: next, past: [...trimmed, present]);
  }

  /// Steps back one snapshot. Returns this history when there is none.
  DocumentHistory undo() {
    if (!canUndo) return this;
    return DocumentHistory(
      present: past.last,
      past: past.sublist(0, past.length - 1),
      future: [present, ...future],
    );
  }

  /// Steps forward one snapshot. Returns this history when there is none.
  DocumentHistory redo() {
    if (!canRedo) return this;
    return DocumentHistory(
      present: future.first,
      past: [...past, present],
      future: future.sublist(1),
    );
  }
}
