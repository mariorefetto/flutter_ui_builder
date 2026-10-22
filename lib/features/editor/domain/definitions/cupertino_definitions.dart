import 'package:flutter_ui_builder/features/editor/domain/definitions/declarative_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/placement_rules.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_builders.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

// Widgets that stretch to the width they are given.
const Set<String> _fillsWidth = {
  'CupertinoSlider',
  'CupertinoTextField',
  'CupertinoSearchTextField',
  'CupertinoListTile',
};

const Set<String> _library = {'package:flutter/cupertino.dart'};
const Map<String, String> _onChanged = {'onChanged': '(value) {}'};

PropSchema get _value => const PropSchema(
  name: 'value',
  type: PropType.boolean,
  defaultValue: false,
  alwaysEmit: true,
);

WidgetDefinition _cupertino(
  String type,
  List<PropSchema> props, {
  String? constructor,
  String? label,
  ChildPolicy childPolicy = ChildPolicy.none,
  Map<String, String> fixedArguments = const {},
}) => simpleDefinition(
  type: type,
  constructor: constructor,
  label: label,
  category: cupertinoCategory,
  childPolicy: childPolicy,
  props: props,
  fixedArguments: fixedArguments,
  imports: _library,
  childRequired: childPolicy == ChildPolicy.single,
  forbiddenParents: _fillsWidth.contains(type)
      ? unboundedWidthParents
      : const {},
  autoWrap: _fillsWidth.contains(type) ? expandInRow : const {},
);

List<PropSchema> get _buttonProps => [
  insetsProp('padding'),
  radiusProp('borderRadius'),
  numberProp('pressedOpacity', defaultValue: 0.4),
];

final List<WidgetDefinition> cupertinoDefinitions = [
  _cupertino(
    'CupertinoButton',
    [colorProp('color'), ..._buttonProps],
    childPolicy: ChildPolicy.single,
    fixedArguments: const {'onPressed': '() {}'},
  ),
  _cupertino(
    'CupertinoButtonFilled',
    _buttonProps,
    constructor: 'CupertinoButton.filled',
    label: 'CupertinoButton.filled',
    childPolicy: ChildPolicy.single,
    fixedArguments: const {'onPressed': '() {}'},
  ),
  _cupertino('CupertinoSwitch', [
    _value,
    colorProp('activeTrackColor'),
    colorProp('inactiveTrackColor'),
    colorProp('thumbColor'),
  ], fixedArguments: _onChanged),
  _cupertino('CupertinoCheckbox', [
    _value,
    colorProp('activeColor'),
    colorProp('checkColor'),
  ], fixedArguments: _onChanged),
  _cupertino('CupertinoSlider', [
    numberProp('value', defaultValue: 0.5, alwaysEmit: true),
    numberProp('min', defaultValue: 0.0),
    numberProp('max', defaultValue: 1.0),
    numberProp('divisions', integer: true),
    colorProp('activeColor'),
    colorProp('thumbColor'),
  ], fixedArguments: _onChanged),
  _cupertino('CupertinoActivityIndicator', [
    numberProp('radius', defaultValue: 10.0),
    colorProp('color'),
    boolProp('animating', defaultValue: true),
  ]),
  _cupertino('CupertinoTextField', [
    stringProp('placeholder'),
    choiceProp('keyboardType', keyboardTypeOptions, enumType: 'TextInputType'),
    choiceProp('textAlign', textAlignOptions, enumType: 'TextAlign'),
    boolProp('obscureText', defaultValue: false),
    numberProp('maxLines', defaultValue: 1, integer: true),
    numberProp('maxLength', integer: true),
    boolProp('enabled', defaultValue: true),
    boolProp('readOnly', defaultValue: false),
    choiceProp(
      'clearButtonMode',
      overlayVisibilityOptions,
      defaultValue: 'never',
      enumType: 'OverlayVisibilityMode',
    ),
  ]),
  _cupertino('CupertinoSearchTextField', [
    stringProp('placeholder'),
    colorProp('backgroundColor'),
    boolProp('enabled', defaultValue: true),
  ]),
  _cupertino('CupertinoListTile', [
    textProp('title', defaultValue: 'Title'),
    textProp('subtitle'),
    textProp('additionalInfo'),
    iconProp('leading'),
    iconProp('trailing'),
    colorProp('backgroundColor'),
  ]),
];
