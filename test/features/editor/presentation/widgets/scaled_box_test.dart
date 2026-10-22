import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/scaled_box.dart';

void main() {
  Widget scaled(double scale, VoidCallback onTap) => Directionality(
    textDirection: TextDirection.ltr,
    child: Align(
      alignment: Alignment.topLeft,
      child: ScaledBox(
        scale: scale,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: const SizedBox(width: 100, height: 200),
        ),
      ),
    ),
  );

  testWidgets('takes the scaled size in the layout', (tester) async {
    await tester.pumpWidget(scaled(0.5, () {}));

    expect(tester.getSize(find.byType(ScaledBox)), const Size(50, 100));
  });

  testWidgets('pointer events reach the child where it is drawn', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(scaled(0.5, () => taps++));

    // Inside the scaled box, but outside the child's unscaled size on screen.
    await tester.tapAt(const Offset(40, 90));
    expect(taps, 1);

    // Outside the scaled box: the child's unscaled corner is not drawn there.
    await tester.tapAt(const Offset(80, 150));
    expect(taps, 1);
  });

  testWidgets('a global point maps back to the unscaled child', (tester) async {
    await tester.pumpWidget(scaled(0.5, () {}));
    final box = tester.renderObject<RenderBox>(find.byType(SizedBox).last);

    expect(box.globalToLocal(const Offset(25, 50)), const Offset(50, 100));
  });

  testWidgets('a larger scale grows the layout', (tester) async {
    await tester.pumpWidget(scaled(2, () {}));

    expect(tester.getSize(find.byType(ScaledBox)), const Size(200, 400));
  });
}
