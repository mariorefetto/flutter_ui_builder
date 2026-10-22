import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_dimensions.dart';

/// The kinds of screen the designer can show a project on.
enum PreviewDevice {
  phone(
    width: 390,
    height: 844,
    topInset: 47,
    bottomInset: 34,
    sideInsetLandscape: 47,
    bottomInsetLandscape: 21,
    bezel: 12,
    cornerRadius: 44,
  ),
  tablet(
    width: 820,
    height: 1180,
    topInset: 24,
    bottomInset: 20,
    sideInsetLandscape: 0,
    bottomInsetLandscape: 20,
    bezel: 16,
    cornerRadius: 24,
  ),
  desktop(
    width: 1280,
    height: 800,
    topInset: 0,
    bottomInset: 0,
    sideInsetLandscape: 0,
    bottomInsetLandscape: 0,
    bezel: 0,
    cornerRadius: 8,
  );

  const PreviewDevice({
    required this.width,
    required this.height,
    required this.topInset,
    required this.bottomInset,
    required this.sideInsetLandscape,
    required this.bottomInsetLandscape,
    required this.bezel,
    required this.cornerRadius,
  });

  /// Logical size in portrait. A desktop is wider than tall already.
  final double width;
  final double height;

  /// Space the system takes at the top (status bar) and bottom (home
  /// indicator) in portrait, and at the sides and bottom in landscape.
  final double topInset;
  final double bottomInset;
  final double sideInsetLandscape;
  final double bottomInsetLandscape;

  /// Thickness of the device body around the screen, and its corner radius.
  final double bezel;
  final double cornerRadius;

  /// Whether the device is drawn as a window rather than a handset.
  bool get isWindow => this == PreviewDevice.desktop;

  /// The size of the screen, turned on its side when [landscape] is set.
  Size size({required bool landscape}) {
    final long = math.max(width, height);
    final short = math.min(width, height);
    return isWindow || landscape ? Size(long, short) : Size(width, height);
  }

  /// The areas the system covers, which a SafeArea keeps clear. In landscape
  /// the status bar goes away and the notch moves to the sides.
  EdgeInsets insets({required bool landscape, required bool statusBar}) {
    if (isWindow) return EdgeInsets.zero;
    if (landscape) {
      return EdgeInsets.only(
        left: sideInsetLandscape,
        right: sideInsetLandscape,
        top: statusBar && sideInsetLandscape == 0 ? topInset : 0,
        bottom: bottomInsetLandscape,
      );
    }
    return EdgeInsets.only(top: statusBar ? topInset : 0, bottom: bottomInset);
  }
}

/// The screen the designer is previewing: its size and the margins the
/// system keeps. Screens drawn by the previews (Scaffold and
/// CupertinoPageScaffold) read it.
class PreviewScreenScope extends InheritedWidget {
  const PreviewScreenScope({
    required this.size,
    required this.insets,
    required super.child,
    this.cornerRadius = 0,
    super.key,
  });

  final Size size;
  final EdgeInsets insets;

  /// How round the corners of the screen are, which is none without the
  /// device frame.
  final double cornerRadius;

  /// The size in the closest scope, or a phone when there is none.
  static Size sizeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PreviewScreenScope>()?.size ??
      const Size(previewScreenWidth, previewScreenHeight);

  /// The system margins in the closest scope, or none.
  static EdgeInsets insetsOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<PreviewScreenScope>()
          ?.insets ??
      EdgeInsets.zero;

  /// The corner radius of the screen in the closest scope, or none.
  static double cornerRadiusOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<PreviewScreenScope>()
          ?.cornerRadius ??
      0;

  @override
  bool updateShouldNotify(PreviewScreenScope oldWidget) =>
      size != oldWidget.size ||
      insets != oldWidget.insets ||
      cornerRadius != oldWidget.cornerRadius;
}
