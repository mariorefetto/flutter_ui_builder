import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';

/// Vertical strip of buttons that open and close the left panels.
class ActivityStrip extends StatelessWidget {
  const ActivityStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final open = context.select((WorkspaceCubit c) => c.state.leftPanel);
    final cubit = context.read<WorkspaceCubit>();
    return SizedBox(
      width: AppConstants.buttonHeight,
      child: Material(
        color: context.colorScheme.surfaceContainerHighest,
        child: Column(
          children: [
            _StripButton(
              icon: AppIcons.tools,
              tooltip: context.l10n.panelToolbox,
              selected: open == LeftPanel.toolbox,
              onPressed: () => cubit.toggleLeftPanel(LeftPanel.toolbox),
            ),
            _StripButton(
              icon: AppIcons.outline,
              tooltip: context.l10n.panelOutline,
              selected: open == LeftPanel.outline,
              onPressed: () => cubit.toggleLeftPanel(LeftPanel.outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _StripButton extends StatelessWidget {
  const _StripButton({
    required this.icon,
    required this.tooltip,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: selected ? colors.primary : colors.surfaceContainerHighest,
            width: AppConstants.borderWidthMedium,
          ),
        ),
      ),
      child: IconButton(
        tooltip: tooltip,
        isSelected: selected,
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}
