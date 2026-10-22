import 'package:flutter_ui_builder/features/editor/domain/definitions/declarative_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

const Set<String> _flexParents = {'Row', 'Column'};

const PropSchema _factorWidth = PropSchema(
  name: 'widthFactor',
  type: PropType.number,
);
const PropSchema _factorHeight = PropSchema(
  name: 'heightFactor',
  type: PropType.number,
);

const PropSchema _alignment = PropSchema(
  name: 'alignment',
  type: PropType.choice,
  defaultValue: 'center',
  options: alignmentOptions,
  enumType: 'Alignment',
);

const PropSchema _flex = PropSchema(
  name: 'flex',
  type: PropType.number,
  defaultValue: defaultFlex,
  integer: true,
);

final WidgetDefinition centerDefinition = simpleDefinition(
  type: 'Center',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  props: const [_factorWidth, _factorHeight],
);

final WidgetDefinition alignDefinition = simpleDefinition(
  type: 'Align',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  props: const [_alignment, _factorWidth, _factorHeight],
);

final WidgetDefinition sizedBoxDefinition = simpleDefinition(
  type: 'SizedBox',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  props: const [
    PropSchema(name: 'width', type: PropType.number),
    PropSchema(name: 'height', type: PropType.number),
  ],
);

final WidgetDefinition fractionallySizedBoxDefinition = simpleDefinition(
  type: 'FractionallySizedBox',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  props: const [_alignment, _factorWidth, _factorHeight],
);

final WidgetDefinition aspectRatioDefinition = simpleDefinition(
  type: 'AspectRatio',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  props: const [
    PropSchema(
      name: 'aspectRatio',
      type: PropType.number,
      defaultValue: 1.0,
      alwaysEmit: true,
    ),
  ],
);

final WidgetDefinition fittedBoxDefinition = simpleDefinition(
  type: 'FittedBox',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  props: const [
    PropSchema(
      name: 'fit',
      type: PropType.choice,
      defaultValue: 'contain',
      options: boxFitOptions,
      enumType: 'BoxFit',
    ),
    _alignment,
  ],
);

final WidgetDefinition safeAreaDefinition = simpleDefinition(
  type: 'SafeArea',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  childRequired: true,
  props: const [
    PropSchema(name: 'left', type: PropType.boolean, defaultValue: true),
    PropSchema(name: 'top', type: PropType.boolean, defaultValue: true),
    PropSchema(name: 'right', type: PropType.boolean, defaultValue: true),
    PropSchema(name: 'bottom', type: PropType.boolean, defaultValue: true),
  ],
);

final WidgetDefinition intrinsicHeightDefinition = simpleDefinition(
  type: 'IntrinsicHeight',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
);

final WidgetDefinition intrinsicWidthDefinition = simpleDefinition(
  type: 'IntrinsicWidth',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
);

final WidgetDefinition wrapDefinition = simpleDefinition(
  type: 'Wrap',
  category: layoutCategory,
  childPolicy: ChildPolicy.multiple,
  props: const [
    PropSchema(
      name: 'direction',
      type: PropType.choice,
      defaultValue: 'horizontal',
      options: axisOptions,
      enumType: 'Axis',
    ),
    PropSchema(
      name: 'alignment',
      type: PropType.choice,
      defaultValue: 'start',
      options: wrapAlignmentOptions,
      enumType: 'WrapAlignment',
    ),
    PropSchema(
      name: 'crossAxisAlignment',
      type: PropType.choice,
      defaultValue: 'start',
      options: wrapCrossAlignmentOptions,
      enumType: 'WrapCrossAlignment',
    ),
    PropSchema(name: 'spacing', type: PropType.number, defaultValue: 0.0),
    PropSchema(name: 'runSpacing', type: PropType.number, defaultValue: 0.0),
  ],
);

final WidgetDefinition expandedDefinition = simpleDefinition(
  type: 'Expanded',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  childRequired: true,
  allowedParents: _flexParents,
  props: const [_flex],
);

final WidgetDefinition flexibleDefinition = simpleDefinition(
  type: 'Flexible',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  childRequired: true,
  allowedParents: _flexParents,
  props: const [
    _flex,
    PropSchema(
      name: 'fit',
      type: PropType.choice,
      defaultValue: 'loose',
      options: flexFitOptions,
      enumType: 'FlexFit',
    ),
  ],
);

final WidgetDefinition spacerDefinition = simpleDefinition(
  type: 'Spacer',
  category: layoutCategory,
  allowedParents: _flexParents,
  props: const [_flex],
);

final WidgetDefinition positionedDefinition = simpleDefinition(
  type: 'Positioned',
  category: layoutCategory,
  childPolicy: ChildPolicy.single,
  childRequired: true,
  allowedParents: const {'Stack'},
  props: const [
    PropSchema(name: 'left', type: PropType.number),
    PropSchema(name: 'top', type: PropType.number),
    PropSchema(name: 'right', type: PropType.number),
    PropSchema(name: 'bottom', type: PropType.number),
    PropSchema(name: 'width', type: PropType.number),
    PropSchema(name: 'height', type: PropType.number),
  ],
);

final List<WidgetDefinition> layoutExtraDefinitions = [
  centerDefinition,
  alignDefinition,
  sizedBoxDefinition,
  fractionallySizedBoxDefinition,
  aspectRatioDefinition,
  fittedBoxDefinition,
  safeAreaDefinition,
  intrinsicHeightDefinition,
  intrinsicWidthDefinition,
  wrapDefinition,
  expandedDefinition,
  flexibleDefinition,
  spacerDefinition,
  positionedDefinition,
];
