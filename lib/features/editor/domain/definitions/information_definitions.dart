import 'package:flutter_ui_builder/features/editor/domain/definitions/declarative_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/placement_rules.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_builders.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';

final List<WidgetDefinition> informationDefinitions = [
  simpleDefinition(
    type: 'Card',
    category: informationCategory,
    childPolicy: ChildPolicy.single,
    props: [
      numberProp('elevation'),
      colorProp('color'),
      colorProp('shadowColor'),
      insetsProp('margin'),
      shapeRadiusProp('borderRadius'),
      choiceProp('clipBehavior', clipOptions, enumType: 'Clip'),
    ],
  ),
  simpleDefinition(
    type: 'ListTile',
    autoWrap: expandInRow,
    category: informationCategory,
    forbiddenParents: unboundedWidthParents,
    requiredAncestors: materialAncestors,
    props: [
      textProp('title', defaultValue: 'Title'),
      textProp('subtitle'),
      iconProp('leading'),
      iconProp('trailing'),
      boolProp('dense'),
      boolProp('isThreeLine', defaultValue: false),
      boolProp('selected', defaultValue: false),
      boolProp('enabled', defaultValue: true),
      colorProp('tileColor'),
      colorProp('iconColor'),
      colorProp('textColor'),
      insetsProp('contentPadding'),
    ],
  ),
  simpleDefinition(
    type: 'Divider',
    category: informationCategory,
    props: [
      numberProp('height'),
      numberProp('thickness'),
      numberProp('indent'),
      numberProp('endIndent'),
      colorProp('color'),
    ],
  ),
  simpleDefinition(
    type: 'VerticalDivider',
    category: informationCategory,
    forbiddenParents: unboundedHeightParents,
    props: [
      numberProp('width'),
      numberProp('thickness'),
      numberProp('indent'),
      numberProp('endIndent'),
      colorProp('color'),
    ],
  ),
  simpleDefinition(
    type: 'CircleAvatar',
    category: informationCategory,
    childPolicy: ChildPolicy.single,
    props: [
      numberProp('radius'),
      numberProp('minRadius'),
      numberProp('maxRadius'),
      colorProp('backgroundColor'),
      colorProp('foregroundColor'),
    ],
  ),
  simpleDefinition(
    type: 'Chip',
    category: informationCategory,
    requiredAncestors: materialAncestors,
    props: [
      textProp('label', defaultValue: 'Chip'),
      iconProp('avatar'),
      colorProp('backgroundColor'),
      numberProp('elevation'),
    ],
  ),
  simpleDefinition(
    type: 'Badge',
    category: informationCategory,
    childPolicy: ChildPolicy.single,
    props: [
      textProp('label', defaultValue: '1'),
      colorProp('backgroundColor'),
      colorProp('textColor'),
      boolProp('isLabelVisible', defaultValue: true),
    ],
  ),
  simpleDefinition(
    type: 'LinearProgressIndicator',
    autoWrap: expandInRow,
    category: informationCategory,
    forbiddenParents: unboundedWidthParents,
    props: [
      numberProp('value'),
      colorProp('color'),
      colorProp('backgroundColor'),
      numberProp('minHeight'),
      stringProp('semanticsLabel'),
    ],
  ),
  simpleDefinition(
    type: 'CircularProgressIndicator',
    category: informationCategory,
    props: [
      numberProp('value'),
      numberProp('strokeWidth', defaultValue: 4.0),
      colorProp('color'),
      colorProp('backgroundColor'),
      stringProp('semanticsLabel'),
    ],
  ),
  simpleDefinition(
    type: 'Placeholder',
    category: informationCategory,
    props: [
      colorProp('color'),
      numberProp('strokeWidth', defaultValue: 2.0),
      numberProp('fallbackWidth', defaultValue: 400.0),
      numberProp('fallbackHeight', defaultValue: 400.0),
    ],
  ),
];

final List<WidgetDefinition> scrollingDefinitions = [
  simpleDefinition(
    type: 'ListView',
    autoWrap: expandInRowOrColumn,
    category: scrollingCategory,
    childPolicy: ChildPolicy.multiple,
    forbiddenParents: scrollableBlockers,
    props: [
      insetsProp('padding'),
      boolProp('reverse', defaultValue: false),
      boolProp('shrinkWrap', defaultValue: false),
      numberProp('itemExtent'),
    ],
  ),
  simpleDefinition(
    type: 'GridView',
    autoWrap: expandInRowOrColumn,
    constructor: 'GridView.count',
    category: scrollingCategory,
    childPolicy: ChildPolicy.multiple,
    forbiddenParents: scrollableBlockers,
    props: [
      numberProp(
        'crossAxisCount',
        defaultValue: 2,
        integer: true,
        alwaysEmit: true,
      ),
      numberProp('mainAxisSpacing', defaultValue: 0.0),
      numberProp('crossAxisSpacing', defaultValue: 0.0),
      numberProp('childAspectRatio', defaultValue: 1.0),
      insetsProp('padding'),
      boolProp('reverse', defaultValue: false),
      boolProp('shrinkWrap', defaultValue: false),
    ],
  ),
  simpleDefinition(
    type: 'SingleChildScrollView',
    autoWrap: expandInRowOrColumn,
    category: scrollingCategory,
    childPolicy: ChildPolicy.single,
    forbiddenParents: scrollableBlockers,
    props: [
      insetsProp('padding'),
      boolProp('reverse', defaultValue: false),
      choiceProp(
        'scrollDirection',
        axisOptions,
        defaultValue: 'vertical',
        enumType: 'Axis',
      ),
    ],
  ),
];
