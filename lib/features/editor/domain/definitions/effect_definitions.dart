import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/declarative_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/decoration_code.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/placement_rules.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_builders.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/theme_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

final PropSchema _duration = numberProp(
  'duration',
  defaultValue: defaultAnimationMilliseconds,
  integer: true,
  template: 'Duration(milliseconds: {})',
  alwaysEmit: true,
);

PropSchema _curve() => choiceProp(
  'curve',
  curveOptions,
  defaultValue: 'linear',
  enumType: 'Curves',
);

PropSchema _alignment({bool required = false}) => choiceProp(
  'alignment',
  alignmentOptions,
  defaultValue: required ? 'center' : null,
  enumType: 'Alignment',
  alwaysEmit: required,
);

PropSchema _required(String name, num value) =>
    numberProp(name, defaultValue: value, alwaysEmit: true);

WidgetDefinition _single(
  String type,
  String category,
  List<PropSchema> props, {
  String? constructor,
  String? label,
  bool childRequired = false,
  Map<String, String> fixedArguments = const {},
  Set<String>? requiredAncestors,
}) => simpleDefinition(
  type: type,
  constructor: constructor,
  label: label,
  category: category,
  childPolicy: ChildPolicy.single,
  childRequired: childRequired,
  fixedArguments: fixedArguments,
  requiredAncestors: requiredAncestors,
  props: props,
);

WidgetDefinition _effect(
  String type,
  List<PropSchema> props, {
  String? constructor,
  String? label,
  bool childRequired = false,
}) => _single(
  type,
  paintingCategory,
  props,
  constructor: constructor,
  label: label,
  childRequired: childRequired,
);

WidgetDefinition _animated(
  String type,
  List<PropSchema> props, {
  bool withCurve = true,
}) => _single(type, animationCategory, [
  ...props,
  _duration,
  if (withCurve) _curve(),
]);

final List<WidgetDefinition> paintingDefinitions = [
  _effect('Opacity', [_required('opacity', 1.0)]),
  _effect('ClipRRect', [
    radiusProp('borderRadius', defaultValue: 0.0, alwaysEmit: true),
    choiceProp(
      'clipBehavior',
      clipOptions,
      defaultValue: 'antiAlias',
      enumType: 'Clip',
    ),
  ]),
  _effect('ClipOval', [
    choiceProp(
      'clipBehavior',
      clipOptions,
      defaultValue: 'antiAlias',
      enumType: 'Clip',
    ),
  ]),
  decoratedBoxDefinition,
  themeDefinition,
  _effect('ColoredBox', [
    colorProp('color', defaultValue: defaultFillColor, alwaysEmit: true),
  ]),
  _effect('RotatedBox', [
    numberProp(
      'quarterTurns',
      defaultValue: 0,
      integer: true,
      alwaysEmit: true,
    ),
  ]),
  _effect(
    'TransformRotate',
    [_required('angle', 0.0), _alignment(required: true)],
    constructor: 'Transform.rotate',
    label: 'Transform.rotate',
  ),
  _effect(
    'TransformScale',
    [_required('scale', 1.0), _alignment(required: true)],
    constructor: 'Transform.scale',
    label: 'Transform.scale',
  ),
  _effect('Visibility', [
    boolProp('visible', defaultValue: true),
    boolProp('maintainState', defaultValue: false),
  ], childRequired: true),
];

final List<WidgetDefinition> animationDefinitions = [
  _animated('AnimatedContainer', [
    numberProp('width'),
    numberProp('height'),
    colorProp('color'),
    insetsProp('padding'),
    insetsProp('margin'),
    _alignment(),
  ]),
  _animated('AnimatedOpacity', [_required('opacity', 1.0)]),
  _animated('AnimatedAlign', [_alignment(required: true)]),
  _animated('AnimatedPadding', [
    insetsProp('padding', defaultValue: defaultPadding, alwaysEmit: true),
  ]),
  _animated('AnimatedSize', [_alignment(required: true)]),
  _animated('AnimatedScale', [
    _required('scale', 1.0),
    _alignment(required: true),
  ]),
  _animated('AnimatedRotation', [
    _required('turns', 0.0),
    _alignment(required: true),
  ]),
  _animated('AnimatedSwitcher', const [], withCurve: false),
];

final List<WidgetDefinition> interactionDefinitions = [
  _single(
    'GestureDetector',
    interactionCategory,
    [
      choiceProp(
        'behavior',
        hitTestBehaviorOptions,
        enumType: 'HitTestBehavior',
      ),
    ],
    fixedArguments: const {'onTap': '() {}'},
  ),
  _single(
    'InkWell',
    interactionCategory,
    [
      radiusProp('borderRadius'),
      colorProp('splashColor'),
      colorProp('hoverColor'),
      colorProp('highlightColor'),
    ],
    fixedArguments: const {'onTap': '() {}'},
    requiredAncestors: materialAncestors,
  ),
  _single('IgnorePointer', interactionCategory, [
    boolProp('ignoring', defaultValue: true),
  ]),
  _single('Tooltip', interactionCategory, [
    stringProp('message', defaultValue: 'Tooltip', alwaysEmit: true),
    boolProp('preferBelow', defaultValue: true),
    numberProp('verticalOffset'),
  ]),
  _single('Semantics', accessibilityCategory, [
    stringProp('label'),
    stringProp('hint'),
    stringProp('value'),
    boolProp('button'),
    boolProp('header'),
    boolProp('excludeSemantics', defaultValue: false),
  ]),
  _single('ExcludeSemantics', accessibilityCategory, [
    boolProp('excluding', defaultValue: true),
  ]),
  _single('MergeSemantics', accessibilityCategory, const []),
];

final WidgetDefinition decoratedBoxDefinition = WidgetDefinition(
  type: 'DecoratedBox',
  label: 'DecoratedBox',
  category: paintingCategory,
  childPolicy: ChildPolicy.single,
  props: [
    ...decorationProps(),
    choiceProp('shape', boxShapeOptions, defaultValue: 'rectangle'),
    choiceProp(
      'position',
      decorationPositionOptions,
      defaultValue: 'background',
      enumType: 'DecorationPosition',
    ),
  ],
  generateCode: (props, children) {
    final arguments = dartArguments({
      'decoration':
          boxDecorationCode(props, shape: props.choice('shape')) ??
          'BoxDecoration()',
      'position': props.choice('position') == 'foreground'
          ? 'DecorationPosition.foreground'
          : null,
      'child': dartChild(children),
    });
    return 'DecoratedBox($arguments)';
  },
);
