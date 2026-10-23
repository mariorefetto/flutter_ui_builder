import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/updates/data/datasources/external_link_data_source.dart';
import 'package:flutter_ui_builder/features/updates/data/datasources/release_data_source.dart';
import 'package:flutter_ui_builder/features/updates/data/repositories/external_link_repository_impl.dart';
import 'package:flutter_ui_builder/features/updates/data/repositories/release_repository_impl.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_release.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

class _MockSource extends Mock implements ReleaseDataSource {}

class _MockLinks extends Mock implements ExternalLinkDataSource {}

Map<String, Object?> entry(
  String tag, {
  bool draft = false,
  bool prerelease = false,
}) => {
  'tag_name': tag,
  'html_url': 'https://github.com/o/r/releases/tag/$tag',
  'draft': draft,
  'prerelease': prerelease,
  'name': 'ignored',
  'assets': <Object?>[],
};

void main() {
  setUpAll(() => registerFallbackValue(Uri()));

  group('the releases', () {
    late _MockSource source;
    late ReleaseRepositoryImpl repository;

    setUp(() {
      source = _MockSource();
      repository = ReleaseRepositoryImpl(source, Talker());
    });

    void answer(Object? body) => when(
      () => source.fetchReleases(),
    ).thenAnswer((_) async => body is String ? body : jsonEncode(body));

    Future<AppRelease?> latest() async =>
        (await repository.latest()).getOrElse(() => throw StateError('failed'));

    test('the newest version wins, whatever the order of the list', () async {
      answer([entry('v0.0.1'), entry('v0.0.3'), entry('v0.0.2')]);

      expect((await latest())!.version.toString(), '0.0.3');
    });

    test('the page and the pre-release mark are kept', () async {
      answer([entry('v0.0.2', prerelease: true)]);

      final release = (await latest())!;
      expect(release.preRelease, isTrue);
      expect(release.url, 'https://github.com/o/r/releases/tag/v0.0.2');
    });

    test('drafts and tags that are not versions are skipped', () async {
      answer([entry('v9.9.9', draft: true), entry('nightly'), entry('v0.0.2')]);

      expect((await latest())!.version.toString(), '0.0.2');
    });

    test('no releases is not an error', () async {
      answer(<Object?>[]);

      expect(
        await repository.latest(),
        const Right<Failure, AppRelease?>(null),
      );
    });

    test('an answer that is not a list is a failure', () async {
      answer({'message': 'rate limit exceeded'});

      expect((await repository.latest()).isLeft(), isTrue);
    });

    test('an answer that is not JSON is a failure', () async {
      answer('<html>');

      expect(
        await repository.latest(),
        const Left<Failure, AppRelease?>(
          NetworkFailure('The answer is not JSON'),
        ),
      );
    });

    test('a release without a tag is a failure, not a crash', () async {
      answer([
        {'html_url': 'x'},
      ]);

      expect((await repository.latest()).isLeft(), isTrue);
    });

    test('a network error becomes a failure', () async {
      when(
        () => source.fetchReleases(),
      ).thenThrow(const NetworkException('offline'));

      expect(
        await repository.latest(),
        const Left<Failure, AppRelease?>(NetworkFailure('offline')),
      );
    });
  });

  group('the source', () {
    test('it asks for the releases of the project', () async {
      Uri? asked;
      final source = GithubReleaseDataSource(
        get: (url) async {
          asked = url;
          return '[]';
        },
      );

      expect(await source.fetchReleases(), '[]');
      expect(asked.toString(), startsWith('https://api.github.com/repos/'));
      expect(asked!.path, endsWith('/releases'));
    });

    test('the errors of the network are told apart from the rest', () async {
      for (final error in <Object>[
        const SocketException('no route'),
        TimeoutException('slow'),
        const HttpException('Answered 403'),
        const HandshakeException('bad certificate'),
      ]) {
        final source = GithubReleaseDataSource(get: (_) async => throw error);

        await expectLater(
          source.fetchReleases(),
          throwsA(isA<NetworkException>()),
          reason: '$error',
        );
      }
    });
  });

  group('the links', () {
    late _MockLinks source;
    late ExternalLinkRepositoryImpl repository;

    setUp(() {
      source = _MockLinks();
      repository = ExternalLinkRepositoryImpl(source, Talker());
    });

    test('a web page is opened', () async {
      when(() => source.open(any())).thenAnswer((_) async {});

      expect(
        await repository.open('https://github.com/o/r'),
        const Right(unit),
      );
      verify(() => source.open(Uri.parse('https://github.com/o/r'))).called(1);
    });

    test('only web pages are opened', () async {
      for (final url in [
        'file:///etc/passwd',
        'javascript:alert(1)',
        'x y',
        '',
      ]) {
        expect((await repository.open(url)).isLeft(), isTrue, reason: url);
      }
      verifyNever(() => source.open(any()));
    });

    test('a browser that does not open is a failure', () async {
      when(() => source.open(any())).thenThrow(const LaunchException('no'));

      expect(
        await repository.open('https://github.com/o/r'),
        const Left<Failure, Unit>(LaunchFailure('no')),
      );
    });
  });
}
