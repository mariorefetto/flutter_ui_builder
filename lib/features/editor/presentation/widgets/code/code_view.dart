import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/core/widgets/error_view.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_edit_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_edit_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_dimensions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/shortcuts.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/code/highlighting_controller.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/import/import_outcome.dart';

const String _monospace = 'monospace';
const String _indent = '  ';

/// The code of the open project, editable. The code the document generates is
/// shown until the user edits it; edited code is checked as it is typed and
/// applied to the document with Apply (or Cmd/Ctrl+Enter).
class CodeView extends StatelessWidget {
  const CodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CodeCubit, CodeState>(
      buildWhen: (previous, current) =>
          (previous is CodeFailed) != (current is CodeFailed) ||
          current is CodeFailed,
      builder: (context, state) => switch (state) {
        CodeFailed(:final failure) => ErrorView(
          failure: failure,
          onRetry: context.read<CodeCubit>().generate,
        ),
        _ => const _Editor(),
      },
    );
  }
}

class _Editor extends StatefulWidget {
  const _Editor();

  @override
  State<_Editor> createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  final TextEditingController _controller = HighlightingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<CodeEditCubit>().state.text;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Text that came from outside (generated code, a revert) replaces what the
  // editor shows, keeping the caret where it was when it still fits.
  void _load(String text) {
    final offset = _controller.selection.baseOffset.clamp(0, text.length);
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  void _apply() {
    final edit = context.read<CodeEditCubit>();
    final result = edit.checkNow();
    if (result == null) return;
    edit.applied();
    context.read<EditorCubit>().applyImported(result);
  }

  void _insertIndent() {
    final selection = _controller.selection;
    if (!selection.isValid) return;
    final text = _controller.text.replaceRange(
      selection.start,
      selection.end,
      _indent,
    );
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: selection.start + _indent.length,
      ),
    );
    context.read<CodeEditCubit>().edit(text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CodeEditCubit, CodeEditState>(
      listenWhen: (previous, current) => previous.revision != current.revision,
      listener: (context, state) => _load(state.text),
      child: CallbackShortcuts(
        bindings: {
          commandKey(LogicalKeyboardKey.enter): _apply,
          const SingleActivator(LogicalKeyboardKey.tab): _insertIndent,
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(onApply: _apply, controller: _controller),
            Expanded(child: _Source(controller: _controller)),
            const _Problems(),
          ],
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.onApply, required this.controller});

  final VoidCallback onApply;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final edit = context.read<CodeEditCubit>();
    return Material(
      color: context.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingSM),
        child: BlocBuilder<CodeEditCubit, CodeEditState>(
          builder: (context, state) => Row(
            children: [
              Text(
                state.dirty ? l10n.codeEdited : l10n.codeInSync,
                style: context.textTheme.labelLarge,
              ),
              const Spacer(),
              IconButton(
                tooltip: l10n.codeRevert,
                icon: const Icon(AppIcons.undo),
                onPressed: state.dirty ? edit.revert : null,
              ),
              FilledButton.icon(
                icon: const Icon(AppIcons.run),
                label: Text(l10n.codeApply),
                onPressed: state.dirty && state.result != null ? onApply : null,
              ),
              IconButton(
                tooltip: l10n.codeCopy,
                icon: const Icon(AppIcons.copy),
                onPressed: () => _copy(context),
              ),
              IconButton(
                tooltip: state.dirty
                    ? l10n.codeExportAfterApply
                    : l10n.codeExport,
                icon: const Icon(AppIcons.export),
                // Export writes what the document generates, not the edits.
                onPressed: state.dirty
                    ? null
                    : context.read<CodeCubit>().export,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = context.l10n.codeCopied;
    await Clipboard.setData(ClipboardData(text: controller.text));
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

/// The text with a column of line numbers, both in the same style so the
/// lines stay aligned.
class _Source extends StatelessWidget {
  const _Source({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyMedium?.copyWith(
      fontFamily: _monospace,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingSM),
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _numbers(controller.text),
              textAlign: TextAlign.end,
              style: style?.copyWith(color: context.colorScheme.outline),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                style: style,
                // The caret keeps the line numbers' line height.
                decoration: const InputDecoration.collapsed(hintText: ''),
                onChanged: context.read<CodeEditCubit>().edit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _numbers(String text) {
    final count = '\n'.allMatches(text).length + 1;
    return List.generate(count, (index) => '${index + 1}').join('\n');
  }
}

/// What the edited code makes: syntax errors, or the widgets found and what
/// would be left out. Hidden while the code is as generated.
class _Problems extends StatelessWidget {
  const _Problems();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CodeEditCubit, CodeEditState>(
      builder: (context, state) {
        if (!state.dirty || (state.result == null && state.failure == null)) {
          return const SizedBox.shrink();
        }
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: codeProblemsMaxHeight),
          child: Material(
            color: context.colorScheme.surfaceContainerHigh,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingSM),
              child: ImportOutcomeView(
                result: state.result,
                failure: state.failure,
              ),
            ),
          ),
        );
      },
    );
  }
}
