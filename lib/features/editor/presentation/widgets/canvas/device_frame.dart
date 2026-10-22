import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_chrome.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_dimensions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/status_bar_appearance.dart';

/// The body of the previewed device around the screen: a handset or tablet
/// with its status bar and home indicator, or a desktop window with a title
/// bar. It draws over the screen without taking clicks, so the designer
/// still works under it.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({
    required this.device,
    required this.landscape,
    required this.insets,
    required this.appearance,
    required this.showSafeArea,
    required this.child,
    super.key,
  });

  final PreviewDevice device;
  final bool landscape;

  /// The areas the system covers, as the preview gives them to the screen.
  final EdgeInsets insets;
  final StatusBarAppearance appearance;
  final bool showSafeArea;

  /// The screen.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screen = Stack(
      children: [
        child,
        if (showSafeArea) _SafeAreaTint(insets: insets),
        if (!device.isWindow) ..._systemBars(),
      ],
    );
    return device.isWindow
        ? _Window(child: screen)
        : _Body(device: device, child: screen);
  }

  List<Widget> _systemBars() {
    final portraitHandset = !landscape && insets.top > 0;
    return [
      if (appearance.visible && portraitHandset)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: insets.top,
          child: IgnorePointer(
            child: _StatusBar(lightIcons: appearance.lightIcons),
          ),
        ),
      if (insets.bottom > 0)
        Positioned(
          bottom: homeIndicatorGap,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: _HomeIndicator(lightIcons: appearance.lightIcons),
          ),
        ),
    ];
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.device, required this.child});

  final PreviewDevice device;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: deviceBodyColor,
        borderRadius: BorderRadius.circular(device.cornerRadius + device.bezel),
      ),
      child: Padding(
        padding: EdgeInsets.all(device.bezel),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(device.cornerRadius),
          child: child,
        ),
      ),
    );
  }
}

class _Window extends StatelessWidget {
  const _Window({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.outline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [const _TitleBar(), child],
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: windowTitleBarHeight,
      child: ColoredBox(
        color: windowTitleBar,
        child: Row(
          children: [
            SizedBox(width: windowControlGap * 2),
            _Dot(windowClose),
            SizedBox(width: windowControlGap),
            _Dot(windowMinimize),
            SizedBox(width: windowControlGap),
            _Dot(windowMaximize),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: windowControlSize,
    child: DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}

/// Time on the left, signal, wifi and battery on the right, and the camera
/// island in the middle.
class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.lightIcons});

  final bool lightIcons;

  @override
  Widget build(BuildContext context) {
    final color = lightIcons ? statusIconsLight : statusIconsDark;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        const Positioned(
          top: islandTop,
          child: SizedBox(
            width: islandWidth,
            height: islandHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: deviceBodyColor,
                borderRadius: BorderRadius.all(Radius.circular(islandHeight)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: statusBarSidePadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusBarTime,
                style: TextStyle(
                  color: color,
                  fontSize: statusBarFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.signal_cellular_alt,
                    size: statusBarIconSize,
                    color: color,
                  ),
                  Icon(Icons.wifi, size: statusBarIconSize, color: color),
                  Icon(
                    Icons.battery_full,
                    size: statusBarIconSize,
                    color: color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator({required this.lightIcons});

  final bool lightIcons;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: homeIndicatorWidth,
        height: homeIndicatorHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: lightIcons ? homeIndicatorLight : homeIndicatorDark,
            borderRadius: BorderRadius.circular(homeIndicatorHeight),
          ),
        ),
      ),
    );
  }
}

/// Shades the areas the system covers, which a SafeArea keeps clear.
class _SafeAreaTint extends StatelessWidget {
  const _SafeAreaTint({required this.insets});

  final EdgeInsets insets;

  @override
  Widget build(BuildContext context) {
    final tint = context.colorScheme.error.withValues(
      alpha: safeAreaTintOpacity,
    );
    return Positioned.fill(
      key: const ValueKey('safe-area-tint'),
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: insets.top,
              child: ColoredBox(color: tint),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: insets.bottom,
              child: ColoredBox(color: tint),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: insets.left,
              child: ColoredBox(color: tint),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: insets.right,
              child: ColoredBox(color: tint),
            ),
          ],
        ),
      ),
    );
  }
}
