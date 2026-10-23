import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_command.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/file/file_commands.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/help/shortcuts_dialog.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/rename_widget.dart';
import 'package:flutter_ui_builder/features/settings/presentation/widgets/open_settings.dart';

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
    final actions = <EditorCommand, VoidCallback>{
      EditorCommand.newProject: () => newProject(context),
      EditorCommand.openProject: () => openProject(context),
      EditorCommand.saveProject: () => saveProject(context),
      EditorCommand.saveProjectAs: () => saveProjectAs(context),
      EditorCommand.importCode: () => importCode(context),
      EditorCommand.exportCode: () => context.read<CodeCubit>().export(),
      EditorCommand.openSettings: () => openSettings(context),
      EditorCommand.undo: editor.undo,
      EditorCommand.redo: editor.redo,
      EditorCommand.cut: editor.cut,
      EditorCommand.copy: editor.copy,
      EditorCommand.paste: editor.paste,
      EditorCommand.duplicate: editor.duplicateSelected,
      EditorCommand.delete: editor.removeSelected,
      EditorCommand.rename: () => renameSelectedWidget(context),
      EditorCommand.selectNext: () => editor.selectNeighbour(next: true),
      EditorCommand.selectPrevious: () => editor.selectNeighbour(next: false),
      EditorCommand.selectParent: editor.selectParent,
      EditorCommand.selectFirstChild: editor.selectFirstChild,
      EditorCommand.moveDown: () => editor.moveSelectedBy(1),
      EditorCommand.moveUp: () => editor.moveSelectedBy(-1),
      EditorCommand.zoomIn: workspace.zoomIn,
      EditorCommand.zoomOut: workspace.zoomOut,
      EditorCommand.zoomReset: workspace.resetZoom,
      EditorCommand.showShortcuts: () => showShortcuts(context),
    };
    // Every command must have an action, or its keys would do nothing.
    assert(
      EditorCommand.values.every(actions.containsKey),
      'a command has no action',
    );
    return {
      for (final MapEntry(:key, :value) in actions.entries)
        for (final activator in key.activators) activator: value,
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
