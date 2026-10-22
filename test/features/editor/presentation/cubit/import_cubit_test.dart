import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/services/analyzer_code_parser.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_importer.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/source_file_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/import_usecases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/import_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/import_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockSource extends Mock implements SourceFileRepository {}

void main() {
  late _MockSource source;

  setUp(() => source = _MockSource());

  ImportCubit build() => ImportCubit(
    importCode: ImportCode(
      CodeImporter(
        WidgetRegistry(builtinDefinitions),
        const AnalyzerCodeParser(),
      ),
    ),
    pickDartSource: PickDartSource(source),
  );

  blocTest<ImportCubit, ImportState>(
    'render keeps the document built from the code',
    build: build,
    act: (cubit) => cubit.render("Text('Hi')"),
    verify: (cubit) {
      expect(cubit.state.result?.document.root.type, 'Text');
      expect(cubit.state.failure, isNull);
    },
  );

  blocTest<ImportCubit, ImportState>(
    'a failed render drops the previous result and keeps the failure',
    build: build,
    act: (cubit) => cubit
      ..render("Text('Hi')")
      ..render('Column(children: ['),
    verify: (cubit) {
      expect(cubit.state.result, isNull);
      expect(cubit.state.failure, isA<DocumentFailure>());
    },
  );

  blocTest<ImportCubit, ImportState>(
    'a file is read, shown and rendered',
    setUp: () => when(
      () => source.pickAndRead(),
    ).thenAnswer((_) async => const Right('Icon(Icons.add)')),
    build: build,
    act: (cubit) => cubit.openFile(),
    verify: (cubit) {
      expect(cubit.state.fileText, 'Icon(Icons.add)');
      expect(cubit.state.fileRevision, 1);
      expect(cubit.state.result?.document.root.type, 'Icon');
    },
  );

  blocTest<ImportCubit, ImportState>(
    'dismissing the file dialog changes nothing',
    setUp: () => when(
      () => source.pickAndRead(),
    ).thenAnswer((_) async => const Right(null)),
    build: build,
    act: (cubit) => cubit.openFile(),
    expect: () => <ImportState>[],
  );

  blocTest<ImportCubit, ImportState>(
    'a file that cannot be read is a failure',
    setUp: () => when(() => source.pickAndRead()).thenAnswer(
      (_) async => const Left(StorageFailure(StorageFailureReason.access)),
    ),
    build: build,
    act: (cubit) => cubit.openFile(),
    verify: (cubit) => expect(cubit.state.failure, isA<StorageFailure>()),
  );
}
