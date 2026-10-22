import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';

/// A text field that commits its value on submit or when it loses focus, so
/// typing does not create one undo step per keystroke.
class CommittedTextField extends StatefulWidget {
  const CommittedTextField({
    required this.text,
    required this.onCommit,
    this.label,
    this.hint,
    this.keyboardType,
    super.key,
  });

  /// Value stored in the model, shown when the field is not being edited.
  final String text;

  /// Label above the field; the panel leaves it out and shows the name beside.
  final String? label;
  final String? hint;
  final TextInputType? keyboardType;

  /// Returns false when the typed text is not acceptable.
  final bool Function(String text) onCommit;

  @override
  State<CommittedTextField> createState() => _CommittedTextFieldState();
}

class _CommittedTextFieldState extends State<CommittedTextField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.text,
  );
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChange);
  bool _invalid = false;

  @override
  void didUpdateWidget(CommittedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Follow the model (undo, redo, selection change) unless the user is typing.
    if (widget.text != oldWidget.text && !_focusNode.hasFocus) {
      _controller.text = widget.text;
      _invalid = false;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) _commit();
  }

  void _commit() {
    if (_controller.text == widget.text) return;
    setState(() => _invalid = !widget.onCommit(_controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      onSubmitted: (_) => _commit(),
      decoration: InputDecoration(
        isDense: true,
        labelText: widget.label,
        hintText: widget.hint,
        errorText: _invalid ? context.l10n.editorInvalidValue : null,
      ),
    );
  }
}
