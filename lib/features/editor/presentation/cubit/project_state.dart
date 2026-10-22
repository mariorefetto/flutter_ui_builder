import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_state.freezed.dart';

/// One-off outcome of a file operation. It is emitted once and cleared right
/// away, so a listener reacts to it a single time.
sealed class ProjectEvent {
  const ProjectEvent();
}

final class ProjectOpened extends ProjectEvent {
  const ProjectOpened(this.document);

  final EditorDocument document;
}

final class ProjectSaved extends ProjectEvent {
  const ProjectSaved();
}

final class ProjectFailed extends ProjectEvent {
  const ProjectFailed(this.failure);

  final Failure failure;
}

@freezed
abstract class ProjectState with _$ProjectState {
  const factory ProjectState({
    /// The document as last saved or opened. A fresh project counts as saved.
    required EditorDocument savedDocument,

    /// File the project is bound to, or null before the first save.
    String? filePath,
    ProjectEvent? event,
  }) = _ProjectState;
}
