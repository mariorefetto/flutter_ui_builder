import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/services/dart_style_code_formatter.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/code_export_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/file_dialog_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/code_usecases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockDialogs extends Mock implements FileDialogRepository {}

class _MockExport extends Mock implements CodeExportRepository {}

/// A Column root accepts any number of children, unlike a Scaffold.
EditorDocument columnDocument() => const EditorDocument(
  name: 'untitled',
  root: WidgetNode(id: 'node_0', type: 'Column'),
);

void main() {
  late _MockDialogs dialogs;
  late _MockExport exporter;

  setUp(() {
    dialogs = _MockDialogs();
    exporter = _MockExport();
  });

  CodeCubit build() => CodeCubit(
    document: columnDocument(),
    generateCode: GenerateCode(
      DocumentCodeGenerator(
        WidgetRegistry(builtinDefinitions),
        const DartStyleCodeFormatter(),
      ),
    ),
    pickDirectory: PickExportDirectory(dialogs),
    exportCode: ExportCode(exporter),
  );

  test('generates the code on creation', () {
    final cubit = build();

    expect(cubit.state, isA<CodeReady>());
    expect((cubit.state as CodeReady).files, hasLength(1));
  });

  blocTest<CodeCubit, CodeState>(
    'export reports the number of files then returns to ready',
    setUp: () {
      when(
        () => dialogs.pickDirectory(),
      ).thenAnswer((_) async => const Right('out'));
      when(
        () => exporter.exportFiles(any(), any()),
      ).thenAnswer((_) async => const Right(['out/untitled_view.g.dart']));
    },
    build: build,
    act: (cubit) => cubit.export(),
    expect: () => [
      isA<CodeExporting>(),
      isA<CodeExported>().having((s) => s.count, 'count', 1),
      isA<CodeReady>(),
    ],
  );

  blocTest<CodeCubit, CodeState>(
    'dismissing the folder dialog exports nothing',
    setUp: () => when(
      () => dialogs.pickDirectory(),
    ).thenAnswer((_) async => const Right(null)),
    build: build,
    act: (cubit) => cubit.export(),
    expect: () => [isA<CodeExporting>(), isA<CodeReady>()],
    verify: (_) => verifyNever(() => exporter.exportFiles(any(), any())),
  );

  blocTest<CodeCubit, CodeState>(
    'a failed export reports the failure then returns to ready',
    setUp: () {
      when(
        () => dialogs.pickDirectory(),
      ).thenAnswer((_) async => const Right('out'));
      when(() => exporter.exportFiles(any(), any())).thenAnswer(
        (_) async =>
            const Left(StorageFailure(StorageFailureReason.notGenerated)),
      );
    },
    build: build,
    act: (cubit) => cubit.export(),
    expect: () => [
      isA<CodeExporting>(),
      isA<CodeExportFailed>(),
      isA<CodeReady>(),
    ],
  );

  test('update regenerates the code for the new document', () {
    final cubit = build();

    cubit.update(columnDocument().copyWith(name: 'renamed'));

    expect(
      (cubit.state as CodeReady).files.single.fileName,
      'renamed_view.g.dart',
    );
  });
}
