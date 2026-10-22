import 'package:flutter/painting.dart';

// Colors of the drawn device. They belong to the previewed device, not to the
// editor, so they do not follow the editor theme: a phone body is black and a
// status bar shows white or black icons in light or dark mode alike.

/// The body of a handset.
const Color deviceBodyColor = Color(0xFF101114);

/// Status bar icons over a dark background.
const Color statusIconsLight = Color(0xFFFFFFFF);

/// Status bar icons over a light background.
const Color statusIconsDark = Color(0xFF000000);

/// The home indicator over a dark background.
const Color homeIndicatorLight = Color(0xFFFFFFFF);

/// The home indicator over a light background.
const Color homeIndicatorDark = Color(0xFF000000);

/// Window controls of a desktop frame.
const Color windowClose = Color(0xFFFF5F57);
const Color windowMinimize = Color(0xFFFEBC2E);
const Color windowMaximize = Color(0xFF28C840);

/// Title bar of a desktop frame.
const Color windowTitleBar = Color(0xFFE6E6E8);
const Color windowTitleText = Color(0xFF3C3C43);

// Measures of the drawn device.
const double statusBarFontSize = 15;
const double statusBarIconSize = 16;
const double statusBarSidePadding = 28;
const double islandWidth = 120;
const double islandHeight = 34;
const double islandTop = 11;
const double homeIndicatorWidth = 134;
const double homeIndicatorHeight = 5;
const double homeIndicatorGap = 8;
const double windowTitleBarHeight = 32;
const double windowControlSize = 12;
const double windowControlGap = 8;
const String statusBarTime = '9:41';
