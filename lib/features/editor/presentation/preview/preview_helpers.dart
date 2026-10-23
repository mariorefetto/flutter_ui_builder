import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/decoration_code.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/icon_table.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_builder.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_values.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/prototype_scope.dart';

/// FontWeight constants addressable by the names in fontWeightOptions.
const Map<String, FontWeight> fontWeightsByName = {
  'w300': FontWeight.w300,
  'normal': FontWeight.normal,
  'w500': FontWeight.w500,
  'w600': FontWeight.w600,
  'bold': FontWeight.bold,
  'w800': FontWeight.w800,
};

Color? colorOf(NodeProps props, String name) =>
    props.color(name).let(Color.new);

EdgeInsets? insetsOf(NodeProps props, String name) =>
    props.edgeInsets(name)?.toEdgeInsets();

Alignment? alignmentOf(NodeProps props, String name) =>
    alignmentsByName[props.choice(name)];

IconData? iconOf(NodeProps props, String name) =>
    iconsByName[props.choice(name)];

/// Reads the choice [name] as a member of the enum with [values].
T? enumOf<T extends Enum>(List<T> values, NodeProps props, String name) =>
    props.choice(name).let(values.byName);

Duration durationOf(NodeProps props) =>
    Duration(milliseconds: props.requiredNumber('duration').round());

/// The preview of the first child, or null when there is none.
Widget? firstChild(List<PreviewChild> children) => children.firstOrNull?.widget;

/// The first child, or an empty box for widgets whose child is required.
Widget requiredChild(List<PreviewChild> children) =>
    firstChild(children) ?? const SizedBox.shrink();

/// Keeps a control from reacting to the pointer, so a tap on it selects the
/// node on the canvas instead of pressing the control, except in prototype
/// mode.
Widget inert(Widget child) => Inert(child: child);

/// Text node used for properties such as a title or a label.
Widget? textOf(NodeProps props, String name) =>
    props.string(name).let(Text.new);

/// Upper bound for a vertical divider, which would otherwise be unbounded in
/// the scrolling canvas.
BoxConstraints get dividerPreviewConstraints =>
    const BoxConstraints(maxHeight: AppConstants.spacingXXL);

/// Curves addressable by the names in curveOptions.
const Map<String, Curve> curvesByName = {
  'linear': Curves.linear,
  'ease': Curves.ease,
  'easeIn': Curves.easeIn,
  'easeOut': Curves.easeOut,
  'easeInOut': Curves.easeInOut,
  'fastOutSlowIn': Curves.fastOutSlowIn,
  'decelerate': Curves.decelerate,
  'bounceOut': Curves.bounceOut,
  'elasticOut': Curves.elasticOut,
};

/// TextDecoration constants addressable by the names in textDecorationOptions.
const Map<String, TextDecoration> textDecorationsByName = {
  'underline': TextDecoration.underline,
  'lineThrough': TextDecoration.lineThrough,
  'overline': TextDecoration.overline,
};

/// TextInputType constants addressable by the names in keyboardTypeOptions.
const Map<String, TextInputType> keyboardTypesByName = {
  'text': TextInputType.text,
  'number': TextInputType.number,
  'emailAddress': TextInputType.emailAddress,
  'phone': TextInputType.phone,
  'multiline': TextInputType.multiline,
  'url': TextInputType.url,
  'visiblePassword': TextInputType.visiblePassword,
  'name': TextInputType.name,
  'streetAddress': TextInputType.streetAddress,
  'datetime': TextInputType.datetime,
};

Curve curveOf(NodeProps props) =>
    curvesByName[props.choice('curve')] ?? Curves.linear;

BorderRadius? radiusOf(NodeProps props, String name) =>
    props.number(name).let(BorderRadius.circular);

/// A rounded rectangle for the `shape` of buttons and cards.
RoundedRectangleBorder? shapeOf(NodeProps props, String name) => radiusOf(
  props,
  name,
).let((radius) => RoundedRectangleBorder(borderRadius: radius));

