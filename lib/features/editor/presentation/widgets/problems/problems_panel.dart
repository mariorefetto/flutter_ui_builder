import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/problem.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/problems_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/problems_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/problems/problem_messages.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/dock_panel.dart';

/// The list of problems of the document. A row selects the widget it is
/// about and shows the designer.
class ProblemsPanel extends StatelessWidget {
  const ProblemsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProblemsCubit, ProblemsState>(
      builder: (context, state) => DockPanel(
        title: l10n.panelProblems(state.problems.length),
        onClose: context.read<WorkspaceCubit>().toggleProblems,
        child: state.problems.isEmpty
            ? Center(child: Text(l10n.problemsEmpty))
            : ListView.builder(
                itemCount: state.problems.length,
                itemBuilder: (context, index) =>
                    _ProblemRow(problem: state.problems[index]),
              ),
      ),
    );
  }
}

class _ProblemRow extends StatelessWidget {
  const _ProblemRow({required this.problem});

  final Problem problem;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isWarning = problem.severity == ProblemSeverity.warning;
    return ListTile(
      dense: true,
      leading: Icon(
        isWarning ? AppIcons.warning : AppIcons.info,
        color: isWarning ? colors.error : colors.primary,
        size: AppConstants.spacingLG,
      ),
      title: Text(problemMessage(context.l10n, problem)),
      subtitle: Text('${problem.nodeType}  (${problem.nodeId})'),
      onTap: () {
        context.read<EditorCubit>().select(problem.nodeId);
        context.read<WorkspaceCubit>().showCenterTab(CenterTab.design);
      },
    );
  }
}
