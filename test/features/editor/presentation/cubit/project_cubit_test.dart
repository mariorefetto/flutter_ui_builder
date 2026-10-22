import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/opened_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/document_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_validator.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/project_usecases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/project_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/project_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements DocumentRepository {}

/// A Column root accepts any number of children, unlike a Scaffold.
EditorDocument columnDocument() => const EditorDocument(
  name: 'untitled',
  root: WidgetNode(id: 'node_0', type: 'Column'),
);

void main() {
  late _MockRepository repository;
  final initial = columnDocument();
  final edited = initial.copyWith(name: 'edited');

  setUpAll(() => registerFallbackValue(initial));

  setUp(() => repository = _MockRepository());

  ProjectCubit build() => ProjectCubit(
    initialDocument: initial,
    saveDocument: SaveDocument(repository),
    saveDocumentAs: SaveDocumentAs(repository),
    openDocument: OpenDocument(
      repository,
      DocumentValidator(WidgetRegistry(builtinDefinitions)),
    ),
  );

  blocTest<ProjectCubit, ProjectState>(
    'the first save asks for a path and binds the project to it',
    setUp: () => when(
      () => repository.saveAs(any()),
    ).thenAnswer((_) async => const Right('/x/a.json')),
    build: build,
    act: (cubit) => cubit.save(edited),
    verify: (cubit) {
      expect(cubit.state.filePath, '/x/a.json');
      expect(cubit.state.savedDocument, edited);
    },
    expect: () => [
      isA<ProjectState>(),
      isA<ProjectState>().having((s) => s.event, 'event', isA<ProjectSaved>()),
      isA<ProjectState>().having((s) => s.event, 'event', isNull),
    ],
  );

  blocTest<ProjectCubit, ProjectState>(
    'later saves reuse the path without asking again',
    setUp: () {
      when(
        () => repository.saveAs(any()),
      ).thenAnswer((_) async => const Right('/x/a.json'));
      when(
        () => repository.save(any(), any()),
      ).thenAnswer((_) async => const Right(unit));
    },
    build: build,
    act: (cubit) async {
      await cubit.save(edited);
      await cubit.save(edited);
    },
    verify: (_) {
      verify(() => repository.saveAs(any())).called(1);
      verify(() => repository.save('/x/a.json', edited)).called(1);
    },
  );

  blocTest<ProjectCubit, ProjectState>(
    'a dismissed save dialog changes nothing',
    setUp: () => when(
      () => repository.saveAs(any()),
    ).thenAnswer((_) async => const Right(null)),
    build: build,
    act: (cubit) => cubit.save(edited),
    expect: () => <ProjectState>[],
  );

  blocTest<ProjectCubit, ProjectState>(
    'open reports the document and makes it the saved one',
    setUp: () => when(() => repository.open()).thenAnswer(
      (_) async => Right(OpenedDocument(document: edited, path: '/x/a.json')),
    ),
    build: build,
    act: (cubit) => cubit.open(),
    verify: (cubit) {
      expect(cubit.state.savedDocument, edited);
      expect(cubit.state.filePath, '/x/a.json');
    },
    expect: () => [
      isA<ProjectState>(),
      isA<ProjectState>().having((s) => s.event, 'event', isA<ProjectOpened>()),
      isA<ProjectState>().having((s) => s.event, 'event', isNull),
    ],
  );

  blocTest<ProjectCubit, ProjectState>(
    'open rejects a project with an unknown widget',
    setUp: () => when(() => repository.open()).thenAnswer(
      (_) async => Right(
        OpenedDocument(
          document: EditorDocument(
            name: 'bad',
            root: initial.root.copyWith(type: 'Nope'),
          ),
          path: '/x/bad.json',
        ),
      ),
    ),
    build: build,
    act: (cubit) => cubit.open(),
    verify: (cubit) => expect(cubit.state.filePath, isNull),
    expect: () => [
      isA<ProjectState>().having(
        (s) => (s.event as ProjectFailed).failure,
        'failure',
        isA<DocumentFailure>(),
      ),
      isA<ProjectState>().having((s) => s.event, 'event', isNull),
    ],
  );
}