/// An Icon widget for the icon property [name], or null when it is not set.
Widget? iconWidget(NodeProps props, String name) =>
    iconOf(props, name).let(Icon.new);

/// An inert IconButton, as the title bar and cards show them.
Widget? iconButtonOf(NodeProps props, String name) => iconOf(
  props,
  name,
).let((data) => IconButton(onPressed: () {}, icon: Icon(data)));

/// The BoxDecoration the decoration properties of [props] describe, or null
/// when none is set. The mirror of boxDecorationCode in the domain.
BoxDecoration? decorationOf(NodeProps props, {String? shape}) {
  final decoration = BoxDecoration(
    color: colorOf(props, 'color'),
    gradient: _gradientOf(props),
    // A circle has no corners, and Flutter rejects a radius on one.
    borderRadius: shape == 'circle' ? null : _radiusOf(props),
    border: _borderOf(props),
    boxShadow: _shadowOf(props),
    shape: shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
  );
  final isEmpty =
      decoration.color == null &&
      decoration.gradient == null &&
      decoration.borderRadius == null &&
      decoration.border == null &&
      decoration.boxShadow == null &&
      decoration.shape == BoxShape.rectangle;
  return isEmpty ? null : decoration;
}

Gradient? _gradientOf(NodeProps props) {
  final start = colorOf(props, 'gradientStart');
  final end = colorOf(props, 'gradientEnd');
  if (start == null && end == null) return null;
  final direction =
      gradientDirections[props.choice('gradientDirection')] ??
      gradientDirections['topToBottom']!;
  return LinearGradient(
    begin: alignmentsByName[direction.begin] ?? Alignment.topCenter,
    end: alignmentsByName[direction.end] ?? Alignment.bottomCenter,
    colors: [(start ?? end)!, (end ?? start)!],
  );
}

BorderRadius? _radiusOf(NodeProps props) {
  final all = props.number('borderRadius');
  double? corner(String name) => props.number('radius$name');
  final corners = [
    corner('TopLeft'),
    corner('TopRight'),
    corner('BottomLeft'),
    corner('BottomRight'),
  ];
  if (corners.every((c) => c == null)) return all.let(BorderRadius.circular);
  Radius radius(double? value) => Radius.circular(value ?? all ?? 0);
  return BorderRadius.only(
    topLeft: radius(corners[0]),
    topRight: radius(corners[1]),
    bottomLeft: radius(corners[2]),
    bottomRight: radius(corners[3]),
  );
}

Border? _borderOf(NodeProps props) {
  final color = colorOf(props, 'borderColor');
  final width = props.number('borderWidth');
  double? side(String name) => props.number('border${name}Width');
  final sides = [side('Left'), side('Top'), side('Right'), side('Bottom')];
  BorderSide borderSide(double? w) => w == null
      ? BorderSide.none
      : color == null
      ? BorderSide(width: w)
      : BorderSide(color: color, width: w);
  if (sides.every((s) => s == null)) {
    if (color == null && width == null) return null;
    return Border.fromBorderSide(
      color == null
          ? BorderSide(width: width ?? 1)
          : BorderSide(color: color, width: width ?? 1),
    );
  }
  return Border(
    left: borderSide(sides[0] ?? width),
    top: borderSide(sides[1] ?? width),
    right: borderSide(sides[2] ?? width),
    bottom: borderSide(sides[3] ?? width),
  );
}

List<BoxShadow>? _shadowOf(NodeProps props) {
  final color = colorOf(props, 'shadowColor');
  final blur = props.number('shadowBlur');
  final spread = props.number('shadowSpread');
  final x = props.number('shadowOffsetX');
  final y = props.number('shadowOffsetY');
  if ([color, blur, spread, x, y].every((v) => v == null)) return null;
  return [
    BoxShadow(
      color: color ?? const Color(0xFF000000),
      blurRadius: blur ?? 0,
      spreadRadius: spread ?? 0,
      offset: Offset(x ?? 0, y ?? 0),
    ),
  ];
}
