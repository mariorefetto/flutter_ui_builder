import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';

/// Vertical bar between two panels that is dragged to resize them.
class Splitter extends StatelessWidget {
  const Splitter({required this.onDrag, super.key});

  /// Called with the horizontal distance the pointer moved.
  final ValueChanged<double> onDrag;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (details) => onDrag(details.delta.dx),
        child: SizedBox(
          width: AppConstants.spacingXS,
          child: ColoredBox(color: context.colorScheme.outlineVariant),
        ),
      ),
    );
  }
}
