import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_builder.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_helpers.dart';

/// Previews of the layout widgets beyond Container, Row, Column and Stack.
final Map<String, PreviewBuilder> layoutPreviews = {
  'Center': (context, props, children) => Center(
    widthFactor: props.number('widthFactor'),
    heightFactor: props.number('heightFactor'),
    child: firstChild(children),
  ),
  'Align': (context, props, children) => Align(
    alignment: alignmentOf(props, 'alignment') ?? Alignment.center,
    widthFactor: props.number('widthFactor'),
    heightFactor: props.number('heightFactor'),
    child: firstChild(children),
  ),
  'SizedBox': (context, props, children) => SizedBox(
    width: props.number('width'),
    height: props.number('height'),
    child: firstChild(children),
  ),
  'FractionallySizedBox': _fractionallySizedBox,
  'AspectRatio': (context, props, children) => AspectRatio(
    aspectRatio: props.requiredNumber('aspectRatio'),
    child: firstChild(children),
  ),
  'FittedBox': (context, props, children) => FittedBox(
    fit: enumOf(BoxFit.values, props, 'fit') ?? BoxFit.contain,
    alignment: alignmentOf(props, 'alignment') ?? Alignment.center,
    child: firstChild(children),
  ),
  'SafeArea': (context, props, children) => SafeArea(
    left: props.boolean('left') ?? true,
    top: props.boolean('top') ?? true,
    right: props.boolean('right') ?? true,
    bottom: props.boolean('bottom') ?? true,
    child: requiredChild(children),
  ),
  'IntrinsicHeight': (context, props, children) =>
      IntrinsicHeight(child: firstChild(children)),
  'IntrinsicWidth': (context, props, children) =>
      IntrinsicWidth(child: firstChild(children)),
  'Wrap': (context, props, children) => Wrap(
    direction: enumOf(Axis.values, props, 'direction') ?? Axis.horizontal,
    alignment:
        enumOf(WrapAlignment.values, props, 'alignment') ?? WrapAlignment.start,
    crossAxisAlignment:
        enumOf(WrapCrossAlignment.values, props, 'crossAxisAlignment') ??
        WrapCrossAlignment.start,
    spacing: props.requiredNumber('spacing'),
    runSpacing: props.requiredNumber('runSpacing'),
    children: children.widgets,
  ),
  // The three below sit directly under a Row or Column. The registry hands
  // them their already wrapped child so the parent data stays on top.
  'Expanded': (context, props, children) => Expanded(
    flex: props.requiredNumber('flex').round(),
    child: requiredChild(children),
  ),
  'Flexible': (context, props, children) => Flexible(
    flex: props.requiredNumber('flex').round(),
    fit: enumOf(FlexFit.values, props, 'fit') ?? FlexFit.loose,
    child: requiredChild(children),
  ),
  'Spacer': (context, props, children) => Expanded(
    flex: props.requiredNumber('flex').round(),
    child: requiredChild(children),
  ),
  'Positioned': _positioned,
};

// Positioned asserts that at most two of left, right and width are set, and
// the same for top, bottom and height, so the extent yields to the edges.
Widget _positioned(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) {
  final left = props.number('left');
  final right = props.number('right');
  final top = props.number('top');
  final bottom = props.number('bottom');
  return Positioned(
    left: left,
    top: top,
    right: right,
    bottom: bottom,
    width: left != null && right != null ? null : props.number('width'),
    height: top != null && bottom != null ? null : props.number('height'),
    child: requiredChild(children),
  );
}

// A fraction of an unbounded extent is unbounded, which the canvas does for
// height, so a factor only applies along a bounded axis.
Widget _fractionallySizedBox(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) => LayoutBuilder(
  builder: (context, constraints) => FractionallySizedBox(
    alignment: alignmentOf(props, 'alignment') ?? Alignment.center,
    widthFactor: constraints.hasBoundedWidth
        ? props.number('widthFactor')
        : null,
    heightFactor: constraints.hasBoundedHeight
        ? props.number('heightFactor')
        : null,
    child: firstChild(children),
  ),
);
