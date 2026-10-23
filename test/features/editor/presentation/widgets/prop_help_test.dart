import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/project_theme_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/prop_help.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

void main() {
  late AppLocalizations l10n;

  setUp(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  test('every explained property exists on some widget or theme', () {
    final names = {
      for (final definition in builtinDefinitions)
        for (final prop in definition.props) prop.name,
      for (final part in themeParts)
        for (final prop in part.props) prop.name,
    };

    expect(describedProps.where((name) => !names.contains(name)), isEmpty);
  });

  test('a described property gets its sentence first', () {
    final tooltip = propTooltip(
      l10n,
      const PropSchema(
        name: 'fontSize',
        type: PropType.number,
        defaultValue: 14,
      ),
    );

    expect(tooltip.split('\n').first, startsWith('The size of the letters'));
    expect(tooltip, contains('Number'));
    expect(tooltip, contains('Default: 14'));
    expect(tooltip, contains('In the code: fontSize'));
  });

  test('a property without a sentence still says what the schema knows', () {
    final tooltip = propTooltip(
      l10n,
      const PropSchema(
        name: 'letterCase',
        type: PropType.choice,
        options: ['upper', 'lower'],
        argument: 'textCase',
        group: 'style',
      ),
    );

    expect(tooltip, contains('One of a list'));
    expect(tooltip, contains('Options: upper, lower'));
    expect(tooltip, contains('In the code: textCase of style'));
  });

  test('long option lists are cut and icon names are not listed', () {
    final many = propTooltip(
      l10n,
      PropSchema(
        name: 'x',
        type: PropType.choice,
        options: List.generate(20, (i) => 'o$i'),
      ),
    );
    final icons = propTooltip(
      l10n,
      const PropSchema(
        name: 'icon',
        type: PropType.choice,
        options: ['a', 'b'],
        iconPicker: true,
      ),
    );

    expect(many, contains('o7, ...'));
    expect(many, isNot(contains('o8')));
    expect(icons, isNot(contains('Options')));
  });
}
