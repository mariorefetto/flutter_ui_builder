import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_builders.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

/// Directions a two color gradient can run, as the begin and end alignments
/// of the LinearGradient it becomes.
const Map<String, ({String begin, String end})> gradientDirections = {
  'topToBottom': (begin: 'topCenter', end: 'bottomCenter'),
  'leftToRight': (begin: 'centerLeft', end: 'centerRight'),
  'topLeftToBottomRight': (begin: 'topLeft', end: 'bottomRight'),
};

const List<String> _sides = ['Left', 'Top', 'Right', 'Bottom'];
const List<String> _corners = [
  'TopLeft',
  'TopRight',
  'BottomLeft',
  'BottomRight',
];

/// The properties that make up a BoxDecoration: fill, gradient, corners,
/// border and shadow. Container and DecoratedBox share them.
List<PropSchema> decorationProps() => [
  colorProp('color'),
  colorProp('gradientStart'),
  colorProp('gradientEnd'),
  choiceProp('gradientDirection', gradientDirections.keys.toList()),
  numberProp('borderRadius'),
  for (final corner in _corners) numberProp('radius$corner'),
  colorProp('borderColor'),
  numberProp('borderWidth'),
  for (final side in _sides) numberProp('border${side}Width'),
  colorProp('shadowColor'),
  numberProp('shadowBlur'),
  numberProp('shadowSpread'),
  numberProp('shadowOffsetX'),
  numberProp('shadowOffsetY'),
];

/// The `BoxDecoration(...)` for [props], or null when no decoration property
/// is set. [shape] is written when it is not the default rectangle.
String? boxDecorationCode(NodeProps props, {String? shape}) {
  final arguments = dartArguments({
    'color': props.color('color').let(dartColor),
    'gradient': _gradient(props),
    'borderRadius': _radius(props),
    'border': _border(props),
    'boxShadow': _shadow(props),
    'shape': shape == null || shape == 'rectangle' ? null : 'BoxShape.$shape',
  });
  return arguments.isEmpty ? null : 'BoxDecoration($arguments)';
}

String? _gradient(NodeProps props) {
  final start = props.color('gradientStart');
  final end = props.color('gradientEnd');
  if (start == null && end == null) return null;
  final direction =
      gradientDirections[props.choice('gradientDirection')] ??
      gradientDirections['topToBottom']!;
  final from = dartColor((start ?? end)!);
  final to = dartColor((end ?? start)!);
  return 'LinearGradient(begin: Alignment.${direction.begin}, '
      'end: Alignment.${direction.end}, colors: [$from, $to])';
}

String? _radius(NodeProps props) {
  final all = props.number('borderRadius');
  final corners = {
    for (final corner in _corners) corner: props.number('radius$corner'),
  };
  if (corners.values.every((v) => v == null)) {
    return all.let((v) => 'BorderRadius.circular(${dartDouble(v)})');
  }
  String corner(String name) =>
      'Radius.circular(${dartDouble(corners[name] ?? all ?? 0)})';
  return 'BorderRadius.only(topLeft: ${corner('TopLeft')}, '
      'topRight: ${corner('TopRight')}, bottomLeft: ${corner('BottomLeft')}, '
      'bottomRight: ${corner('BottomRight')})';
}

String? _border(NodeProps props) {
  final color = props.color('borderColor');
  final width = props.number('borderWidth');
  final sides = {
    for (final side in _sides) side: props.number('border${side}Width'),
  };
  if (sides.values.every((v) => v == null)) {
    if (color == null && width == null) return null;
    return 'Border.all(${_side(color, width)})';
  }
  final parts = [
    for (final side in _sides)
      if ((sides[side] ?? width) case final w?)
        '${side.toLowerCase()}: BorderSide(${_side(color, w)})',
  ];
  return 'Border(${parts.join(', ')})';
}

String _side(int? color, double? width) => dartArguments({
  'color': color.let(dartColor),
  'width': width.let(dartDouble),
});

String? _shadow(NodeProps props) {
  final x = props.number('shadowOffsetX');
  final y = props.number('shadowOffsetY');
  final arguments = dartArguments({
    'color': props.color('shadowColor').let(dartColor),
    'blurRadius': props.number('shadowBlur').let(dartDouble),
    'spreadRadius': props.number('shadowSpread').let(dartDouble),
    'offset': x == null && y == null
        ? null
        : 'Offset(${dartDouble(x ?? 0)}, ${dartDouble(y ?? 0)})',
  });
  return arguments.isEmpty ? null : '[BoxShadow($arguments)]';
}
