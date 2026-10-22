import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/project_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/file/rename_dialog.dart';

/// The tab of the open project, above the designer. A marker shows unsaved
/// changes and a tap renames the project.
class DocumentTab extends StatelessWidget {
  const DocumentTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final saved = context.select((ProjectCubit c) => c.state.savedDocument);
    return ColoredBox(
      color: colors.surfaceContainerHigh,
      child: Align(
        alignment: Alignment.centerLeft,
        child: BlocBuilder<EditorCubit, EditorState>(
          buildWhen: (previous, current) =>
              previous.document != current.document,
          builder: (context, state) {
            final name = state.document.name;
            final label = state.document == saved
                ? name
                : context.l10n.editorTitleModified(name);
            return Tooltip(
              message: context.l10n.editorDocumentTabTooltip,
              child: InkWell(
                onTap: () => _rename(context, name),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    border: Border(
                      top: BorderSide(
                        color: colors.primary,
                        width: AppConstants.borderWidthMedium,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMD,
                      vertical: AppConstants.spacingSM,
                    ),
                    child: Text(label, style: context.textTheme.bodyMedium),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _rename(BuildContext context, String current) async {
    final cubit = context.read<EditorCubit>();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => RenameDialog(initialName: current),
    );
    if (name != null) cubit.renameDocument(name);
  }
}
