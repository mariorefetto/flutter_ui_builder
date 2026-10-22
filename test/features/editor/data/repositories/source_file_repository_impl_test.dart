import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/file_dialog_data_source.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/local_file_data_source.dart';
import 'package:flutter_ui_builder/features/editor/data/repositories/source_file_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

class _MockDialogs extends Mock implements FileDialogDataSource {}

class _MockFiles extends Mock implements LocalFileDataSource {}

void main() {
  late _MockDialogs dialogs;
  late _MockFiles files;
  late SourceFileRepositoryImpl repository;

  setUp(() {
    dialogs = _MockDialogs();
    files = _MockFiles();
    repository = SourceFileRepositoryImpl(dialogs, files, Talker());
  });

  test('reads the Dart file the user picked', () async {
    when(() => dialogs.pickFile('dart')).thenAnswer((_) async => 'a.dart');
    when(() => files.readIfExists('a.dart')).thenAnswer((_) async => 'code');

    final result = await repository.pickAndRead();

    expect(result.getOrElse(() => null), 'code');
  });

  test('a dismissed dialog gives null without reading anything', () async {
    when(() => dialogs.pickFile('dart')).thenAnswer((_) async => null);

    final result = await repository.pickAndRead();

    expect(result.getOrElse(() => 'unexpected'), isNull);
    verifyNever(() => files.readIfExists(any()));
  });

  test('a read error and a dialog crash are storage failures', () async {
    when(() => dialogs.pickFile('dart')).thenAnswer((_) async => 'a.dart');
    when(
      () => files.readIfExists('a.dart'),
    ).thenThrow(const FileAccessException('denied'));

    expect(
      (await repository.pickAndRead()).fold((f) => f, (_) => null),
      isA<StorageFailure>(),
    );

    when(() => dialogs.pickFile('dart')).thenThrow(Exception('plugin'));

    expect(
      (await repository.pickAndRead()).fold((f) => f, (_) => null),
      isA<StorageFailure>(),
    );
  });
}
