import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';

/// Holds the window layout. It is interface state only and never touches the
/// document.
class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit() : super(const WorkspaceState());

  /// Opens [panel], or collapses the left dock when it is already open.
  void toggleLeftPanel(LeftPanel panel) =>
      emit(state.copyWith(leftPanel: state.leftPanel == panel ? null : panel));

  void closeLeftPanel() => emit(state.copyWith(leftPanel: null));

  void toggleProperties() =>
      emit(state.copyWith(propertiesVisible: !state.propertiesVisible));

  void toggleProblems() =>
      emit(state.copyWith(problemsVisible: !state.problemsVisible));

  void showCenterTab(CenterTab tab) => emit(state.copyWith(centerTab: tab));

  void setDevice(PreviewDevice device) => emit(state.copyWith(device: device));

  void toggleFrame() => emit(state.copyWith(showFrame: !state.showFrame));

  void toggleSafeArea() =>
      emit(state.copyWith(showSafeArea: !state.showSafeArea));

  void setStatusBar(StatusBarMode mode) =>
      emit(state.copyWith(statusBar: mode));

  void toggleOrientation() => emit(state.copyWith(landscape: !state.landscape));

  /// The next larger zoom step, or the current one at the largest.
  void zoomIn() => emit(
    state.copyWith(
      zoom: zoomSteps.firstWhere(
        (step) => step > state.zoom,
        orElse: () => zoomSteps.last,
      ),
    ),
  );

  /// The next smaller zoom step, or the current one at the smallest.
  void zoomOut() => emit(
    state.copyWith(
      zoom: zoomSteps.lastWhere(
        (step) => step < state.zoom,
        orElse: () => zoomSteps.first,
      ),
    ),
  );

  void resetZoom() => emit(state.copyWith(zoom: 1));

  /// Widens the left dock by [delta], within the allowed range.
  void resizeLeft(double delta) =>
      emit(state.copyWith(leftWidth: _clamp(state.leftWidth + delta)));

  /// Widens the right dock by [delta], within the allowed range.
  void resizeRight(double delta) =>
      emit(state.copyWith(rightWidth: _clamp(state.rightWidth + delta)));

  double _clamp(double width) => width.clamp(minPanelWidth, maxPanelWidth);
}
