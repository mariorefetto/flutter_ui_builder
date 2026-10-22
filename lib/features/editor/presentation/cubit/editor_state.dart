import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/document_history.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_state.freezed.dart';

@freezed
abstract class EditorState with _$EditorState {
  const factory EditorState({
    required DocumentHistory history,

    /// Id of the selected node, or null when nothing is selected.
    String? selectedId,

    /// Set for one emission when the last user action was refused.
    Failure? failure,

    /// A copied or cut subtree, waiting to be pasted. It is not part of the
    /// document and is not undone.
    WidgetNode? clipboard,
  }) = _EditorState;

  // Freezed needs this private constructor to allow members and getters.
  const EditorState._();

  EditorDocument get document => history.present;
}
