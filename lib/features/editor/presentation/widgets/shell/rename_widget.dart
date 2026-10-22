import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/file/rename_dialog.dart';

/// Asks for a name for the selected widget and sets it. A blank name removes
/// the name. Nothing happens when nothing is selected.
Future<void> renameSelectedWidget(BuildContext context) async {
  final cubit = context.read<EditorCubit>();
  final l10n = context.l10n;
  final id = cubit.state.selectedId;
  final node = id == null ? null : cubit.state.document.root.find(id);
  if (id == null || node == null) return;
  final label = await showDialog<String>(
    context: context,
    builder: (context) => RenameDialog(
      initialName: node.label ?? '',
      title: l10n.renameWidgetTitle,
      hint: l10n.renameWidgetHint,
    ),
  );
  if (label != null) cubit.relabelNode(id, label);
}
