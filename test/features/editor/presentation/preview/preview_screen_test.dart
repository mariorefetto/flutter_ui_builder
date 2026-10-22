import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';

void main() {
  test('a phone is tall and turns on its side', () {
    expect(PreviewDevice.phone.size(landscape: false), const Size(390, 844));
    expect(PreviewDevice.phone.size(landscape: true), const Size(844, 390));
  });

  test('a desktop is always wider than tall', () {
    expect(PreviewDevice.desktop.size(landscape: false), const Size(1280, 800));
    expect(PreviewDevice.desktop.size(landscape: true), const Size(1280, 800));
  });
}
