import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/local_file_data_source.dart';
import 'package:flutter_ui_builder/features/editor/data/repositories/code_export_repository_impl.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_file.dart';
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
}
