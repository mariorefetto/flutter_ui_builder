import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_state.freezed.dart';

/// Panels that can dock on the left.
enum LeftPanel { toolbox, outline, media, theme }

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

/// Where the code sits: as a tab of the central area, or beside or under the
/// designer so both can be seen at once.
enum CodePlacement { tab, right, bottom }

/// Smallest and largest width a docked panel can be dragged to.
const double minPanelWidth = 180;
const double maxPanelWidth = 480;

/// The zoom steps of the designer, from a quarter to double size.
const List<double> zoomSteps = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 2];

/// Smallest and largest size of the code panel along the axis it is resized.
const double minCodeExtent = 200;
const double maxCodeExtent = 900;

/// How many recently added widgets the palette remembers.
const int maxRecentWidgets = 6;

const double _defaultCodeWidth = 460;
const double _defaultCodeHeight = 300;
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
    @Default(CodePlacement.tab) CodePlacement codePlacement,
    @Default(_defaultCodeWidth) double codeWidth,
    @Default(_defaultCodeHeight) double codeHeight,

    /// The screen the designer previews the project on.
    @Default(PreviewDevice.phone) PreviewDevice device,
    @Default(false) bool landscape,

    /// Draw the body of the device around the screen, with its status bar.
    @Default(true) bool showFrame,
    @Default(StatusBarMode.auto) StatusBarMode statusBar,

    /// Tint the areas the system covers, which a SafeArea keeps clear.
    @Default(false) bool showSafeArea,

    /// Try the project as it would run: a widget that opens a screen does so
    /// when clicked, and nothing is selected or dragged.
    @Default(false) bool prototype,

    /// The screens opened by clicking in prototype mode, oldest first, so a
    /// widget that goes back returns to the one before.
    @Default(<String>[]) List<String> screenTrail,

    /// Designer scale: 1 is actual size.
    @Default(1.0) double zoom,

    /// Widget types added lately, newest first.
    @Default(<String>[]) List<String> recentWidgets,
    @Default(_defaultLeftWidth) double leftWidth,
    @Default(_defaultRightWidth) double rightWidth,
  }) = _WorkspaceState;
}
