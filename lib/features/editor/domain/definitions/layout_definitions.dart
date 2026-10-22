import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/declarative_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/decoration_code.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_builders.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_child.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

final List<PropSchema> _flexProps = [
  choiceProp(
    'mainAxisSize',
    mainAxisSizeOptions,
    defaultValue: 'max',
    enumType: 'MainAxisSize',
  ),
  choiceProp(
    'mainAxisAlignment',
    mainAxisAlignmentOptions,
    defaultValue: 'start',
    enumType: 'MainAxisAlignment',
  ),
  choiceProp(
    'crossAxisAlignment',
    crossAxisAlignmentOptions,
    defaultValue: 'center',
    enumType: 'CrossAxisAlignment',
  ),
  numberProp('spacing', defaultValue: 0.0),
];

WidgetDefinition _flex(String type) => simpleDefinition(
  type: type,
  category: layoutCategory,
  childPolicy: ChildPolicy.multiple,
  props: _flexProps,
);

final WidgetDefinition columnDefinition = _flex('Column');

final WidgetDefinition rowDefinition = _flex('Row');

final WidgetDefinition stackDefinition = simpleDefinition(
  type: 'Stack',
  category: layoutCategory,
  childPolicy: ChildPolicy.multiple,
  props: [
    choiceProp(
      'alignment',
      alignmentOptions,
      defaultValue: 'topLeft',
      enumType: 'Alignment',
    ),
    choiceProp(
      'fit',
      stackFitOptions,
      defaultValue: 'loose',
      enumType: 'StackFit',
    ),
    choiceProp(
      'clipBehavior',
      clipOptions,
      defaultValue: 'hardEdge',
      enumType: 'Clip',
    ),
  ],
);

final WidgetDefinition paddingDefinition = simpleDefinition(
  type: 'Padding',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  props: [
    insetsProp('padding', defaultValue: defaultPadding, alwaysEmit: true),
  ],
);

final List<PropSchema> _containerProps = [
  numberProp('width'),
  numberProp('height'),
  insetsProp('padding'),
  insetsProp('margin'),
  choiceProp('alignment', alignmentOptions, enumType: 'Alignment'),
  numberProp('minWidth'),
  numberProp('maxWidth'),
  numberProp('minHeight'),
  numberProp('maxHeight'),
  ...decorationProps(),
  choiceProp('shape', boxShapeOptions, defaultValue: 'rectangle'),
];

/// Fill, border, shadow and the rest live in a BoxDecoration, which Container
/// does not allow next to a plain `color`, so the color goes inside it.
String _containerCode(NodeProps props, List<GeneratedChild> children) {
  final constraints = dartArguments({
    'minWidth': props.number('minWidth').let(dartDouble),
    'maxWidth': props.number('maxWidth').let(dartDouble),
    'minHeight': props.number('minHeight').let(dartDouble),
    'maxHeight': props.number('maxHeight').let(dartDouble),
  });
  final arguments = dartArguments({
    'width': props.number('width').let(dartDouble),
    'height': props.number('height').let(dartDouble),
    'decoration': boxDecorationCode(props, shape: props.choice('shape')),
    'constraints': constraints.isEmpty ? null : 'BoxConstraints($constraints)',
    'padding': props.edgeInsets('padding').let(dartEdgeInsets),
    'margin': props.edgeInsets('margin').let(dartEdgeInsets),
    'alignment': props.choice('alignment').let((v) => 'Alignment.$v'),
    'child': dartChild(children),
  });
  return 'Container($arguments)';
}

final WidgetDefinition containerDefinition = WidgetDefinition(
  type: 'Container',
  label: 'Container',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  props: _containerProps,
  generateCode: _containerCode,
);
