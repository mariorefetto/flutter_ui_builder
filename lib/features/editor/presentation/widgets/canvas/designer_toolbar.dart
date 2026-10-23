import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/core/widgets/app_select.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/help/screens_overview_dialog.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

const int _percent = 100;

/// Above the designer: the screen to preview on, its orientation and the zoom.
/// Width of the device drop-down, which holds the longest device name.
const double _deviceSelectWidth = 150;

class DesignerToolbar extends StatelessWidget {
  const DesignerToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<WorkspaceCubit>();
    return Material(
      color: context.colorScheme.surfaceContainer,
      child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
        buildWhen: (previous, current) =>
            previous.device != current.device ||
            previous.landscape != current.landscape ||
            previous.showFrame != current.showFrame ||
            previous.showSafeArea != current.showSafeArea ||
            previous.statusBar != current.statusBar ||
            previous.prototype != current.prototype ||
            previous.showGuidelines != current.showGuidelines ||
            previous.zoom != current.zoom,
        builder: (context, state) => _Scrolling(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: AppConstants.spacingSM),
                  SizedBox(
                    width: _deviceSelectWidth,
                    child: AppSelect<PreviewDevice>(
                      borderless: true,
                      value: state.device,
                      onChanged: (device) {
                        if (device != null) cubit.setDevice(device);
                      },
                      options: [
                        for (final device in PreviewDevice.values)
                          AppSelectOption(
                            value: device,
                            label: _deviceLabel(l10n, device),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.designerOverview,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(AppIcons.overview),
                    onPressed: () => showScreensOverview(context),
                  ),
                  IconButton(
                    tooltip: l10n.designerGuidelines,
                    visualDensity: VisualDensity.compact,
                    isSelected: state.showGuidelines,
                    icon: const Icon(AppIcons.guidelines),
                    onPressed: cubit.toggleGuidelines,
                  ),
                  IconButton(
                    tooltip: l10n.designerPrototype,
                    visualDensity: VisualDensity.compact,
                    isSelected: state.prototype,
                    icon: const Icon(AppIcons.run),
                    onPressed: cubit.togglePrototype,
                  ),
                  IconButton(
                    tooltip: l10n.designerRotate,
                    visualDensity: VisualDensity.compact,
                    isSelected: state.landscape,
                    icon: const Icon(AppIcons.rotate),
                    // A desktop screen has no portrait to turn from.
                    onPressed: state.device == PreviewDevice.desktop
                        ? null
                        : cubit.toggleOrientation,
                  ),
                  IconButton(
                    tooltip: l10n.designerFrame,
                    visualDensity: VisualDensity.compact,
                    isSelected: state.showFrame,
                    icon: const Icon(AppIcons.device),
                    onPressed: cubit.toggleFrame,
                  ),
                  IconButton(
                    tooltip: l10n.designerSafeArea,
                    visualDensity: VisualDensity.compact,
                    isSelected: state.showSafeArea,
                    icon: const Icon(AppIcons.safeArea),
                    onPressed: cubit.toggleSafeArea,
                  ),
                  PopupMenuButton<StatusBarMode>(
                    tooltip: l10n.designerStatusBar,
                    icon: const Icon(Icons.signal_cellular_alt),
                    initialValue: state.statusBar,
                    onSelected: cubit.setStatusBar,
                    itemBuilder: (context) => [
                      for (final mode in StatusBarMode.values)
                        PopupMenuItem(
                          value: mode,
                          child: Text(_statusBarLabel(l10n, mode)),
                        ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    tooltip: l10n.designerZoomOut,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(AppIcons.zoomOut),
                    onPressed: state.zoom > zoomSteps.first
                        ? cubit.zoomOut
                        : null,
                  ),
                  TextButton(
                    onPressed: cubit.resetZoom,
                    child: Tooltip(
                      message: l10n.designerZoomReset,
                      child: Text('${(state.zoom * _percent).round()}%'),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.designerZoomIn,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(AppIcons.zoomIn),
                    onPressed: state.zoom < zoomSteps.last
                        ? cubit.zoomIn
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _deviceLabel(AppLocalizations l10n, PreviewDevice device) =>
      switch (device) {
        PreviewDevice.phone => l10n.designerDevicePhone,
        PreviewDevice.tablet => l10n.designerDeviceTablet,
        PreviewDevice.desktop => l10n.designerDeviceDesktop,
      };

  String _statusBarLabel(AppLocalizations l10n, StatusBarMode mode) =>
      switch (mode) {
        StatusBarMode.auto => l10n.statusBarAuto,
        StatusBarMode.light => l10n.statusBarLight,
        StatusBarMode.dark => l10n.statusBarDark,
        StatusBarMode.hidden => l10n.statusBarHidden,
      };
}

/// Keeps the toolbar usable when the designer is narrow, as with the code
/// beside it: the controls scroll sideways rather than overflow, and still
/// fill the width when there is room.
class _Scrolling extends StatelessWidget {
  const _Scrolling({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: child,
        ),
      ),
    );
  }
}
