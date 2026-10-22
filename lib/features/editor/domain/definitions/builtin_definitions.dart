import 'package:flutter_ui_builder/features/editor/domain/definitions/content_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/control_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/cupertino_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/effect_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/information_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/layout_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/layout_extra_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/scaffold_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';

/// Every widget the builder offers. Adding a widget starts with a new
/// definition listed here, plus its preview in the presentation layer.
final List<WidgetDefinition> builtinDefinitions = [
  scaffoldDefinition,
  appBarDefinition,
  bottomAppBarDefinition,
  floatingActionButtonDefinition,
  navigationBarDefinition,
  navigationDestinationDefinition,
  containerDefinition,
  rowDefinition,
  columnDefinition,
  stackDefinition,
  paddingDefinition,
  ...layoutExtraDefinitions,
  textDefinition,
  imageDefinition,
  iconDefinition,
  ...buttonDefinitions,
  ...inputDefinitions,
  ...informationDefinitions,
  ...scrollingDefinitions,
  ...paintingDefinitions,
  ...animationDefinitions,
  ...interactionDefinitions,
  cupertinoPageScaffoldDefinition,
  cupertinoNavigationBarDefinition,
  ...cupertinoDefinitions,
];
