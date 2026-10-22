import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/drag_session_state.dart';

/// Tracks the drag in progress so the designer and the outline can highlight
/// the widget being moved and the place it would land.
class DragSessionCubit extends Cubit<DragSessionState> {
  DragSessionCubit() : super(const DragSessionState());

  /// A drag began. [nodeId] is the node being moved, null for a new widget.
  void start({String? nodeId}) =>
      emit(DragSessionState(draggedId: nodeId, active: true));

  void end() => emit(const DragSessionState());

  /// The pointer is over [nodeId], which would take the drop.
  void hover(String nodeId) {
    if (state.active && state.targetId != nodeId) {
      emit(state.copyWith(targetId: nodeId));
    }
  }

  /// The pointer left [nodeId].
  void leave(String nodeId) {
    if (state.targetId == nodeId) emit(state.copyWith(targetId: null));
  }
}
