import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_state.freezed.dart';

/// Panels that can dock on the left.
enum LeftPanel { toolbox, outline }

/// How the status bar of the previewed device is shown.
enum StatusBarMode {
  /// Icons light or dark, chosen from the AppBar of the project.
  auto,
  light,
  dark,
  hidden,
}

/// What the central area shows.
enum CenterTab { design, code }

/// Smallest and largest width a docked panel can be dragged to.
const double minPanelWidth = 180;
const double maxPanelWidth = 480;

/// The zoom steps of the designer, from a quarter to double size.
const List<double> zoomSteps = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 2];

const double _defaultLeftWidth = 260;
const double _defaultRightWidth = 320;

/// Layout of the editor window: which panels are open, how wide they are and
/// which tab of the central area is active.
@freezed
abstract class WorkspaceState with _$WorkspaceState {
  const factory WorkspaceState({
    /// The open left panel, or null when the left dock is collapsed.
    @Default(LeftPanel.toolbox) LeftPanel? leftPanel,
    @Default(true) bool propertiesVisible,
    @Default(false) bool problemsVisible,
    @Default(CenterTab.design) CenterTab centerTab,

    /// The screen the designer previews the project on.
    @Default(PreviewDevice.phone) PreviewDevice device,
    @Default(false) bool landscape,

    /// Draw the body of the device around the screen, with its status bar.
    @Default(true) bool showFrame,
    @Default(StatusBarMode.auto) StatusBarMode statusBar,

    /// Tint the areas the system covers, which a SafeArea keeps clear.
    @Default(false) bool showSafeArea,

    /// Designer scale: 1 is actual size.
    @Default(1.0) double zoom,
    @Default(_defaultLeftWidth) double leftWidth,
    @Default(_defaultRightWidth) double rightWidth,
  }) = _WorkspaceState;
}
