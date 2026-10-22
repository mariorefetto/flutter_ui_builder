import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';

/// Bar between two panels that is dragged to resize them. A vertical bar sits
/// between panels side by side, a horizontal one between panels stacked.
class Splitter extends StatelessWidget {
  const Splitter({required this.onDrag, this.axis = Axis.vertical, super.key});

  /// Called with the distance the pointer moved across the bar: horizontal
  /// for a vertical bar, vertical for a horizontal one.
  final ValueChanged<double> onDrag;

  /// The direction the bar itself runs in.
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final vertical = axis == Axis.vertical;
    final bar = ColoredBox(color: context.colorScheme.outlineVariant);
    return MouseRegion(
      cursor: vertical
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: vertical
            ? (details) => onDrag(details.delta.dx)
            : null,
        onVerticalDragUpdate: vertical
            ? null
            : (details) => onDrag(details.delta.dy),
        child: SizedBox(
          width: vertical ? AppConstants.spacingXS : null,
          height: vertical ? null : AppConstants.spacingXS,
          child: bar,
        ),
      ),
    );
  }
}
