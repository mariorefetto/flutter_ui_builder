import 'package:freezed_annotation/freezed_annotation.dart';

part 'drag_session_state.freezed.dart';

/// What is being dragged and what it is over, for the highlights in the
/// designer and in the outline. Interface state only.
@freezed
abstract class DragSessionState with _$DragSessionState {
  const factory DragSessionState({
    /// Id of the node being moved, or null for a new widget from the toolbox
    /// or when nothing is dragged.
    String? draggedId,

    /// A drag is in progress, whatever it carries.
    @Default(false) bool active,

    /// The node the pointer is over and that would accept the drop.
    String? targetId,
  }) = _DragSessionState;
}
