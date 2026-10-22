import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/shortcuts.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/file/file_commands.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/rename_widget.dart';

/// Keyboard shortcuts of the whole window: file commands, undo and redo, the
/// clipboard and delete.
///
/// A key press goes to the text field being edited first: while the user
/// types, copy, paste, undo and delete work on the text, not on the widgets.
class EditorShortcuts extends StatefulWidget {
  const EditorShortcuts({required this.child, super.key});

  final Widget child;

  /// Gives the keyboard back to the shortcuts. Panels call it when they are
  /// clicked, so Delete and the other keys work on what they just selected,
  /// and a text field that was being edited is left.
  static void reclaimFocus(BuildContext context) => context
      .getInheritedWidgetOfExactType<_ShortcutFocus>()
      ?.node
      .requestFocus();

  @override
  State<EditorShortcuts> createState() => _EditorShortcutsState();
}

class _EditorShortcutsState extends State<EditorShortcuts> {
  final FocusNode _node = FocusNode(debugLabel: 'editor shortcuts');

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bindings = _bindings(context);
    return _ShortcutFocus(
      node: _node,
      child: Focus(
        focusNode: _node,
        autofocus: true,
        onKeyEvent: (node, event) => _handle(bindings, event),
        child: widget.child,
      ),
    );
  }

  Map<SingleActivator, VoidCallback> _bindings(BuildContext context) {
    final editor = context.read<EditorCubit>();
    final workspace = context.read<WorkspaceCubit>();
    return {
      commandKey(LogicalKeyboardKey.keyN): () => newProject(context),
      commandKey(LogicalKeyboardKey.keyO): () => openProject(context),
      commandKey(LogicalKeyboardKey.keyS): () => saveProject(context),
      commandKey(LogicalKeyboardKey.keyI): () => importCode(context),
      commandKey(LogicalKeyboardKey.keyS, shift: true): () =>
          saveProjectAs(context),
      commandKey(LogicalKeyboardKey.keyE): () =>
          context.read<CodeCubit>().export(),
      commandKey(LogicalKeyboardKey.keyZ): editor.undo,
      commandKey(LogicalKeyboardKey.keyZ, shift: true): editor.redo,
      commandKey(LogicalKeyboardKey.keyX): editor.cut,
      commandKey(LogicalKeyboardKey.keyC): editor.copy,
      commandKey(LogicalKeyboardKey.keyV): editor.paste,
      commandKey(LogicalKeyboardKey.keyD): editor.duplicateSelected,
      // The key a Mac labels Delete sends Backspace.
      const SingleActivator(LogicalKeyboardKey.delete): editor.removeSelected,
      const SingleActivator(LogicalKeyboardKey.backspace):
          editor.removeSelected,
      const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
          editor.selectNeighbour(next: true),
      const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
          editor.selectNeighbour(next: false),
      const SingleActivator(LogicalKeyboardKey.arrowLeft): editor.selectParent,
      const SingleActivator(LogicalKeyboardKey.arrowRight):
          editor.selectFirstChild,
      commandKey(LogicalKeyboardKey.arrowDown): () => editor.moveSelectedBy(1),
      commandKey(LogicalKeyboardKey.arrowUp): () => editor.moveSelectedBy(-1),
      const SingleActivator(LogicalKeyboardKey.f2): () =>
          renameSelectedWidget(context),
      commandKey(LogicalKeyboardKey.equal): workspace.zoomIn,
      commandKey(LogicalKeyboardKey.minus): workspace.zoomOut,
      commandKey(LogicalKeyboardKey.digit0): workspace.resetZoom,
    };
  }

  KeyEventResult _handle(
    Map<SingleActivator, VoidCallback> bindings,
    KeyEvent event,
  ) {
    if (event is! KeyDownEvent || _isEditingText) return KeyEventResult.ignored;
    for (final MapEntry(:key, :value) in bindings.entries) {
      if (key.accepts(event, HardwareKeyboard.instance)) {
        value();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  bool get _isEditingText =>
      FocusManager.instance.primaryFocus?.context
          ?.findAncestorWidgetOfExactType<EditableText>() !=
      null;
}

class _ShortcutFocus extends InheritedWidget {
  const _ShortcutFocus({required this.node, required super.child});

  final FocusNode node;

  @override
  bool updateShouldNotify(_ShortcutFocus oldWidget) => node != oldWidget.node;
}
