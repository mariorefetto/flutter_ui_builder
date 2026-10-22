import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/file_dialog_data_source.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/local_file_data_source.dart';
import 'package:flutter_ui_builder/features/editor/data/repositories/document_repository_impl.dart';
import 'package:flutter_ui_builder/features/editor/data/services/document_json_codec.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

class _MockFiles extends Mock implements LocalFileDataSource {}

class _MockDialogs extends Mock implements FileDialogDataSource {}

/// A Column root accepts any number of children, unlike a Scaffold.
EditorDocument columnDocument() => const EditorDocument(
  name: 'untitled',
  root: WidgetNode(id: 'node_0', type: 'Column'),
);

void main() {
  late _MockFiles files;
  late _MockDialogs dialogs;
  late DocumentRepositoryImpl repository;
  final document = columnDocument();

  setUpAll(() => registerFallbackValue(Uint8List(0)));

  setUp(() {
    files = _MockFiles();
    dialogs = _MockDialogs();
    repository = DocumentRepositoryImpl(
      files,
      dialogs,
      const DocumentJsonCodec(),
      Talker(),
    );
  });

  test('save writes the encoded document', () async {
    when(() => files.write(any(), any())).thenAnswer((_) async {});

    final result = await repository.save('a.json', document);

    expect(result.isRight(), isTrue);
    verify(
      () => files.write('a.json', const DocumentJsonCodec().encode(document)),
    ).called(1);
  });

  test('saveAs proposes a file name from the document name', () async {
    when(
      () => dialogs.saveFile(any(), any()),
    ).thenAnswer((_) async => '/x/untitled.json');

    final result = await repository.saveAs(document);

    expect(result.getOrElse(() => null), '/x/untitled.json');
    verify(() => dialogs.saveFile('untitled.json', any())).called(1);
  });

  test('open returns null when the dialog is dismissed', () async {
    when(() => dialogs.pickFile(any())).thenAnswer((_) async => null);

    final result = await repository.open();

    expect(result.getOrElse(() => throw StateError('failed')), isNull);
  });

  test('open reads and decodes the chosen file', () async {
    when(() => dialogs.pickFile(any())).thenAnswer((_) async => 'a.json');
    when(
      () => files.readIfExists('a.json'),
    ).thenAnswer((_) async => const DocumentJsonCodec().encode(document));

    final opened = (await repository.open()).getOrElse(() => null);

    expect(opened?.document, document);
    expect(opened?.path, 'a.json');
  });

  test('open reports a file that is not a project', () async {
    when(() => dialogs.pickFile(any())).thenAnswer((_) async => 'a.json');
    when(() => files.readIfExists('a.json')).thenAnswer((_) async => 'oops');

    final result = await repository.open();

    expect(
      result.fold((f) => f, (_) => null),
      isA<DocumentFailure>().having(
        (f) => f.reason,
        'reason',
        DocumentFailureReason.invalidFormat,
      ),
    );
  });

  test('a dialog crash becomes a storage failure', () async {
    when(() => dialogs.pickFile(any())).thenThrow(Exception('plugin'));

    final result = await repository.open();

    expect(result.fold((f) => f, (_) => null), isA<StorageFailure>());
  });
}
