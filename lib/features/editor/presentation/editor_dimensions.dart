// Geometry that belongs to the editor and has no matching token in the theme:
// panel widths, the size of the previewed screen and a few preview fallbacks.
// Spacing, radii and border widths come from AppConstants.

const double paletteWidth = 240;
const double sidePanelWidth = 300;
const double draggedOpacity = 0.4;

/// Half of a normalized extent, used to tell which half of a node is hit.
const double halfExtent = 0.5;

/// Logical size of the screen a Scaffold is previewed in.
const double previewScreenWidth = 390;
const double previewScreenHeight = 844;

/// Size given to a Stack that has only positioned children, in the preview.
const double positionedStackSize = 200;

/// Height of the problems panel under the workspace.
const double problemsPanelHeight = 200;

/// Width of the import code dialog.
const double importDialogWidth = 640;

/// Opacity of the tint that marks the areas the system covers.
const double safeAreaTintOpacity = 0.18;

/// Tallest the list of problems under the code editor grows.
const double codeProblemsMaxHeight = 160;

/// Opacity of the tint over a widget that would take a drop inside it.
const double dropTintOpacity = 0.1;

/// Size of the icon picker dialog and of each icon in it.
const double iconPickerWidth = 520;
const double iconPickerHeight = 420;
const double iconTileSize = 56;
