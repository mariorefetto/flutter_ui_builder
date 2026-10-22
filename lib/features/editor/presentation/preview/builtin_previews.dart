import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_dimensions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/control_previews.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/cupertino_previews.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/effect_previews.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/information_previews.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/layout_previews.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_builder.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_helpers.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/scaffold_previews.dart';

/// Widgets that must stay a direct child of their Row, Column or Stack to
/// keep their parent data. The registry applies the canvas wrapper to their
/// child instead of to the widget itself.
const Set<String> parentDataPreviewTypes = {
  'Expanded',
  'Flexible',
  'Spacer',
  'Positioned',
};

/// Previews keyed by the type of the matching WidgetDefinition.
final Map<String, PreviewBuilder> builtinPreviews = {
  'Container': _container,
  'Row': (context, props, children) => Row(
    mainAxisSize: _flexSize(props),
    mainAxisAlignment: _mainAxis(props),
    crossAxisAlignment: _crossAxis(props),
    spacing: props.requiredNumber('spacing'),
    children: children.widgets,
  ),
  'Column': (context, props, children) => Column(
    mainAxisSize: _flexSize(props),
    mainAxisAlignment: _mainAxis(props),
    crossAxisAlignment: _crossAxis(props),
    spacing: props.requiredNumber('spacing'),
    children: children.widgets,
  ),
  'Stack': _stack,
  'Padding': (context, props, children) => Padding(
    padding: insetsOf(props, 'padding') ?? EdgeInsets.zero,
    child: firstChild(children),
  ),
  'Text': _text,
  'Image': _image,
  'Icon': (context, props, children) => Icon(
    iconOf(props, 'icon'),
    size: props.requiredNumber('size'),
    color: colorOf(props, 'color'),
    semanticLabel: props.string('semanticLabel'),
  ),
  ...scaffoldPreviews,
  ...layoutPreviews,
  ...controlPreviews,
  ...informationPreviews,
  ...effectPreviews,
  ...cupertinoPreviews,
};

MainAxisSize _flexSize(NodeProps props) =>
    enumOf(MainAxisSize.values, props, 'mainAxisSize') ?? MainAxisSize.max;

MainAxisAlignment _mainAxis(NodeProps props) =>
    MainAxisAlignment.values.byName(props.requiredChoice('mainAxisAlignment'));

CrossAxisAlignment _crossAxis(NodeProps props) => CrossAxisAlignment.values
    .byName(props.requiredChoice('crossAxisAlignment'));

Widget _container(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) {
  final hasLimits = [
    'minWidth',
    'maxWidth',
    'minHeight',
    'maxHeight',
  ].any((name) => props.number(name) != null);
  return Container(
    width: props.number('width'),
    height: props.number('height'),
    decoration: decorationOf(props, shape: props.choice('shape')),
    constraints: hasLimits
        ? BoxConstraints(
            minWidth: props.number('minWidth') ?? 0,
            maxWidth: props.number('maxWidth') ?? double.infinity,
            minHeight: props.number('minHeight') ?? 0,
            maxHeight: props.number('maxHeight') ?? double.infinity,
          )
        : null,
    padding: insetsOf(props, 'padding'),
    margin: insetsOf(props, 'margin'),
    alignment: alignmentOf(props, 'alignment'),
    child: firstChild(children),
  );
}

// A Stack with only positioned children takes all the space it is offered,
// which is unbounded in the scrolling canvas, so it gets a fixed size there.
Widget _stack(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) {
  final stack = Stack(
    alignment: alignmentOf(props, 'alignment') ?? Alignment.topLeft,
    fit: enumOf(StackFit.values, props, 'fit') ?? StackFit.loose,
    clipBehavior: enumOf(Clip.values, props, 'clipBehavior') ?? Clip.hardEdge,
    children: children.widgets,
  );
  final onlyPositioned = children.every((c) => c.type == 'Positioned');
  if (!onlyPositioned) return stack;
  return LayoutBuilder(
    builder: (context, constraints) => SizedBox(
      width: constraints.hasBoundedWidth ? null : positionedStackSize,
      height: constraints.hasBoundedHeight ? null : positionedStackSize,
      child: stack,
    ),
  );
}

Widget _text(BuildContext context, NodeProps props, List<PreviewChild> _) =>
    Text(
      props.requiredString('text'),
      textAlign: enumOf(TextAlign.values, props, 'textAlign'),
      maxLines: props.number('maxLines')?.round(),
      overflow: enumOf(TextOverflow.values, props, 'overflow'),
      softWrap: props.boolean('softWrap'),
      style: TextStyle(
        fontSize: props.requiredNumber('fontSize'),
        color: colorOf(props, 'color'),
        fontFamily: props.string('fontFamily'),
        fontWeight: fontWeightsByName[props.choice('fontWeight')],
        fontStyle: props.boolean('italic') == true ? FontStyle.italic : null,
        decoration: textDecorationsByName[props.choice('decoration')],
        letterSpacing: props.number('letterSpacing'),
        height: props.number('height'),
      ),
    );

Widget _image(BuildContext context, NodeProps props, List<PreviewChild> _) {
  final path = props.requiredString('url');
  final placeholder = Icon(
    Icons.image_outlined,
    color: context.colorScheme.outline,
  );
  if (path.isEmpty) return placeholder;
  final width = props.number('width');
  final height = props.number('height');
  final fit = BoxFit.values.byName(props.requiredChoice('fit'));
  final alignment = alignmentOf(props, 'alignment') ?? Alignment.center;
  final repeat =
      enumOf(ImageRepeat.values, props, 'repeat') ?? ImageRepeat.noRepeat;
  final color = colorOf(props, 'color');
  final label = props.string('semanticLabel');
  Widget broken(BuildContext context, Object error, StackTrace? stack) =>
      placeholder;
  return switch (props.requiredChoice('source')) {
    'asset' => Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      color: color,
      semanticLabel: label,
      errorBuilder: broken,
    ),
    'file' => Image.file(
      File(path),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      color: color,
      semanticLabel: label,
      errorBuilder: broken,
    ),
    _ => Image.network(
      path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      color: color,
      semanticLabel: label,
      errorBuilder: broken,
    ),
  };
}
