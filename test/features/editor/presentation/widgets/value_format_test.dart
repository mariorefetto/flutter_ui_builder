import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/value_format.dart';

void main() {
  test('formatNumber drops a zero fraction', () {
    expect(formatNumber(14), '14');
    expect(formatNumber(1.5), '1.5');
  });

  test('parseColor accepts RRGGBB and AARRGGBB', () {
    expect(parseColor('2196F3'), 0xFF2196F3);
    expect(parseColor('#802196F3'), 0x802196F3);
  });

  test('parseColor rejects malformed input', () {
    expect(parseColor('12'), isNull);
    expect(parseColor('GGGGGG'), isNull);
  });

  test('formatColor pads to eight digits', () {
    expect(formatColor(0xFF000001), 'FF000001');
  });
}
