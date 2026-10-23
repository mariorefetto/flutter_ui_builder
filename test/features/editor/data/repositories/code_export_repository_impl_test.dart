import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/local_file_data_source.dart';
import 'package:flutter_ui_builder/features/editor/data/repositories/code_export_repository_impl.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_file.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/media_asset.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:talker/talker.dart';

class _MockFiles extends Mock implements LocalFileDataSource {}

void main() {
  late _MockFiles files;
  late CodeExportRepositoryImpl repository;

  const generated = GeneratedFile(fileName: 'a_view.g.dart', content: 'new');
  final target = p.join('out', 'a_view.g.dart');

  setUpAll(() => registerFallbackValue(Uint8List(0)));

  setUp(() {
    files = _MockFiles();
    repository = CodeExportRepositoryImpl(files, Talker());
    when(() => files.write(any(), any())).thenAnswer((_) async {});
  });

  test('writes a new file', () async {
    when(() => files.readIfExists(target)).thenAnswer((_) async => null);

    final result = await repository.exportFiles('out', [generated]);

    expect(result.getOrElse(() => const []), [target]);
    verify(() => files.write(target, 'new')).called(1);
  });

  test('replaces a file that was generated before', () async {
    when(
      () => files.readIfExists(target),
    ).thenAnswer((_) async => '// $generatedFileMarker\nold');

    final result = await repository.exportFiles('out', [generated]);

    expect(result.isRight(), isTrue);
  });

  test('never overwrites a hand written file', () async {
    when(
      () => files.readIfExists(target),
    ).thenAnswer((_) async => 'class Mine {}');

    final result = await repository.exportFiles('out', [generated]);

    expect(
      result,
      const Left<Failure, List<String>>(
        StorageFailure(StorageFailureReason.notGenerated),
      ),
    );
    verifyNever(() => files.write(any(), any()));
  });

  test('maps a file system error to a failure', () async {
    when(() => files.readIfExists(target)).thenAnswer((_) async => null);
    when(
      () => files.write(any(), any()),
    ).thenThrow(const FileAccessException('denied'));

    final result = await repository.exportFiles('out', [generated]);

    expect(
      result,
      const Left<Failure, List<String>>(
        StorageFailure(StorageFailureReason.access, 'denied'),
      ),
    );
  });

  group('pictures', () {
    const picture = MediaAsset(
      name: 'assets/logo.png',
      sourcePath: '/src/logo.png',
    );
    final copy = p.join('out', 'assets', 'logo.png');
    final bytes = Uint8List.fromList([1, 2, 3]);

    setUp(() {
      when(() => files.readIfExists(target)).thenAnswer((_) async => null);
      when(() => files.writeBytes(any(), any())).thenAnswer((_) async {});
      when(
        () => files.readBytesIfExists('/src/logo.png'),
      ).thenAnswer((_) async => bytes);
    });

    test('a picture is copied under its name next to the code', () async {
      when(() => files.readBytesIfExists(copy)).thenAnswer((_) async => null);

      final result = await repository.exportFiles(
        'out',
        [generated],
        assets: [picture],
      );

      expect(_paths(result), [target, copy]);
      verify(() => files.writeBytes(copy, bytes)).called(1);
    });

    test('the same picture already there is left alone', () async {
      when(
        () => files.readBytesIfExists(copy),
      ).thenAnswer((_) async => Uint8List.fromList([1, 2, 3]));

      final result = await repository.exportFiles(
        'out',
        [generated],
        assets: [picture],
      );

      expect(_paths(result), [target]);
      verifyNever(() => files.writeBytes(any(), any()));
    });

    test(
      'a different file there stops everything before it is written',
      () async {
        when(
          () => files.readBytesIfExists(copy),
        ).thenAnswer((_) async => Uint8List.fromList([9]));

        final result = await repository.exportFiles(
          'out',
          [generated],
          assets: [picture],
        );

        expect(
          result,
          const Left<Failure, List<String>>(
            StorageFailure(StorageFailureReason.assetConflict),
          ),
        );
        verifyNever(() => files.write(any(), any()));
        verifyNever(() => files.writeBytes(any(), any()));
      },
    );

    test('a picture that is gone stops everything too', () async {
      when(
        () => files.readBytesIfExists('/src/logo.png'),
      ).thenAnswer((_) async => null);

      final result = await repository.exportFiles(
        'out',
        [generated],
        assets: [picture],
      );

      expect(
        result,
        const Left<Failure, List<String>>(
          StorageFailure(StorageFailureReason.assetMissing),
        ),
      );
      verifyNever(() => files.write(any(), any()));
    });

    test('a picture with no source file is not copied', () async {
      final result = await repository.exportFiles(
        'out',
        [generated],
        assets: [const MediaAsset(name: 'assets/other.png')],
      );

      expect(_paths(result), [target]);
      verifyNever(() => files.writeBytes(any(), any()));
    });
  });
}

// The paths written, or a failure at once: lists do not compare inside Right.
List<String> _paths(Either<Failure, List<String>> result) => result.getOrElse(
  () => throw StateError(
    'the export failed: ${result.swap().getOrElse(() => const StorageFailure(StorageFailureReason.access))}',
  ),
);
