import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/color_contrast.dart';

void main() {
  const black = 0xFF000000;
  const white = 0xFFFFFFFF;

  test('black on white is the strongest contrast, 21 to 1', () {
    expect(contrastRatio(black, white), closeTo(21, 0.001));
    expect(contrastRatio(white, black), closeTo(21, 0.001));
  });

  test('a color against itself has no contrast', () {
    expect(contrastRatio(0xFF2196F3, 0xFF2196F3), closeTo(1, 0.001));
  });

  test('known pairs fall on the right side of the WCAG threshold', () {
    // #767676 is the lightest grey that passes on white; one step up fails.
    expect(contrastRatio(0xFF767676, white), greaterThan(minimumTextContrast));
    expect(contrastRatio(0xFF777777, white), lessThan(minimumTextContrast));
  });

  test('luminance runs from 0 for black to 1 for white', () {
    expect(relativeLuminance(black), 0);
    expect(relativeLuminance(white), closeTo(1, 0.001));
  });
}
