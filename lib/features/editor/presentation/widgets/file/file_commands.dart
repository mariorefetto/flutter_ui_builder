import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/new_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/project_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/import/import_code_dialog.dart';

/// True when the edited project differs from the one on disk. Which screen
/// is open does not count.
bool hasUnsavedChanges(BuildContext context) =>
    !const ScreenEditor().sameContent(
      context.read<EditorCubit>().state.document,
      context.read<ProjectCubit>().state.savedDocument,
    );

Future<void> saveProject(BuildContext context) => context
    .read<ProjectCubit>()
    .save(context.read<EditorCubit>().state.document);

Future<void> saveProjectAs(BuildContext context) => context
    .read<ProjectCubit>()
    .saveAs(context.read<EditorCubit>().state.document);

Future<void> openProject(BuildContext context) async {
  if (!await _confirmDiscard(context) || !context.mounted) return;
  await context.read<ProjectCubit>().open();
}

Future<void> newProject(BuildContext context) async {
  if (!await _confirmDiscard(context) || !context.mounted) return;
  final document = createEmptyDocument();
  context.read<EditorCubit>().replaceDocument(document);
  context.read<ProjectCubit>().startNew(document);
}

/// Asks before throwing away unsaved work. Resolves to true when it is safe
/// to continue.
Future<bool> _confirmDiscard(BuildContext context) async {
  if (!hasUnsavedChanges(context)) return true;
  final l10n = context.l10n;
  final discard = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.fileDiscardTitle),
      content: Text(l10n.fileDiscardMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.fileDiscard),
        ),
      ],
    ),
  );
  return discard ?? false;
}

/// Opens the import dialog and, when code was rendered, replaces the project
/// with it. The imported project counts as unsaved.
Future<void> importCode(BuildContext context) async {
  if (!await _confirmDiscard(context) || !context.mounted) return;
  final result = await showDialog<ImportResult>(
    context: context,
    builder: (context) => const ImportCodeDialog(),
  );
  if (result == null || !context.mounted) return;
  // The project is no longer the file it was, and differs from an empty one.
  context.read<ProjectCubit>().startNew(createEmptyDocument());
  context.read<EditorCubit>().replaceWithImport(result);
  context.read<WorkspaceCubit>().showCenterTab(CenterTab.design);
}
