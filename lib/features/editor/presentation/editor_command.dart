import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/features/editor/presentation/shortcuts.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

/// How the shortcuts are grouped in the list.
enum ShortcutGroup { file, edit, structure, view, help }

/// Every command that has a keyboard shortcut. The window binds them and the
/// shortcuts list shows them from this one table, so the list cannot say a
/// key does something it does not.
enum EditorCommand {
  newProject(ShortcutGroup.file),
  openProject(ShortcutGroup.file),
  saveProject(ShortcutGroup.file),
  saveProjectAs(ShortcutGroup.file),
  importCode(ShortcutGroup.file),
  exportCode(ShortcutGroup.file),
  openSettings(ShortcutGroup.file),
  undo(ShortcutGroup.edit),
  redo(ShortcutGroup.edit),
  cut(ShortcutGroup.edit),
  copy(ShortcutGroup.edit),
  paste(ShortcutGroup.edit),
  duplicate(ShortcutGroup.edit),
  delete(ShortcutGroup.edit),
  rename(ShortcutGroup.edit),
  selectNext(ShortcutGroup.structure),
  selectPrevious(ShortcutGroup.structure),
  selectParent(ShortcutGroup.structure),
  selectFirstChild(ShortcutGroup.structure),
  moveDown(ShortcutGroup.structure),
  moveUp(ShortcutGroup.structure),
  zoomIn(ShortcutGroup.view),
  zoomOut(ShortcutGroup.view),
  zoomReset(ShortcutGroup.view),
  showShortcuts(ShortcutGroup.help);

  const EditorCommand(this.group);

  final ShortcutGroup group;

  /// The keys that run the command. Some have two: the key a Mac labels
  /// Delete sends Backspace.
  List<SingleActivator> get activators => switch (this) {
    newProject => [commandKey(LogicalKeyboardKey.keyN)],
    openProject => [commandKey(LogicalKeyboardKey.keyO)],
    saveProject => [commandKey(LogicalKeyboardKey.keyS)],
    saveProjectAs => [commandKey(LogicalKeyboardKey.keyS, shift: true)],
    importCode => [commandKey(LogicalKeyboardKey.keyI)],
    exportCode => [commandKey(LogicalKeyboardKey.keyE)],
    openSettings => [commandKey(LogicalKeyboardKey.comma)],
    undo => [commandKey(LogicalKeyboardKey.keyZ)],
    redo => [commandKey(LogicalKeyboardKey.keyZ, shift: true)],
    cut => [commandKey(LogicalKeyboardKey.keyX)],
    copy => [commandKey(LogicalKeyboardKey.keyC)],
    paste => [commandKey(LogicalKeyboardKey.keyV)],
    duplicate => [commandKey(LogicalKeyboardKey.keyD)],
    delete => const [
      SingleActivator(LogicalKeyboardKey.delete),
      SingleActivator(LogicalKeyboardKey.backspace),
    ],
    rename => const [SingleActivator(LogicalKeyboardKey.f2)],
    selectNext => const [SingleActivator(LogicalKeyboardKey.arrowDown)],
    selectPrevious => const [SingleActivator(LogicalKeyboardKey.arrowUp)],
    selectParent => const [SingleActivator(LogicalKeyboardKey.arrowLeft)],
    selectFirstChild => const [SingleActivator(LogicalKeyboardKey.arrowRight)],
    moveDown => [commandKey(LogicalKeyboardKey.arrowDown)],
    moveUp => [commandKey(LogicalKeyboardKey.arrowUp)],
    zoomIn => [commandKey(LogicalKeyboardKey.equal)],
    zoomOut => [commandKey(LogicalKeyboardKey.minus)],
    zoomReset => [commandKey(LogicalKeyboardKey.digit0)],
    showShortcuts => const [SingleActivator(LogicalKeyboardKey.f1)],
  };

  /// What the command does, in the user's language.
  String label(AppLocalizations l10n) => switch (this) {
    newProject => l10n.fileNew,
    openProject => l10n.fileOpen,
    saveProject => l10n.fileSave,
    saveProjectAs => l10n.fileSaveAs,
    importCode => l10n.menuImportCode,
    exportCode => l10n.menuExportCode,
    openSettings => l10n.menuSettings,
    undo => l10n.editorUndo,
    redo => l10n.editorRedo,
    cut => l10n.menuCut,
    copy => l10n.menuCopy,
    paste => l10n.menuPaste,
    duplicate => l10n.menuDuplicate,
    delete => l10n.editorDelete,
    rename => l10n.menuRenameWidget,
    selectNext => l10n.shortcutSelectNext,
    selectPrevious => l10n.shortcutSelectPrevious,
    selectParent => l10n.shortcutSelectParent,
    selectFirstChild => l10n.shortcutSelectFirstChild,
    moveDown => l10n.shortcutMoveDown,
    moveUp => l10n.shortcutMoveUp,
    zoomIn => l10n.menuZoomIn,
    zoomOut => l10n.menuZoomOut,
    zoomReset => l10n.menuZoomReset,
    showShortcuts => l10n.menuShortcuts,
  };
}

/// A shortcut as written on the keys: `Cmd+Shift+S`, `Ctrl+Z`, `Delete`.
String shortcutLabel(SingleActivator activator) {
  final isMac = defaultTargetPlatform == TargetPlatform.macOS;
  return [
    if (activator.meta) 'Cmd',
    if (activator.control) 'Ctrl',
    if (activator.alt) (isMac ? 'Option' : 'Alt'),
    if (activator.shift) 'Shift',
    _keyName(activator.trigger),
  ].join('+');
}

String _keyName(LogicalKeyboardKey key) {
  if (key == LogicalKeyboardKey.arrowUp) return 'Up';
  if (key == LogicalKeyboardKey.arrowDown) return 'Down';
  if (key == LogicalKeyboardKey.arrowLeft) return 'Left';
  if (key == LogicalKeyboardKey.arrowRight) return 'Right';
  if (key == LogicalKeyboardKey.delete) return 'Delete';
  if (key == LogicalKeyboardKey.backspace) return 'Backspace';
  if (key == LogicalKeyboardKey.equal) return '+';
  return key.keyLabel.length == 1 ? key.keyLabel.toUpperCase() : key.keyLabel;
}
