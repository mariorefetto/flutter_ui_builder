import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/problems_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/project_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';

const String _pathSeparator = ' > ';

/// Bar at the bottom: save state, path of the selected widget, widget count.
class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final saved = context.select((ProjectCubit c) => c.state.savedDocument);
    return ColoredBox(
      color: colors.primaryContainer,
      child: DefaultTextStyle.merge(
        style: context.textTheme.bodySmall?.copyWith(
          color: colors.onPrimaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingSM,
            vertical: AppConstants.spacingXS,
          ),
          child: BlocBuilder<EditorCubit, EditorState>(
            builder: (context, state) =>
                _row(context, state, saved == state.document),
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, EditorState state, bool isSaved) {
    final l10n = context.l10n;
    final root = state.document.root;
    final selected = state.selectedId;
    final path = selected == null
        ? l10n.statusNoSelection
        : root.pathTo(selected).map((n) => n.type).join(_pathSeparator);
    return Row(
      children: [
        Text(isSaved ? l10n.statusSaved : l10n.statusModified),
        const SizedBox(width: AppConstants.spacingMD),
        Expanded(child: Text(path, overflow: TextOverflow.ellipsis)),
        const _ProblemsSummary(),
        const SizedBox(width: AppConstants.spacingMD),
        Text(l10n.statusWidgets(root.countNodes())),
        const SizedBox(width: AppConstants.spacingMD),
        Text(state.document.name),
      ],
    );
  }
}

/// Counts of warnings and notes. A click shows or hides the problems panel.
class _ProblemsSummary extends StatelessWidget {
  const _ProblemsSummary();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProblemsCubit>().state;
    return Tooltip(
      message: context.l10n.statusProblemsTooltip,
      child: InkWell(
        onTap: context.read<WorkspaceCubit>().toggleProblems,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.warning, size: AppConstants.spacingMD),
            Text(' ${state.warnings}'),
            const SizedBox(width: AppConstants.spacingSM),
            const Icon(AppIcons.info, size: AppConstants.spacingMD),
            Text(' ${state.infos}'),
          ],
        ),
      ),
    );
  }
}
