import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/app_info.dart';

void main() {
  test('the version of the app is the one in pubspec.yaml', () {
    final line = File(
      'pubspec.yaml',
    ).readAsLinesSync().firstWhere((l) => l.startsWith('version:'));
    final version = RegExp(r'^version:\s*([^+\s]+)').firstMatch(line)![1];

    expect(appVersion, version);
  });
}
