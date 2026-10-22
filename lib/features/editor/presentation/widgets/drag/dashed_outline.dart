import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';

const double _dashLength = 6;
const double _gapLength = 4;

/// A dashed rectangle drawn over its child, without taking clicks or space.
/// It marks the widget being moved.
class DashedOutline extends StatelessWidget {
  const DashedOutline({required this.color, required this.child, super.key});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(foregroundPainter: _DashedPainter(color), child: child);
  }
}

class _DashedPainter extends CustomPainter {
  const _DashedPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppConstants.borderWidthMedium;
    final path = Path()..addRect(Offset.zero & size);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + _dashLength),
          paint,
        );
        distance += _dashLength + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedPainter oldDelegate) => oldDelegate.color != color;
}
