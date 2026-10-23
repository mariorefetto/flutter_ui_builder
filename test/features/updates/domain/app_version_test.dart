import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_version.dart';

AppVersion v(String text) => AppVersion.tryParse(text)!;

void main() {
  group('reading', () {
    test('a tag with or without the v is a version', () {
      expect(v('1.2.3'), const AppVersion(1, 2, 3));
      expect(v('v0.0.1'), const AppVersion(0, 0, 1));
      expect(v(' v10.20.30 '), const AppVersion(10, 20, 30));
    });

    test('a pre-release part and build metadata are read', () {
      expect(v('1.0.0-beta.2').preRelease, ['beta', '2']);
      expect(v('1.0.0-beta.2').isPreRelease, isTrue);
      expect(v('1.0.0+7'), const AppVersion(1, 0, 0));
      expect(v('1.0.0').isPreRelease, isFalse);
    });

    test('anything else is not a version', () {
      for (final text in [
        '',
        'latest',
        '1.2',
        'v1.2.3.4',
        '1.x.3',
        'nightly',
      ]) {
        expect(AppVersion.tryParse(text), isNull, reason: text);
      }
    });
  });

  group('order', () {
    test('the numbers decide, each as a number', () {
      expect(v('0.0.2').isNewerThan(v('0.0.1')), isTrue);
      expect(v('0.1.0').isNewerThan(v('0.0.9')), isTrue);
      expect(v('1.0.0').isNewerThan(v('0.99.99')), isTrue);
      expect(v('0.0.10').isNewerThan(v('0.0.9')), isTrue);
      expect(v('0.0.1').isNewerThan(v('0.0.1')), isFalse);
      expect(v('0.0.1').isNewerThan(v('0.0.2')), isFalse);
    });

    test('a pre-release comes before its release', () {
      expect(v('1.0.0').isNewerThan(v('1.0.0-rc.1')), isTrue);
      expect(v('1.0.0-rc.1').isNewerThan(v('1.0.0')), isFalse);
      expect(v('1.0.1-alpha').isNewerThan(v('1.0.0')), isTrue);
    });

    test('pre-releases follow the semver order', () {
      final order = [
        '1.0.0-alpha',
        '1.0.0-alpha.1',
        '1.0.0-alpha.beta',
        '1.0.0-beta',
        '1.0.0-beta.2',
        '1.0.0-beta.11',
        '1.0.0-rc.1',
        '1.0.0',
      ].map(v).toList();

      for (var i = 0; i < order.length - 1; i++) {
        expect(
          order[i + 1].isNewerThan(order[i]),
          isTrue,
          reason: '${order[i + 1]} after ${order[i]}',
        );
      }
    });

    test('equal versions are equal, whatever the build', () {
      expect(v('1.0.0+1'), v('v1.0.0'));
      expect(v('1.0.0+1').hashCode, v('1.0.0').hashCode);
    });

    test('it is written the way semver does', () {
      expect(v('v1.2.3-beta.1+9').toString(), '1.2.3-beta.1');
    });
  });
}
