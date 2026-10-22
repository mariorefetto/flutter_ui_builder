import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';

/// Asks for a name and pops with it, or with null on cancel. It renames the
/// project unless a [title] and a [hint] say it is something else.
class RenameDialog extends StatefulWidget {
  const RenameDialog({
    required this.initialName,
    this.title,
    this.hint,
    super.key,
  });

  final String initialName;
  final String? title;
  final String? hint;

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() => Navigator.of(context).pop(_controller.text);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(widget.title ?? l10n.renameTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(hintText: widget.hint),
        onSubmitted: (_) => _confirm(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(onPressed: _confirm, child: Text(l10n.commonConfirm)),
      ],
    );
  }
}
