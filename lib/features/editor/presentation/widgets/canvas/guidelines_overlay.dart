import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/edge_insets_value.dart';

const double _marginOpacity = 0.28;
const double _paddingOpacity = 0.28;
const double _outlineOpacity = 0.55;

/// The guidelines of a widget, drawn over it like the layout guides of the
/// Flutter inspector: the box it takes, and for the selected one its margin,
/// its padding and its size. It takes no pointer events.
class GuidelinesOverlay extends StatelessWidget {
  const GuidelinesOverlay({
    required this.selected,
    this.margin,
    this.padding,
    super.key,
  });

  /// The widget is the selected one: its spacing and size are shown.
  final bool selected;

  /// What the widget keeps free around its box, from its properties.
  final EdgeInsetsValue? margin;

  /// What it keeps free inside its box, from its properties.
  final EdgeInsetsValue? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _GuidePainter(
                  outline: colors.primary.withValues(alpha: _outlineOpacity),
                  margin: colors.tertiary.withValues(alpha: _marginOpacity),
                  padding: colors.secondary.withValues(alpha: _paddingOpacity),
                  spacing: selected ? (margin, padding) : null,
                ),
              ),
              if (selected && size.isFinite)
                Positioned(top: 0, right: 0, child: _SizeTag(size: size)),
            ],
          );
        },
      ),
    );
  }
}

/// The size of the widget, in a small tag in its corner.
class _SizeTag extends StatelessWidget {
  const _SizeTag({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radiusSM),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXS),
        child: Text(
          '${size.width.round()} x ${size.height.round()}',
          style: context.textTheme.labelSmall?.copyWith(
            color: colors.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _GuidePainter extends CustomPainter {
  const _GuidePainter({
    required this.outline,
    required this.margin,
    required this.padding,
    required this.spacing,
  });

  final Color outline;
  final Color margin;
  final Color padding;

  /// The margin and padding to colour, or null to draw only the outline.
  final (EdgeInsetsValue?, EdgeInsetsValue?)? spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final box = Offset.zero & size;
    final spacing = this.spacing;
    if (spacing != null) {
      final inner = _deflate(box, spacing.$1);
      _ring(canvas, box, inner, margin);
      _ring(canvas, inner, _deflate(inner, spacing.$2), padding);
    }
    canvas.drawRect(
      box.deflate(0.5),
      Paint()
        ..color = outline
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  Rect _deflate(Rect rect, EdgeInsetsValue? insets) => insets == null
      ? rect
      : Rect.fromLTRB(
          rect.left + insets.left,
          rect.top + insets.top,
          (rect.right - insets.right).clamp(rect.left, rect.right),
          (rect.bottom - insets.bottom).clamp(rect.top, rect.bottom),
        );

  // The band between two rectangles.
  void _ring(Canvas canvas, Rect outer, Rect inner, Color color) {
    if (outer == inner) return;
    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(outer)
        ..addRect(inner),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_GuidePainter old) =>
      old.outline != outline ||
      old.margin != margin ||
      old.padding != padding ||
      old.spacing != spacing;
}
