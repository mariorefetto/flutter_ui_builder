import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/declarative_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/placement_rules.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_builders.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/sample_data.dart';

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
  _withSampleData(
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
  ),
  _withSampleData(
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

const Set<String> _delegateProps = {
  'crossAxisCount',
  'mainAxisSpacing',
  'crossAxisSpacing',
  'childAspectRatio',
};

/// The property that repeats the first widget of a list or grid.
final PropSchema _sampleCountProp = numberProp(
  sampleCountProp,
  integer: true,
  argument: 'itemCount',
);

/// A list or a grid that can also repeat its first widget a number of times,
/// to see it with data. Written as `ListView.builder` or `GridView.builder`,
/// where `{n}` in a text is the number of the item.
WidgetDefinition _withSampleData(WidgetDefinition base) {
  final isGrid = base.type == 'GridView';
  return base.copyWith(
    props: [...base.props, _sampleCountProp],
    aliases: {'${base.type}.builder'},
    generateCode: (values, children) {
      final count = values.number(sampleCountProp)?.round();
      if (count == null || count < 1 || children.isEmpty) {
        return base.generateCode(values, children);
      }
      final item = children.first.code.replaceAll(
        sampleNumberToken,
        r'${index + 1}',
      );
      // The grid's own settings go in its delegate, not beside the builder.
      final own = propArguments(
        base.props.where((p) => !_delegateProps.contains(p.name)).toList(),
        values,
        const {},
      );
      final arguments = {
        ...own,
        if (isGrid) 'gridDelegate': _gridDelegate(values),
        'itemCount': '$count',
        'itemBuilder': '(context, index) => $item',
      };
      return '${base.type}.builder(${dartArguments(arguments)})';
    },
  );
}

String _gridDelegate(NodeProps values) {
  final arguments = propArguments(
    [
      numberProp('crossAxisCount', integer: true, alwaysEmit: true),
      numberProp('mainAxisSpacing', defaultValue: 0.0),
      numberProp('crossAxisSpacing', defaultValue: 0.0),
      numberProp('childAspectRatio', defaultValue: 1.0),
    ],
    values,
    const {},
  );
  return 'SliverGridDelegateWithFixedCrossAxisCount('
      '${dartArguments(arguments)})';
}
