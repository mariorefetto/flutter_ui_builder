import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_builder.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_helpers.dart';

void _noop() {}

Clip _clip(NodeProps props) =>
    enumOf(Clip.values, props, 'clipBehavior') ?? Clip.antiAlias;

Alignment _alignment(NodeProps props) =>
    alignmentOf(props, 'alignment') ?? Alignment.center;

/// Previews of the painting, animation, interaction and accessibility
/// widgets. Implicit animations are shown at their current values.
final Map<String, PreviewBuilder> effectPreviews = {
  'Opacity': (context, props, children) => Opacity(
    opacity: props.requiredNumber('opacity').clamp(0.0, 1.0),
    child: firstChild(children),
  ),
  'ClipRRect': (context, props, children) => ClipRRect(
    borderRadius: radiusOf(props, 'borderRadius') ?? BorderRadius.zero,
    clipBehavior: _clip(props),
    child: firstChild(children),
  ),
  'ClipOval': (context, props, children) =>
      ClipOval(clipBehavior: _clip(props), child: firstChild(children)),
  'DecoratedBox': _decoratedBox,
  'Theme': (context, props, children) => Theme(
    data: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorOf(props, 'seedColor') ?? context.colorScheme.primary,
        brightness:
            enumOf(Brightness.values, props, 'brightness') ?? Brightness.light,
      ),
    ),
    child: requiredChild(children),
  ),
  'ColoredBox': (context, props, children) => ColoredBox(
    color: colorOf(props, 'color') ?? context.colorScheme.surface,
    child: requiredChild(children),
  ),
  'RotatedBox': (context, props, children) => RotatedBox(
    quarterTurns: props.requiredNumber('quarterTurns').round(),
    child: firstChild(children),
  ),
  'TransformRotate': (context, props, children) => Transform.rotate(
    angle: props.requiredNumber('angle'),
    alignment: _alignment(props),
    child: firstChild(children),
  ),
  'TransformScale': (context, props, children) => Transform.scale(
    scale: props.requiredNumber('scale'),
    alignment: _alignment(props),
    child: firstChild(children),
  ),
  'Visibility': (context, props, children) => Visibility(
    visible: props.boolean('visible') ?? true,
    maintainState: props.boolean('maintainState') ?? false,
    child: requiredChild(children),
  ),
  'AnimatedContainer': (context, props, children) => AnimatedContainer(
    duration: durationOf(props),
    curve: curveOf(props),
    width: props.number('width'),
    height: props.number('height'),
    color: colorOf(props, 'color'),
    padding: insetsOf(props, 'padding'),
    margin: insetsOf(props, 'margin'),
    alignment: alignmentOf(props, 'alignment'),
    child: firstChild(children),
  ),
  'AnimatedOpacity': (context, props, children) => AnimatedOpacity(
    duration: durationOf(props),
    curve: curveOf(props),
    opacity: props.requiredNumber('opacity').clamp(0.0, 1.0),
    child: firstChild(children),
  ),
  'AnimatedAlign': (context, props, children) => AnimatedAlign(
    duration: durationOf(props),
    curve: curveOf(props),
    alignment: _alignment(props),
    child: firstChild(children),
  ),
  'AnimatedPadding': (context, props, children) => AnimatedPadding(
    duration: durationOf(props),
    curve: curveOf(props),
    padding: insetsOf(props, 'padding') ?? EdgeInsets.zero,
    child: firstChild(children),
  ),
  'AnimatedSize': (context, props, children) => AnimatedSize(
    duration: durationOf(props),
    curve: curveOf(props),
    alignment: _alignment(props),
    child: firstChild(children),
  ),
  'AnimatedScale': (context, props, children) => AnimatedScale(
    duration: durationOf(props),
    curve: curveOf(props),
    scale: props.requiredNumber('scale'),
    alignment: _alignment(props),
    child: firstChild(children),
  ),
  'AnimatedRotation': (context, props, children) => AnimatedRotation(
    duration: durationOf(props),
    curve: curveOf(props),
    turns: props.requiredNumber('turns'),
    alignment: _alignment(props),
    child: firstChild(children),
  ),
  'AnimatedSwitcher': (context, props, children) => AnimatedSwitcher(
    duration: durationOf(props),
    child: firstChild(children),
  ),
  'GestureDetector': (context, props, children) => GestureDetector(
    onTap: _noop,
    behavior: enumOf(HitTestBehavior.values, props, 'behavior'),
    child: requiredChild(children),
  ),
  'InkWell': (context, props, children) => InkWell(
    onTap: _noop,
    borderRadius: radiusOf(props, 'borderRadius'),
    splashColor: colorOf(props, 'splashColor'),
    hoverColor: colorOf(props, 'hoverColor'),
    highlightColor: colorOf(props, 'highlightColor'),
    child: requiredChild(children),
  ),
  'IgnorePointer': (context, props, children) => IgnorePointer(
    ignoring: props.boolean('ignoring') ?? true,
    child: requiredChild(children),
  ),
  'Tooltip': (context, props, children) => Tooltip(
    message: props.requiredString('message'),
    preferBelow: props.boolean('preferBelow') ?? true,
    verticalOffset: props.number('verticalOffset'),
    child: requiredChild(children),
  ),
  'Semantics': (context, props, children) => Semantics(
    label: props.string('label'),
    hint: props.string('hint'),
    value: props.string('value'),
    button: props.boolean('button'),
    header: props.boolean('header'),
    excludeSemantics: props.boolean('excludeSemantics') ?? false,
    child: requiredChild(children),
  ),
  'ExcludeSemantics': (context, props, children) => ExcludeSemantics(
    excluding: props.boolean('excluding') ?? true,
    child: requiredChild(children),
  ),
  'MergeSemantics': (context, props, children) =>
      MergeSemantics(child: requiredChild(children)),
};

Widget _decoratedBox(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) => DecoratedBox(
  position:
      enumOf(DecorationPosition.values, props, 'position') ??
      DecorationPosition.background,
  decoration:
      decorationOf(props, shape: props.choice('shape')) ??
      const BoxDecoration(),
  child: firstChild(children),
);
