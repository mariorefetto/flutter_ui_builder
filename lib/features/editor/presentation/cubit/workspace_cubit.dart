import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';

/// Holds the window layout. It is interface state only and never touches the
/// document.
class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit([super.initialState = const WorkspaceState()]);

  /// Opens [panel], or collapses the left dock when it is already open.
  void toggleLeftPanel(LeftPanel panel) =>
      emit(state.copyWith(leftPanel: state.leftPanel == panel ? null : panel));

  void closeLeftPanel() => emit(state.copyWith(leftPanel: null));

  void toggleProperties() =>
      emit(state.copyWith(propertiesVisible: !state.propertiesVisible));

  void toggleProblems() =>
      emit(state.copyWith(problemsVisible: !state.problemsVisible));

  void showCenterTab(CenterTab tab) => emit(state.copyWith(centerTab: tab));

  /// Moves the code beside or under the designer, or back to a tab. The tab
  /// shown goes back to the designer, so that leaving the split never leaves
  /// the code as the only thing in view by accident.
  void setCodePlacement(CodePlacement placement) => emit(
    state.copyWith(
      codePlacement: placement,
      centerTab: placement == CodePlacement.tab
          ? state.centerTab
          : CenterTab.design,
    ),
  );

  /// Widens the code panel docked on the right by [delta].
  void resizeCodeWidth(double delta) =>
      emit(state.copyWith(codeWidth: _clampCode(state.codeWidth + delta)));

  /// Heightens the code panel docked at the bottom by [delta].
  void resizeCodeHeight(double delta) =>
      emit(state.copyWith(codeHeight: _clampCode(state.codeHeight + delta)));

  double _clampCode(double extent) =>
      extent.clamp(minCodeExtent, maxCodeExtent);

  /// Remembers that a widget of [type] was added, for the palette's recent
  /// list: it moves to the front and the oldest drops off.
  void noteAdded(String type) => emit(
    state.copyWith(
      recentWidgets: [
        type,
        ...state.recentWidgets.where((t) => t != type),
      ].take(maxRecentWidgets).toList(),
    ),
  );

  void togglePrototype() =>
      emit(state.copyWith(prototype: !state.prototype, screenTrail: const []));

  /// Notes that the screen [from] was left for another by a click.
  void trailPush(String from) =>
      emit(state.copyWith(screenTrail: [...state.screenTrail, from]));

  /// The screen to go back to, which leaves the trail; null at the start.
  String? trailPop() {
    final trail = state.screenTrail;
    if (trail.isEmpty) return null;
    emit(state.copyWith(screenTrail: trail.sublist(0, trail.length - 1)));
    return trail.last;
  }

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
