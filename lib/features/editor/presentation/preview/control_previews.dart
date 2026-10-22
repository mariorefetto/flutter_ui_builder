import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_builder.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_helpers.dart';

void _noop() {}

void _noopChanged(Object? value) {}

typedef _StyleFrom =
    ButtonStyle Function({
      Color? backgroundColor,
      Color? foregroundColor,
      EdgeInsetsGeometry? padding,
      double? elevation,
      OutlinedBorder? shape,
    });

PreviewBuilder _button(
  Widget Function(ButtonStyle style, Widget child) create,
  _StyleFrom styleFrom,
) => (context, props, children) {
  final style = styleFrom(
    backgroundColor: colorOf(props, 'backgroundColor'),
    foregroundColor: colorOf(props, 'foregroundColor'),
    padding: insetsOf(props, 'padding'),
    elevation: props.number('elevation'),
    shape: shapeOf(props, 'borderRadius'),
  );
  return inert(create(style, requiredChild(children)));
};

/// Previews of the buttons and of the input controls.
final Map<String, PreviewBuilder> controlPreviews = {
  'ElevatedButton': _button(
    (style, child) =>
        ElevatedButton(onPressed: _noop, style: style, child: child),
    ElevatedButton.styleFrom,
  ),
  'FilledButton': _button(
    (style, child) =>
        FilledButton(onPressed: _noop, style: style, child: child),
    FilledButton.styleFrom,
  ),
  'OutlinedButton': _button(
    (style, child) =>
        OutlinedButton(onPressed: _noop, style: style, child: child),
    OutlinedButton.styleFrom,
  ),
  'TextButton': _button(
    (style, child) => TextButton(onPressed: _noop, style: style, child: child),
    TextButton.styleFrom,
  ),
  'IconButton': (context, props, children) => inert(
    IconButton(
      onPressed: _noop,
      icon: Icon(iconOf(props, 'icon')),
      iconSize: props.requiredNumber('iconSize'),
      color: colorOf(props, 'color'),
      padding: insetsOf(props, 'padding'),
      tooltip: props.string('tooltip'),
    ),
  ),
  'TextField': _textField,
  'Checkbox': (context, props, children) => inert(
    Checkbox(
      value: props.boolean('value') ?? false,
      activeColor: colorOf(props, 'activeColor'),
      checkColor: colorOf(props, 'checkColor'),
      onChanged: _noopChanged,
    ),
  ),
  'Switch': (context, props, children) => inert(
    Switch(
      value: props.boolean('value') ?? false,
      activeThumbColor: colorOf(props, 'activeThumbColor'),
      activeTrackColor: colorOf(props, 'activeTrackColor'),
      inactiveThumbColor: colorOf(props, 'inactiveThumbColor'),
      inactiveTrackColor: colorOf(props, 'inactiveTrackColor'),
      onChanged: _noopChanged,
    ),
  ),
  'Slider': _slider,
  'CheckboxListTile': (context, props, children) => inert(
    CheckboxListTile(
      title: textOf(props, 'title'),
      subtitle: textOf(props, 'subtitle'),
      value: props.boolean('value') ?? false,
      activeColor: colorOf(props, 'activeColor'),
      dense: props.boolean('dense'),
      controlAffinity: enumOf(
        ListTileControlAffinity.values,
        props,
        'controlAffinity',
      ),
      onChanged: _noopChanged,
    ),
  ),
  'SwitchListTile': (context, props, children) => inert(
    SwitchListTile(
      title: textOf(props, 'title'),
      subtitle: textOf(props, 'subtitle'),
      value: props.boolean('value') ?? false,
      activeThumbColor: colorOf(props, 'activeThumbColor'),
      dense: props.boolean('dense'),
      controlAffinity: enumOf(
        ListTileControlAffinity.values,
        props,
        'controlAffinity',
      ),
      onChanged: _noopChanged,
    ),
  ),
};

Widget _textField(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) {
  final obscure = props.boolean('obscureText') ?? false;
  final multiline = !obscure;
  final maxLines = props.requiredNumber('maxLines').round();
  final minLines = props.number('minLines')?.round();
  return inert(
    TextField(
      decoration: InputDecoration(
        labelText: props.string('labelText'),
        hintText: props.string('hintText'),
        helperText: props.string('helperText'),
        errorText: props.string('errorText'),
        prefixIcon: iconWidget(props, 'prefixIcon'),
        suffixIcon: iconWidget(props, 'suffixIcon'),
        filled: props.boolean('filled'),
        fillColor: colorOf(props, 'fillColor'),
        border: switch (props.choice('border')) {
          'outline' => const OutlineInputBorder(),
          'underline' => const UnderlineInputBorder(),
          _ => null,
        },
      ),
      keyboardType: keyboardTypesByName[props.choice('keyboardType')],
      textAlign:
          enumOf(TextAlign.values, props, 'textAlign') ?? TextAlign.start,
      obscureText: obscure,
      // A hidden text field has one line, and minLines may not exceed maxLines.
      maxLines: multiline ? maxLines : 1,
      minLines: multiline && minLines != null
          ? math.min(minLines, maxLines)
          : null,
      maxLength: props.number('maxLength')?.round(),
      enabled: props.boolean('enabled') ?? true,
      readOnly: props.boolean('readOnly') ?? false,
    ),
  );
}

Widget _slider(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) {
  final min = props.requiredNumber('min');
  // Slider asserts that min < max and min <= value <= max.
  final max = math.max(props.requiredNumber('max'), min + 1);
  final divisions = props.number('divisions')?.round();
  return inert(
    Slider(
      value: props.requiredNumber('value').clamp(min, max),
      min: min,
      max: max,
      divisions: divisions != null && divisions > 0 ? divisions : null,
      label: props.string('label'),
      activeColor: colorOf(props, 'activeColor'),
      inactiveColor: colorOf(props, 'inactiveColor'),
      onChanged: _noopChanged,
    ),
  );
}
