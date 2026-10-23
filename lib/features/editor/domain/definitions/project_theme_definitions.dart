import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/declarative_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_builders.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_theme.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

/// The color the seed of a new theme has: the Material 3 baseline purple.
const int defaultThemeSeed = 0xFF6750A4;

/// Light or dark.
const List<String> themeBrightnessOptions = ['light', 'dark'];

/// The look of the borders of text fields.
const List<String> inputBorderStyles = ['outline', 'underline', 'none'];

/// One part of the theme: the global settings or the theme of one kind of
/// widget. [arguments] turns its values into the arguments it adds to
/// `ThemeData(...)`, and nothing when the part is as Flutter has it.
class ThemePart {
  const ThemePart({
    required this.name,
    required this.props,
    required this.arguments,
  });

  /// The key the part's values are stored under.
  final String name;
  final List<PropSchema> props;
  final Map<String, String?> Function(NodeProps values) arguments;
}

String _radius(double value) =>
    'RoundedRectangleBorder(borderRadius: BorderRadius.circular(${dartDouble(value)}))';

Map<String, String?> _scheme(NodeProps values) {
  final seed = values.color('seedColor') ?? defaultThemeSeed;
  final dark = values.choice('brightness') == 'dark';
  final custom = seed != defaultThemeSeed || dark;
  return {
    if (values.boolean('useMaterial3') == false) 'useMaterial3': 'false',
    if (custom)
      'colorScheme':
          'ColorScheme.fromSeed(seedColor: ${dartColor(seed)}'
          '${dark ? ', brightness: Brightness.dark' : ''})',
    if (values.string('fontFamily') case final family? when family.isNotEmpty)
      'fontFamily': dartString(family),
  };
}

Map<String, String?> _appBar(NodeProps values) {
  final arguments = _own(_appBarProps, values);
  return {
    if (arguments.isNotEmpty)
      'appBarTheme': 'AppBarTheme(${dartArguments(arguments)})',
  };
}

Map<String, String?> _own(List<PropSchema> props, NodeProps values) =>
    propArguments(props, values, const {});

final List<PropSchema> _appBarProps = [
  colorProp('backgroundColor'),
  colorProp('foregroundColor'),
  numberProp('elevation'),
  boolProp('centerTitle'),
];

List<PropSchema> _buttonProps({bool background = true}) => [
  if (background) colorProp('backgroundColor'),
  colorProp('foregroundColor'),
  if (background) numberProp('elevation'),
  numberProp('borderRadius'),
];

/// A button theme: `ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
/// ...))`.
ThemePart _buttonPart(String name, String widget, {bool background = true}) {
  final props = _buttonProps(background: background);
  return ThemePart(
    name: name,
    props: props,
    arguments: (values) {
      final style = {
        for (final entry in _own(
          props.where((p) => p.name != 'borderRadius').toList(),
          values,
        ).entries)
          entry.key: entry.value,
        if (values.number('borderRadius') case final radius?)
          'shape': _radius(radius),
      };
      return {
        if (style.isNotEmpty)
          '${name}Theme':
              '${widget}ThemeData(style: $widget.styleFrom(${dartArguments(style)}))',
      };
    },
  );
}

final List<PropSchema> _cardProps = [
  colorProp('color'),
  numberProp('elevation'),
  numberProp('borderRadius'),
  insetsProp('margin'),
];

final List<PropSchema> _inputProps = [
  boolProp('filled', defaultValue: false),
  colorProp('fillColor'),
  choiceProp('border', inputBorderStyles, defaultValue: 'underline'),
  numberProp('borderRadius'),
];

final List<PropSchema> _fabProps = [
  colorProp('backgroundColor'),
  colorProp('foregroundColor'),
];

final List<PropSchema> _listTileProps = [
  colorProp('iconColor'),
  colorProp('textColor'),
  colorProp('tileColor'),
];

final List<PropSchema> _dividerProps = [
  colorProp('color'),
  numberProp('thickness'),
];

Map<String, String?> _simple(
  String argument,
  String dataClass,
  List<PropSchema> props,
  NodeProps values,
) {
  final arguments = _own(props, values);
  return {
    if (arguments.isNotEmpty)
      argument: '$dataClass(${dartArguments(arguments)})',
  };
}

/// Every part of the theme the user can change, in the order they are shown.
final List<ThemePart> themeParts = [
  ThemePart(
    name: 'scheme',
    props: [
      colorProp('seedColor', defaultValue: defaultThemeSeed),
      choiceProp('brightness', themeBrightnessOptions, defaultValue: 'light'),
      boolProp('useMaterial3', defaultValue: true),
      stringProp('fontFamily'),
    ],
    arguments: _scheme,
  ),
  ThemePart(name: 'appBar', props: _appBarProps, arguments: _appBar),
  _buttonPart('elevatedButton', 'ElevatedButton'),
  _buttonPart('filledButton', 'FilledButton'),
  _buttonPart('outlinedButton', 'OutlinedButton', background: false),
  _buttonPart('textButton', 'TextButton', background: false),
  ThemePart(
    name: 'card',
    props: _cardProps,
    arguments: (values) {
      final arguments = {
        ..._own(
          _cardProps.where((p) => p.name != 'borderRadius').toList(),
          values,
        ),
        if (values.number('borderRadius') case final radius?)
          'shape': _radius(radius),
      };
      return {
        if (arguments.isNotEmpty)
          'cardTheme': 'CardThemeData(${dartArguments(arguments)})',
      };
    },
  ),
  ThemePart(
    name: 'inputDecoration',
    props: _inputProps,
    arguments: (values) {
      final radius = values.number('borderRadius');
      final border = switch (values.choice('border')) {
        'outline' =>
          'OutlineInputBorder(${radius == null ? '' : 'borderRadius: BorderRadius.circular(${dartDouble(radius)})'})',
        'none' => 'InputBorder.none',
        _ => null,
      };
      final arguments = {
        ..._own(
          _inputProps
              .where((p) => p.name == 'filled' || p.name == 'fillColor')
              .toList(),
          values,
        ),
        'border': ?border,
      };
      return {
        if (arguments.isNotEmpty)
          'inputDecorationTheme':
              'InputDecorationTheme(${dartArguments(arguments)})',
      };
    },
  ),
  ThemePart(
    name: 'floatingActionButton',
    props: _fabProps,
    arguments: (values) => _simple(
      'floatingActionButtonTheme',
      'FloatingActionButtonThemeData',
      _fabProps,
      values,
    ),
  ),
  ThemePart(
    name: 'listTile',
    props: _listTileProps,
    arguments: (values) =>
        _simple('listTileTheme', 'ListTileThemeData', _listTileProps, values),
  ),
  ThemePart(
    name: 'divider',
    props: _dividerProps,
    arguments: (values) =>
        _simple('dividerTheme', 'DividerThemeData', _dividerProps, values),
  ),
];

/// The part called [name], or null.
ThemePart? themePartNamed(String name) =>
    themeParts.where((p) => p.name == name).firstOrNull;

/// The arguments `ThemeData(...)` needs to be the theme [theme] describes.
Map<String, String?> themeArguments(ProjectTheme theme) => {
  for (final part in themeParts)
    ...part.arguments(theme.valuesOf(part.name, part.props)),
};
