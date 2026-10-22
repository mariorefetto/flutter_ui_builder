import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_builder.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_helpers.dart';

/// Previews of the information widgets and of the scrolling widgets.
final Map<String, PreviewBuilder> informationPreviews = {
  'Card': (context, props, children) => Card(
    elevation: props.number('elevation'),
    color: colorOf(props, 'color'),
    shadowColor: colorOf(props, 'shadowColor'),
    margin: insetsOf(props, 'margin'),
    shape: shapeOf(props, 'borderRadius'),
    clipBehavior: enumOf(Clip.values, props, 'clipBehavior'),
    child: firstChild(children),
  ),
  'ListTile': (context, props, children) {
    final subtitle = textOf(props, 'subtitle');
    return inert(
      ListTile(
        title: textOf(props, 'title'),
        subtitle: subtitle,
        leading: iconWidget(props, 'leading'),
        trailing: iconWidget(props, 'trailing'),
        dense: props.boolean('dense'),
        // A three line tile asserts that it has a subtitle.
        isThreeLine:
            subtitle != null && (props.boolean('isThreeLine') ?? false),
        selected: props.boolean('selected') ?? false,
        enabled: props.boolean('enabled') ?? true,
        tileColor: colorOf(props, 'tileColor'),
        iconColor: colorOf(props, 'iconColor'),
        textColor: colorOf(props, 'textColor'),
        contentPadding: insetsOf(props, 'contentPadding'),
      ),
    );
  },
  'Divider': (context, props, children) => Divider(
    height: props.number('height'),
    thickness: props.number('thickness'),
    indent: props.number('indent'),
    endIndent: props.number('endIndent'),
    color: colorOf(props, 'color'),
  ),
  'VerticalDivider': (context, props, children) => ConstrainedBox(
    constraints: dividerPreviewConstraints,
    child: VerticalDivider(
      width: props.number('width'),
      thickness: props.number('thickness'),
      indent: props.number('indent'),
      endIndent: props.number('endIndent'),
      color: colorOf(props, 'color'),
    ),
  ),
  'CircleAvatar': _circleAvatar,
  'Chip': (context, props, children) => Chip(
    label: Text(props.requiredString('label')),
    avatar: iconWidget(props, 'avatar'),
    backgroundColor: colorOf(props, 'backgroundColor'),
    elevation: props.number('elevation'),
  ),
  'Badge': (context, props, children) => Badge(
    label: textOf(props, 'label'),
    backgroundColor: colorOf(props, 'backgroundColor'),
    textColor: colorOf(props, 'textColor'),
    isLabelVisible: props.boolean('isLabelVisible') ?? true,
    child: firstChild(children),
  ),
  'LinearProgressIndicator': (context, props, children) =>
      LinearProgressIndicator(
        value: props.number('value'),
        color: colorOf(props, 'color'),
        backgroundColor: colorOf(props, 'backgroundColor'),
        minHeight: props.number('minHeight'),
        semanticsLabel: props.string('semanticsLabel'),
      ),
  'CircularProgressIndicator': (context, props, children) =>
      CircularProgressIndicator(
        value: props.number('value'),
        strokeWidth: props.requiredNumber('strokeWidth'),
        color: colorOf(props, 'color'),
        backgroundColor: colorOf(props, 'backgroundColor'),
        semanticsLabel: props.string('semanticsLabel'),
      ),
  'Placeholder': (context, props, children) => Placeholder(
    color: colorOf(props, 'color') ?? context.colorScheme.outline,
    strokeWidth: props.requiredNumber('strokeWidth'),
    fallbackWidth: props.requiredNumber('fallbackWidth'),
    fallbackHeight: props.requiredNumber('fallbackHeight'),
  ),
  // The canvas scrolls as a whole, so the lists size themselves to their
  // content and do not scroll on their own.
  'ListView': (context, props, children) => ListView(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: insetsOf(props, 'padding'),
    reverse: props.boolean('reverse') ?? false,
    itemExtent: props.number('itemExtent'),
    children: children.widgets,
  ),
  'GridView': (context, props, children) => GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: props.requiredNumber('crossAxisCount').round(),
    mainAxisSpacing: props.requiredNumber('mainAxisSpacing'),
    crossAxisSpacing: props.requiredNumber('crossAxisSpacing'),
    childAspectRatio: props.requiredNumber('childAspectRatio'),
    padding: insetsOf(props, 'padding'),
    reverse: props.boolean('reverse') ?? false,
    children: children.widgets,
  ),
  'SingleChildScrollView': (context, props, children) => SingleChildScrollView(
    physics: const NeverScrollableScrollPhysics(),
    padding: insetsOf(props, 'padding'),
    reverse: props.boolean('reverse') ?? false,
    scrollDirection:
        enumOf(Axis.values, props, 'scrollDirection') ?? Axis.vertical,
    child: firstChild(children),
  ),
};

// CircleAvatar asserts that radius excludes minRadius and maxRadius.
Widget _circleAvatar(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) {
  final radius = props.number('radius');
  return CircleAvatar(
    radius: radius,
    minRadius: radius == null ? props.number('minRadius') : null,
    maxRadius: radius == null ? props.number('maxRadius') : null,
    backgroundColor: colorOf(props, 'backgroundColor'),
    foregroundColor: colorOf(props, 'foregroundColor'),
    child: firstChild(children),
  );
}
