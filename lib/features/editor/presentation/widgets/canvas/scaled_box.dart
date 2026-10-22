import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Draws its child scaled by [scale] and takes the scaled size in the layout,
/// so a scroll view around it scrolls over exactly what is shown. Pointer
/// events are mapped back, so selecting and dropping work on the scaled child.
class ScaledBox extends SingleChildRenderObjectWidget {
  const ScaledBox({required this.scale, required super.child, super.key});

  final double scale;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderScaledBox(scale);

  @override
  void updateRenderObject(BuildContext context, _RenderScaledBox renderObject) {
    renderObject.scale = scale;
  }
}

class _RenderScaledBox extends RenderProxyBox {
  _RenderScaledBox(this._scale);

  double _scale;

  set scale(double value) {
    if (value == _scale) return;
    _scale = value;
    markNeedsLayout();
  }

  Matrix4 get _transform => Matrix4.diagonal3Values(_scale, _scale, 1);

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    // The child lays out at its own size; only the result is scaled.
    child.layout(
      BoxConstraints(
        maxWidth: constraints.hasBoundedWidth
            ? constraints.maxWidth / _scale
            : double.infinity,
      ),
      parentUsesSize: true,
    );
    size = constraints.constrain(child.size * _scale);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child == null) return;
    layer = context.pushTransform(
      needsCompositing,
      offset,
      _transform,
      super.paint,
      oldLayer: layer as TransformLayer?,
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(_transform);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final child = this.child;
    if (child == null) return false;
    return result.addWithPaintTransform(
      transform: _transform,
      position: position,
      hitTest: (result, position) => child.hitTest(result, position: position),
    );
  }
}
