import 'package:flutter_ui_builder/features/editor/domain/definitions/declarative_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/placement_rules.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_builders.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

const Map<String, String> _onPressed = {'onPressed': '() {}'};
const Map<String, String> _onChanged = {'onChanged': '(value) {}'};

PropSchema get _value => const PropSchema(
  name: 'value',
  type: PropType.boolean,
  defaultValue: false,
  alwaysEmit: true,
);

List<PropSchema> _buttonProps(String group) => [
  colorProp('backgroundColor', group: group),
  colorProp('foregroundColor', group: group),
  insetsProp('padding', group: group),
  numberProp('elevation', group: group),
  shapeRadiusProp('borderRadius', group: group),
];

WidgetDefinition _button(String type) => simpleDefinition(
  type: type,
  category: buttonsCategory,
  childPolicy: ChildPolicy.single,
  childRequired: true,
  fixedArguments: _onPressed,
  groups: {'style': '$type.styleFrom'},
  props: _buttonProps('style'),
);

WidgetDefinition _titled(String type, List<PropSchema> props) =>
    simpleDefinition(
      type: type,
      category: inputCategory,
      fixedArguments: _onChanged,
      forbiddenParents: unboundedWidthParents,
      autoWrap: expandInRow,
      requiredAncestors: materialAncestors,
      props: [
        textProp('title', defaultValue: 'Title'),
        ...props,
      ],
    );

final List<WidgetDefinition> buttonDefinitions = [
  _button('ElevatedButton'),
  _button('FilledButton'),
  _button('OutlinedButton'),
  _button('TextButton'),
  simpleDefinition(
    type: 'IconButton',
    category: buttonsCategory,
    fixedArguments: _onPressed,
    requiredAncestors: materialAncestors,
    props: [
      iconProp('icon', defaultValue: 'add'),
      numberProp('iconSize', defaultValue: 24.0),
      colorProp('color'),
      insetsProp('padding'),
      stringProp('tooltip'),
    ],
  ),
];

final List<WidgetDefinition> inputDefinitions = [
  simpleDefinition(
    type: 'TextField',
    autoWrap: expandInRow,
    category: inputCategory,
    forbiddenParents: unboundedWidthParents,
    requiredAncestors: materialAncestors,
    groups: const {'decoration': 'InputDecoration'},
    props: [
      stringProp('labelText', group: 'decoration'),
      stringProp('hintText', group: 'decoration'),
      stringProp('helperText', group: 'decoration'),
      stringProp('errorText', group: 'decoration'),
      iconProp('prefixIcon', group: 'decoration'),
      iconProp('suffixIcon', group: 'decoration'),
      boolProp('filled', defaultValue: false, group: 'decoration'),
      colorProp('fillColor', group: 'decoration'),
      choiceProp(
        'border',
        inputBorderOptions,
        group: 'decoration',
        literals: inputBorderLiterals,
      ),
      choiceProp(
        'keyboardType',
        keyboardTypeOptions,
        enumType: 'TextInputType',
      ),
      choiceProp('textAlign', textAlignOptions, enumType: 'TextAlign'),
      boolProp('obscureText', defaultValue: false),
      numberProp('maxLines', defaultValue: 1, integer: true),
      numberProp('minLines', integer: true),
      numberProp('maxLength', integer: true),
      boolProp('enabled', defaultValue: true),
      boolProp('readOnly', defaultValue: false),
    ],
  ),
  simpleDefinition(
    type: 'Checkbox',
    category: inputCategory,
    fixedArguments: _onChanged,
    requiredAncestors: materialAncestors,
    props: [_value, colorProp('activeColor'), colorProp('checkColor')],
  ),
  simpleDefinition(
    type: 'Switch',
    category: inputCategory,
    fixedArguments: _onChanged,
    requiredAncestors: materialAncestors,
    props: [
      _value,
      colorProp('activeThumbColor'),
      colorProp('activeTrackColor'),
      colorProp('inactiveThumbColor'),
      colorProp('inactiveTrackColor'),
    ],
  ),
  simpleDefinition(
    type: 'Slider',
    autoWrap: expandInRow,
    category: inputCategory,
    fixedArguments: _onChanged,
    forbiddenParents: unboundedWidthParents,
    requiredAncestors: materialAncestors,
    props: [
      numberProp('value', defaultValue: 0.5, alwaysEmit: true),
      numberProp('min', defaultValue: 0.0),
      numberProp('max', defaultValue: 1.0),
      numberProp('divisions', integer: true),
      stringProp('label'),
      colorProp('activeColor'),
      colorProp('inactiveColor'),
    ],
  ),
  _titled('CheckboxListTile', [
    textProp('subtitle'),
    _value,
    colorProp('activeColor'),
    boolProp('dense'),
    choiceProp(
      'controlAffinity',
      controlAffinityOptions,
      enumType: 'ListTileControlAffinity',
    ),
  ]),
  _titled('SwitchListTile', [
    textProp('subtitle'),
    _value,
    colorProp('activeThumbColor'),
    boolProp('dense'),
    choiceProp(
      'controlAffinity',
      controlAffinityOptions,
      enumType: 'ListTileControlAffinity',
    ),
  ]),
];
