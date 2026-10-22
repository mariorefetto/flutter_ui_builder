import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/di/injection.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/import_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/import_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_dimensions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/import/import_outcome.dart';

const String _monospace = 'monospace';
const int _minLines = 12;
const int _maxLines = 16;

/// A dialog to paste Dart code, see what the builder makes of it and open the
/// result in the designer. It pops with the result, or with null on cancel.
class ImportCodeDialog extends StatelessWidget {
  const ImportCodeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ImportCubit>(),
      child: const _Dialog(),
    );
  }
}

class _Dialog extends StatefulWidget {
  const _Dialog();

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  final TextEditingController _source = TextEditingController();

  @override
  void dispose() {
    _source.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ImportCubit>();
    return BlocConsumer<ImportCubit, ImportState>(
      // A file that was read replaces the text.
      listenWhen: (previous, current) =>
          previous.fileRevision != current.fileRevision,
      listener: (context, state) => _source.text = state.fileText ?? '',
      builder: (context, state) => AlertDialog(
        title: Text(l10n.importTitle),
        content: SizedBox(
          width: importDialogWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _source,
                  minLines: _minLines,
                  maxLines: _maxLines,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontFamily: _monospace,
                  ),
                  decoration: InputDecoration(hintText: l10n.importHint),
                ),
                const SizedBox(height: AppConstants.spacingSM),
                Row(
                  children: [
                    TextButton.icon(
                      icon: const Icon(AppIcons.openFile),
                      label: Text(l10n.importOpenFile),
                      onPressed: cubit.openFile,
                    ),
                    const Spacer(),
                    FilledButton.tonal(
                      onPressed: () => cubit.render(_source.text),
                      child: Text(l10n.importRender),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingSM),
                ImportOutcomeView(result: state.result, failure: state.failure),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: state.result == null
                ? null
                : () => Navigator.of(context).pop(state.result),
            child: Text(l10n.importApply),
          ),
        ],
      ),
    );
  }
}
