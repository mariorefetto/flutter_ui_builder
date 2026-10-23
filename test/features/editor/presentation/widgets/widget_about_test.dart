import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/widget_about.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/widget_help.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

void main() {
  final registry = WidgetRegistry(builtinDefinitions);
  late AppLocalizations l10n;

  setUp(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  test('every described widget is a widget of the catalog', () {
    expect(describedWidgets.where((t) => !registry.contains(t)), isEmpty);
  });

  test('the common widgets are described, in both languages', () async {
    final it = await AppLocalizations.delegate.load(const Locale('it'));

    for (final type in ['Column', 'Text', 'Scaffold', 'ElevatedButton']) {
      expect(widgetHelp(l10n, type), isNotEmpty, reason: type);
      expect(widgetHelp(it, type), isNot(widgetHelp(l10n, type)), reason: type);
    }
    expect(widgetHelp(l10n, 'Unheard'), isNull);
  });

  test('the rules say what a widget holds and where it goes', () {
    final appBar = aboutLines(l10n, registry.definitionFor('AppBar'));
    expect(appBar, contains('Holds no other widget.'));
    expect(
      appBar.any((l) => l.contains('Can only go inside: Scaffold')),
      isTrue,
    );

    final column = aboutLines(l10n, registry.definitionFor('Column'));
    expect(column.first, 'Holds any number of widgets.');

    final tile = aboutLines(l10n, registry.definitionFor('ListTile'));
    expect(tile.any((l) => l.contains('Material surface')), isTrue);
    expect(tile.any((l) => l.contains('Expanded')), isTrue);

    final safe = aboutLines(l10n, registry.definitionFor('SafeArea'));
    expect(safe, contains('It needs a widget inside it.'));
  });

  test('the link points at the right Flutter library', () {
    expect(
      flutterDocsUrl('Column'),
      'https://api.flutter.dev/flutter/widgets/Column-class.html',
    );
    expect(
      flutterDocsUrl('ElevatedButton'),
      'https://api.flutter.dev/flutter/material/ElevatedButton-class.html',
    );
    expect(
      flutterDocsUrl('CupertinoButton'),
      'https://api.flutter.dev/flutter/cupertino/CupertinoButton-class.html',
    );
  });
}
