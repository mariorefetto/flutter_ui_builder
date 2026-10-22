import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Icons of the widgets that are most recognisable by their own, as the
/// Flutter widget catalog pictures them. Every other widget takes the icon of
/// its category.
const Map<String, IconData> _typeIcons = {
  'Scaffold': LucideIcons.panelTop,
  'AppBar': LucideIcons.panelTop,
  'BottomAppBar': LucideIcons.panelBottom,
  'NavigationBar': LucideIcons.panelBottom,
  'Column': LucideIcons.rows3,
  'Row': LucideIcons.columns3,
  'Stack': LucideIcons.layers,
  'Container': LucideIcons.square,
  'Padding': LucideIcons.scan,
  'Center': LucideIcons.focus,
  'Align': LucideIcons.alignCenter,
  'SizedBox': LucideIcons.ruler,
  'Expanded': LucideIcons.maximize2,
  'Flexible': LucideIcons.maximize2,
  'Spacer': LucideIcons.moveHorizontal,
  'Text': LucideIcons.type,
  'Image': LucideIcons.image,
  'Icon': LucideIcons.star,
  'ListView': LucideIcons.list,
  'GridView': LucideIcons.layoutGrid,
  'Card': LucideIcons.squareStack,
  'Divider': LucideIcons.minus,
  'VerticalDivider': LucideIcons.gripVertical,
  'Switch': LucideIcons.toggleLeft,
  'Checkbox': LucideIcons.squareCheck,
  'Slider': LucideIcons.slidersHorizontal,
  'TextField': LucideIcons.textCursorInput,
  'CircularProgressIndicator': LucideIcons.loader,
  'LinearProgressIndicator': LucideIcons.loader,
  'CircleAvatar': LucideIcons.circleUser,
  'Chip': LucideIcons.tag,
  'FloatingActionButton': LucideIcons.circlePlus,
  'ListTile': LucideIcons.listChecks,
  'SafeArea': LucideIcons.shield,
  'Theme': LucideIcons.palette,
  'Table': LucideIcons.table,
};

const Map<String, IconData> _categoryIcons = {
  screenCategory: LucideIcons.smartphone,
  layoutCategory: LucideIcons.layoutGrid,
  textCategory: LucideIcons.type,
  imagesCategory: LucideIcons.image,
  buttonsCategory: LucideIcons.mousePointerClick,
  inputCategory: LucideIcons.textCursorInput,
  informationCategory: LucideIcons.badgeInfo,
  scrollingCategory: LucideIcons.scroll,
  paintingCategory: LucideIcons.paintbrush,
  animationCategory: LucideIcons.sparkles,
  interactionCategory: LucideIcons.pointer,
  accessibilityCategory: LucideIcons.accessibility,
  cupertinoCategory: LucideIcons.apple,
};

/// The icon of a widget in the palette and the outline.
IconData iconForWidget(String type, String category) =>
    _typeIcons[type] ?? iconForCategory(category);

IconData iconForCategory(String category) =>
    _categoryIcons[category] ?? LucideIcons.box;

/// A colour for a category, from the theme's roles, so the same kind of
/// widget reads alike in the palette and the outline in both brightnesses.
Color colorForCategory(ColorScheme colors, String category) =>
    switch (category) {
      layoutCategory || scrollingCategory => colors.primary,
      textCategory || imagesCategory || informationCategory => colors.secondary,
      buttonsCategory ||
      inputCategory ||
      interactionCategory => colors.tertiary,
      paintingCategory ||
      animationCategory ||
      accessibilityCategory => colors.error,
      _ => colors.onSurfaceVariant,
    };
