import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_builders.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';

/// A Theme around a part of the screen, with a color scheme made from one
/// seed color. Everything inside takes its colors from it. It sets a new theme
/// rather than adjusting the one outside.
final WidgetDefinition themeDefinition = WidgetDefinition(
  type: 'Theme',
  label: 'Theme',
  category: paintingCategory,
  childPolicy: ChildPolicy.single,
  requiresChild: true,
  props: [
    colorProp('seedColor', defaultValue: defaultSeedColor),
    choiceProp(
      'brightness',
      brightnessOptions,
      defaultValue: 'light',
      enumType: 'Brightness',
    ),
  ],
  generateCode: (props, children) {
    final seed = dartColor(props.color('seedColor') ?? defaultSeedColor);
    final brightness = props.choice('brightness');
    final scheme = dartArguments({
      'seedColor': seed,
      'brightness': brightness == 'dark' ? 'Brightness.dark' : null,
    });
    return 'Theme(data: ThemeData(colorScheme: ColorScheme.fromSeed($scheme)), '
        'child: ${dartChild(children) ?? 'SizedBox.shrink()'})';
  },
);
