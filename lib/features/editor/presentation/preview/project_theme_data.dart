import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/project_theme_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_theme.dart';

NodeProps _values(ProjectTheme theme, String part) =>
    theme.valuesOf(part, themePartNamed(part)?.props ?? const []);

Color? _color(NodeProps values, String name) {
  final value = values.color(name);
  return value == null ? null : Color(value);
}

OutlinedBorder? _shape(NodeProps values) {
  final radius = values.number('borderRadius');
  return radius == null
      ? null
      : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
}

/// Whether the theme is the dark one.
bool themeIsDark(ProjectTheme theme) =>
    _values(theme, 'scheme').choice('brightness') == 'dark';

ProjectTheme? _lastTheme;
ThemeData? _lastData;

/// Like [themeDataOf] but remembers the last one: the designer asks for the
/// theme on every change of the screen, and building a colour scheme from a
/// seed is not free.
ThemeData cachedThemeDataOf(ProjectTheme theme) {
  final last = _lastData;
  if (last != null && _lastTheme == theme) return last;
  final data = themeDataOf(theme);
  _lastTheme = theme;
  _lastData = data;
  return data;
}

/// The Flutter theme the project's theme describes, the same one the code
/// of `buildAppTheme` builds, so the designer shows what the app will be.
ThemeData themeDataOf(ProjectTheme theme) {
  final scheme = _values(theme, 'scheme');
  final appBar = _values(theme, 'appBar');
  final card = _values(theme, 'card');
  final input = _values(theme, 'inputDecoration');
  final fab = _values(theme, 'floatingActionButton');
  final listTile = _values(theme, 'listTile');
  final divider = _values(theme, 'divider');
  final family = scheme.string('fontFamily');
  return ThemeData(
    useMaterial3: scheme.boolean('useMaterial3') ?? true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(scheme.color('seedColor') ?? defaultThemeSeed),
      brightness: scheme.choice('brightness') == 'dark'
          ? Brightness.dark
          : Brightness.light,
    ),
    fontFamily: family == null || family.isEmpty ? null : family,
    appBarTheme: AppBarTheme(
      backgroundColor: _color(appBar, 'backgroundColor'),
      foregroundColor: _color(appBar, 'foregroundColor'),
      elevation: appBar.number('elevation'),
      centerTitle: appBar.boolean('centerTitle'),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _button(
        _values(theme, 'elevatedButton'),
        ElevatedButton.styleFrom,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: _button(_values(theme, 'filledButton'), FilledButton.styleFrom),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: _button(
        _values(theme, 'outlinedButton'),
        OutlinedButton.styleFrom,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: _button(_values(theme, 'textButton'), TextButton.styleFrom),
    ),
    cardTheme: CardThemeData(
      color: _color(card, 'color'),
      elevation: card.number('elevation'),
      margin: card.edgeInsets('margin') == null
          ? null
          : EdgeInsets.fromLTRB(
              card.edgeInsets('margin')!.left,
              card.edgeInsets('margin')!.top,
              card.edgeInsets('margin')!.right,
              card.edgeInsets('margin')!.bottom,
            ),
      shape: _shape(card),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: input.boolean('filled'),
      fillColor: _color(input, 'fillColor'),
      border: switch (input.choice('border')) {
        'outline' => OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            input.number('borderRadius') ?? 4,
          ),
        ),
        'none' => InputBorder.none,
        _ => null,
      },
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _color(fab, 'backgroundColor'),
      foregroundColor: _color(fab, 'foregroundColor'),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: _color(listTile, 'iconColor'),
      textColor: _color(listTile, 'textColor'),
      tileColor: _color(listTile, 'tileColor'),
    ),
    dividerTheme: DividerThemeData(
      color: _color(divider, 'color'),
      thickness: divider.number('thickness'),
    ),
  );
}

ButtonStyle _button(
  NodeProps values,
  ButtonStyle Function({
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    OutlinedBorder? shape,
  })
  styleFrom,
) => styleFrom(
  backgroundColor: _color(values, 'backgroundColor'),
  foregroundColor: _color(values, 'foregroundColor'),
  elevation: values.number('elevation'),
  shape: _shape(values),
);
