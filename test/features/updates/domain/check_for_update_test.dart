import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_release.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_version.dart';
import 'package:flutter_ui_builder/features/updates/domain/repositories/release_repository.dart';
import 'package:flutter_ui_builder/features/updates/domain/usecases/update_usecases.dart';
import 'package:mocktail/mocktail.dart';

class _MockReleases extends Mock implements ReleaseRepository {}

AppRelease release(String version) => AppRelease(
  version: AppVersion.tryParse(version)!,
  url: 'https://example.org/$version',
);

void main() {
  late _MockReleases releases;
  late CheckForUpdate check;
  const current = AppVersion(0, 0, 1);

  setUp(() {
    releases = _MockReleases();
    check = CheckForUpdate(releases);
  });

  void published(Either<Failure, AppRelease?> result) =>
      when(() => releases.latest()).thenAnswer((_) async => result);

  test('a newer version is returned', () async {
    published(Right(release('0.0.2')));

    expect(await check(current), Right(release('0.0.2')));
  });

  test('the same version, or an older one, is no update', () async {
    published(Right(release('0.0.1')));
    expect(await check(current), const Right<Failure, AppRelease?>(null));

    published(Right(release('0.0.0')));
    expect(await check(current), const Right<Failure, AppRelease?>(null));
  });

  test('nothing published is no update', () async {
    published(const Right(null));

    expect(await check(current), const Right<Failure, AppRelease?>(null));
  });

  test('a failure is passed on', () async {
    published(const Left(NetworkFailure()));

    expect(
      await check(current),
      const Left<Failure, AppRelease?>(NetworkFailure()),
    );
  });
}
