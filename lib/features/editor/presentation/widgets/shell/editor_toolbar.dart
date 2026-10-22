import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/file/file_commands.dart';

/// Row of icon buttons for the most used commands.
class EditorToolbar extends StatelessWidget {
  const EditorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: context.colorScheme.surfaceContainer,
      child: BlocBuilder<EditorCubit, EditorState>(
        buildWhen: (previous, current) =>
            previous.history.canUndo != current.history.canUndo ||
            previous.history.canRedo != current.history.canRedo ||
            previous.selectedId != current.selectedId,
        builder: (context, state) {
          final cubit = context.read<EditorCubit>();
          final selected = state.selectedId;
          final canDelete =
              selected != null && selected != state.document.root.id;
          return Row(
            children: [
              _Button(
                icon: AppIcons.newFile,
                tooltip: l10n.fileNew,
                onPressed: () => newProject(context),
              ),
              _Button(
                icon: AppIcons.open,
                tooltip: l10n.fileOpen,
                onPressed: () => openProject(context),
              ),
              _Button(
                icon: AppIcons.save,
                tooltip: l10n.fileSave,
                onPressed: () => saveProject(context),
              ),
              _Button(
                icon: AppIcons.importCode,
                tooltip: l10n.menuImportCode,
                onPressed: () => importCode(context),
              ),
              const _Separator(),
              _Button(
                icon: AppIcons.undo,
                tooltip: l10n.editorUndo,
                onPressed: state.history.canUndo ? cubit.undo : null,
              ),
              _Button(
                icon: AppIcons.redo,
                tooltip: l10n.editorRedo,
                onPressed: state.history.canRedo ? cubit.redo : null,
              ),
              const _Separator(),
              _Button(
                icon: AppIcons.delete,
                tooltip: l10n.editorDelete,
                onPressed: canDelete ? cubit.removeSelected : null,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    visualDensity: VisualDensity.compact,
    icon: Icon(icon),
    onPressed: onPressed,
  );
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: AppConstants.spacingLG,
    child: VerticalDivider(
      width: AppConstants.spacingMD,
      thickness: AppConstants.borderWidthThin,
    ),
  );
}
