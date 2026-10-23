import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_release.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_version.dart';
import 'package:flutter_ui_builder/features/updates/domain/repositories/external_link_repository.dart';
import 'package:flutter_ui_builder/features/updates/domain/repositories/release_repository.dart';
import 'package:flutter_ui_builder/features/updates/domain/usecases/update_usecases.dart';
import 'package:flutter_ui_builder/features/updates/presentation/cubit/update_cubit.dart';
import 'package:flutter_ui_builder/features/updates/presentation/cubit/update_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockReleases extends Mock implements ReleaseRepository {}

class _MockLinks extends Mock implements ExternalLinkRepository {}

const newer = AppRelease(
  version: AppVersion(0, 0, 2),
  url: 'https://github.com/o/r/releases/tag/v0.0.2',
);

void main() {
  late _MockReleases releases;
  late _MockLinks links;

  setUp(() {
    releases = _MockReleases();
    links = _MockLinks();
  });

  UpdateCubit cubit() => UpdateCubit(
    checkForUpdate: CheckForUpdate(releases),
    openLink: OpenLink(links),
    current: const AppVersion(0, 0, 1),
  );

  void published(Either<Failure, AppRelease?> result) =>
      when(() => releases.latest()).thenAnswer((_) async => result);

  group('a check that was asked for', () {
    blocTest<UpdateCubit, UpdateState>(
      'announces itself, then the newer version',
      setUp: () => published(const Right(newer)),
      build: cubit,
      act: (c) => c.check(),
      expect: () => [
        const UpdateState.checking(),
        const UpdateState.available(newer),
      ],
    );

    blocTest<UpdateCubit, UpdateState>(
      'says when nothing is newer',
      setUp: () => published(const Right(null)),
      build: cubit,
      act: (c) => c.check(),
      expect: () => [
        const UpdateState.checking(),
        const UpdateState.upToDate(),
      ],
    );

    blocTest<UpdateCubit, UpdateState>(
      'says when it could not be made',
      setUp: () => published(const Left(NetworkFailure())),
      build: cubit,
      act: (c) => c.check(),
      expect: () => [
        const UpdateState.checking(),
        const UpdateState.failed(NetworkFailure()),
      ],
    );
  });

  group('a quiet check', () {
    blocTest<UpdateCubit, UpdateState>(
      'speaks when there is a newer version',
      setUp: () => published(const Right(newer)),
      build: cubit,
      act: (c) => c.check(quiet: true),
      expect: () => [const UpdateState.available(newer)],
    );

    blocTest<UpdateCubit, UpdateState>(
      'says nothing when there is none',
      setUp: () => published(const Right(null)),
      build: cubit,
      act: (c) => c.check(quiet: true),
      expect: () => <UpdateState>[],
    );

    blocTest<UpdateCubit, UpdateState>(
      'says nothing when it fails',
      setUp: () => published(const Left(NetworkFailure())),
      build: cubit,
      act: (c) => c.check(quiet: true),
      expect: () => <UpdateState>[],
    );
  });

  blocTest<UpdateCubit, UpdateState>(
    'a second check waits for the one under way',
    setUp: () => published(const Right(newer)),
    build: cubit,
    act: (c) async {
      final first = c.check();
      await c.check();
      await first;
    },
    verify: (_) => verify(() => releases.latest()).called(1),
  );

  group('the download page', () {
    test('opens the page of the newer version', () async {
      published(const Right(newer));
      when(() => links.open(any())).thenAnswer((_) async => const Right(unit));
      final c = cubit();
      await c.check(quiet: true);

      expect(await c.openRelease(), const Right(unit));
      verify(() => links.open(newer.url)).called(1);
      await c.close();
    });

    test('opens nothing when there is nothing new', () async {
      final c = cubit();

      expect(await c.openRelease(), const Right(unit));
      verifyNever(() => links.open(any()));
      await c.close();
    });

    test('says when the browser did not open', () async {
      published(const Right(newer));
      when(
        () => links.open(any()),
      ).thenAnswer((_) async => const Left(LaunchFailure()));
      final c = cubit();
      await c.check(quiet: true);

      expect(await c.openRelease(), const Left<Failure, Unit>(LaunchFailure()));
      await c.close();
    });
  });
}
