import 'package:flutter/painting.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';

const double _lightBackgroundLuminance = 0.5;

/// What the status bar of the previewed device looks like.
class StatusBarAppearance {
  const StatusBarAppearance({required this.visible, required this.lightIcons});

  final bool visible;

  /// Light icons, for a dark background (SystemUiOverlayStyle.light).
  final bool lightIcons;
}

/// Works out the status bar from the chosen [mode]. In auto mode it follows
/// the AppBar of the project: its `statusBarStyle`, or else whether its
/// background (or the Scaffold's) is dark. With neither set, the screen is
/// the theme's own surface, so [themeIsDark] decides.
StatusBarAppearance statusBarAppearance(
  EditorDocument document,
  StatusBarMode mode, {
  required bool themeIsDark,
}) {
  switch (mode) {
    case StatusBarMode.hidden:
      return const StatusBarAppearance(visible: false, lightIcons: false);
    case StatusBarMode.light:
      return const StatusBarAppearance(visible: true, lightIcons: true);
    case StatusBarMode.dark:
      return const StatusBarAppearance(visible: true, lightIcons: false);
    case StatusBarMode.auto:
      return StatusBarAppearance(
        visible: true,
        lightIcons: _autoLightIcons(document.root, themeIsDark),
      );
  }
}

bool _autoLightIcons(WidgetNode root, bool themeIsDark) {
  final bar = root.children
      .where((c) => c.type == 'AppBar' || c.type == 'CupertinoNavigationBar')
      .firstOrNull;
  final style = bar?.props['statusBarStyle'];
  if (style == 'light') return true;
  if (style == 'dark') return false;
  final background =
      bar?.props['backgroundColor'] ?? root.props['backgroundColor'];
  if (background is int) {
    return Color(background).computeLuminance() < _lightBackgroundLuminance;
  }
  return themeIsDark;
}
