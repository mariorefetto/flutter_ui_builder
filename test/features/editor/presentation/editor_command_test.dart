import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_command.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

void main() {
  test('every command has keys and a name', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    for (final command in EditorCommand.values) {
      expect(command.activators, isNotEmpty, reason: command.name);
      expect(command.label(l10n), isNotEmpty, reason: command.name);
    }
  });

  test('two commands never share keys', () {
    final seen = <String, EditorCommand>{};
    for (final command in EditorCommand.values) {
      for (final activator in command.activators) {
        final key = shortcutLabel(activator);
        expect(
          seen[key],
          isNull,
          reason: '$key is used by ${seen[key]?.name} and ${command.name}',
        );
        seen[key] = command;
      }
    }
  });

  test('every command is in a group of the list', () {
    for (final group in ShortcutGroup.values) {
      expect(
        EditorCommand.values.where((c) => c.group == group),
        isNotEmpty,
        reason: group.name,
      );
    }
  });

  group('written as on the keys', () {
    tearDown(() => debugDefaultTargetPlatformOverride = null);

    test('on a Mac the command key is Cmd', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

      expect(
        shortcutLabel(EditorCommand.saveProjectAs.activators.single),
        'Cmd+Shift+S',
      );
    });

    test('elsewhere it is Ctrl', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;

      expect(shortcutLabel(EditorCommand.undo.activators.single), 'Ctrl+Z');
    });

    test('keys without a letter get a name', () {
      expect(EditorCommand.delete.activators.map(shortcutLabel), [
        'Delete',
        'Backspace',
      ]);
      expect(shortcutLabel(EditorCommand.selectNext.activators.single), 'Down');
      expect(
        shortcutLabel(EditorCommand.showShortcuts.activators.single),
        'F1',
      );
      expect(
        shortcutLabel(const SingleActivator(LogicalKeyboardKey.equal)),
        '+',
      );
    });
  });
}
