import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';

/// Design and Code tabs along the bottom edge of the central area.
class CenterTabs extends StatelessWidget {
  const CenterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.select((WorkspaceCubit c) => c.state.centerTab);
    final placement = context.select(
      (WorkspaceCubit c) => c.state.codePlacement,
    );
    final cubit = context.read<WorkspaceCubit>();
    final l10n = context.l10n;
    return Material(
      color: context.colorScheme.surfaceContainerHigh,
      child: Row(
        children: [
          if (placement == CodePlacement.tab) ...[
            _Tab(
              label: l10n.tabDesign,
              icon: AppIcons.design,
              selected: current == CenterTab.design,
              onTap: () => cubit.showCenterTab(CenterTab.design),
            ),
            _Tab(
              label: l10n.tabCode,
              icon: AppIcons.code,
              selected: current == CenterTab.code,
              onTap: () => cubit.showCenterTab(CenterTab.code),
            ),
          ],
          const Spacer(),
          _PlacementButton(
            tooltip: l10n.codeAsTab,
            icon: AppIcons.codeTab,
            selected: placement == CodePlacement.tab,
            onTap: () => cubit.setCodePlacement(CodePlacement.tab),
          ),
          _PlacementButton(
            tooltip: l10n.codeBeside,
            icon: AppIcons.codeBeside,
            selected: placement == CodePlacement.right,
            onTap: () => cubit.setCodePlacement(CodePlacement.right),
          ),
          _PlacementButton(
            tooltip: l10n.codeBelow,
            icon: AppIcons.codeBelow,
            selected: placement == CodePlacement.bottom,
            onTap: () => cubit.setCodePlacement(CodePlacement.bottom),
          ),
        ],
      ),
    );
  }
}

class _PlacementButton extends StatelessWidget {
  const _PlacementButton({
    required this.tooltip,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      isSelected: selected,
      visualDensity: VisualDensity.compact,
      iconSize: AppConstants.spacingMD,
      icon: Icon(icon),
      onPressed: onTap,
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? colors.surface : null,
          border: Border(
            bottom: BorderSide(
              color: selected ? colors.primary : colors.surfaceContainerHigh,
              width: AppConstants.borderWidthMedium,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMD,
            vertical: AppConstants.spacingSM,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppConstants.spacingMD),
              const SizedBox(width: AppConstants.spacingSM),
              Text(label, style: context.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
