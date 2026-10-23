import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/drop_plan.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/drop_planner.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/tree_editor.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_use_cases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/drag_payload.dart';

EditorCubit _cubit() {
  final registry = WidgetRegistry(builtinDefinitions);
  final editor = TreeEditor(registry);
  return EditorCubit(
    initialDocument: columnDocument(),
    useCases: EditorUseCases.from(
      editor: editor,
      planner: DropPlanner(registry),
      registry: registry,
    ),
  );
}

/// A Column root accepts any number of children, unlike a Scaffold.
EditorDocument columnDocument() => const EditorDocument(
  name: 'untitled',
  root: WidgetNode(id: 'node_0', type: 'Column'),
);

void main() {
  blocTest<EditorCubit, EditorState>(
    'addNode selects the new node and enables undo',
    build: _cubit,
    act: (cubit) => cubit.addNode(type: 'Text', parentId: 'node_0'),
    verify: (cubit) {
      expect(cubit.state.selectedId, 'node_1');
      expect(cubit.state.document.root.children, hasLength(1));
      expect(cubit.state.history.canUndo, isTrue);
    },
  );

  blocTest<EditorCubit, EditorState>(
    'undo restores the document and clears a stale selection',
    build: _cubit,
    act: (cubit) {
      cubit
        ..addNode(type: 'Text', parentId: 'node_0')
        ..undo();
    },
    verify: (cubit) {
      expect(cubit.state.document.root.children, isEmpty);
      expect(cubit.state.selectedId, isNull);
      expect(cubit.state.history.canRedo, isTrue);
    },
  );

  blocTest<EditorCubit, EditorState>(
    'redo reapplies the undone edit',
    build: _cubit,
    act: (cubit) {
      cubit
        ..addNode(type: 'Text', parentId: 'node_0')
        ..undo()
        ..redo();
    },
    verify: (cubit) => expect(cubit.state.document.root.children, hasLength(1)),
  );

  blocTest<EditorCubit, EditorState>(
    'a refused edit leaves the document untouched and reports the failure',
    build: _cubit,
    act: (cubit) => cubit.removeNode('node_0'),
    verify: (cubit) => expect(cubit.state.history.canUndo, isFalse),
    expect: () => [
      isA<EditorState>().having(
        (s) => s.failure,
        'failure',
        const TreeFailure(TreeFailureReason.rootProtected),
      ),
      isA<EditorState>().having((s) => s.failure, 'failure', isNull),
    ],
  );

  blocTest<EditorCubit, EditorState>(
    'removeNode drops the subtree',
    build: _cubit,
    act: (cubit) {
      cubit
        ..addNode(type: 'Text', parentId: 'node_0')
        ..removeNode('node_1');
    },
    verify: (cubit) => expect(cubit.state.document.root.children, isEmpty),
  );

  blocTest<EditorCubit, EditorState>(
    'select ignores unknown ids',
    build: _cubit,
    act: (cubit) => cubit.select('missing'),
    verify: (cubit) => expect(cubit.state.selectedId, isNull),
  );

  blocTest<EditorCubit, EditorState>(
    'dropping a new widget on a leaf inserts it before that leaf',
    build: _cubit,
    act: (cubit) {
      cubit
        ..addNode(type: 'Text', parentId: 'node_0')
        ..drop(const NewWidgetPayload('Image'), 'node_1', DropSide.before);
    },
    verify: (cubit) => expect(
      cubit.state.document.root.children.map((c) => c.type),
      ['Image', 'Text'],
    ),
  );

  blocTest<EditorCubit, EditorState>(
    'dropping a node where it already is adds no undo step',
    build: _cubit,
    act: (cubit) {
      cubit
        ..addNode(type: 'Text', parentId: 'node_0')
        ..addNode(type: 'Image', parentId: 'node_0')
        ..drop(const MoveNodePayload('node_2'), 'node_1', DropSide.after);
    },
    verify: (cubit) => expect(cubit.state.history.past, hasLength(2)),
  );

  blocTest<EditorCubit, EditorState>(
    'planDrop reports null for a refused drop and changes nothing',
    build: _cubit,
    act: (cubit) => cubit.addNode(type: 'Text', parentId: 'node_0'),
    verify: (cubit) {
      final before = cubit.state;

      expect(
        cubit.planDrop(
          const MoveNodePayload('node_1'),
          'node_1',
          DropSide.after,
        ),
        isNull,
      );
      expect(cubit.state, before);
    },
  );

  blocTest<EditorCubit, EditorState>(
    'renameDocument is an undoable edit that keeps the selection',
    build: _cubit,
    act: (cubit) {
      cubit
        ..addNode(type: 'Text', parentId: 'node_0')
        ..renameDocument('  My Screen ');
      expect(cubit.state.document.name, 'My Screen');
      expect(cubit.state.selectedId, 'node_1');
      cubit.undo();
    },
    verify: (cubit) => expect(cubit.state.document.name, 'untitled'),
  );

  blocTest<EditorCubit, EditorState>(
    'renameDocument refuses a blank name',
    build: _cubit,
    act: (cubit) => cubit.renameDocument('   '),
    verify: (cubit) => expect(cubit.state.document.name, 'untitled'),
  );

  blocTest<EditorCubit, EditorState>(
    'replaceDocument starts a fresh history',
    build: _cubit,
    act: (cubit) {
      cubit
        ..addNode(type: 'Text', parentId: 'node_0')
        ..replaceDocument(columnDocument());
    },
    verify: (cubit) {
      expect(cubit.state.history.canUndo, isFalse);
      expect(cubit.state.selectedId, isNull);
    },
  );

  blocTest<EditorCubit, EditorState>(
    'canAddToSelection tells whether the palette entry would fit',
    build: _cubit,
    act: (cubit) => cubit.addNode(type: 'Text', parentId: 'node_0'),
    verify: (cubit) {
      // A Text is selected: it takes no children, so the entry goes beside it.
      expect(cubit.canAddToSelection('Image'), isTrue);
      // A screen widget can never be nested.
      expect(cubit.canAddToSelection('Scaffold'), isFalse);
      // A slot widget needs a Scaffold, and the root is a Column here.
      expect(cubit.canAddToSelection('AppBar'), isFalse);
    },
  );

  group('clipboard', () {
    blocTest<EditorCubit, EditorState>(
      'copy then paste adds a copy of the selection with fresh ids',
      build: _cubit,
      act: (cubit) {
        cubit
          ..addNode(type: 'Text', parentId: 'node_0')
          ..copy()
          ..select('node_0')
          ..paste();
      },
      verify: (cubit) {
        final children = cubit.state.document.root.children;

        expect(children.map((c) => c.type), ['Text', 'Text']);
        expect(children.map((c) => c.id).toSet(), hasLength(2));
        expect(cubit.state.selectedId, children.last.id);
      },
    );

    blocTest<EditorCubit, EditorState>(
      'cut removes the selection and keeps it for pasting',
      build: _cubit,
      act: (cubit) {
        cubit
          ..addNode(type: 'Text', parentId: 'node_0')
          ..cut();
      },
      verify: (cubit) {
        expect(cubit.state.document.root.children, isEmpty);
        expect(cubit.state.clipboard?.type, 'Text');
        expect(cubit.canPaste, isTrue);
      },
    );

    blocTest<EditorCubit, EditorState>(
      'the root cannot be cut',
      build: _cubit,
      act: (cubit) => cubit
        ..select('node_0')
        ..cut(),
      verify: (cubit) {
        expect(cubit.canCut, isFalse);
        expect(cubit.state.clipboard, isNull);
      },
    );

    blocTest<EditorCubit, EditorState>(
      'the clipboard survives opening another document',
      build: _cubit,
      act: (cubit) {
        cubit
          ..addNode(type: 'Text', parentId: 'node_0')
          ..copy()
          ..replaceDocument(columnDocument());
      },
      verify: (cubit) => expect(cubit.canPaste, isTrue),
    );

    blocTest<EditorCubit, EditorState>(
      'duplicate puts a copy next to the original',
      build: _cubit,
      act: (cubit) {
        cubit
          ..addNode(type: 'Text', parentId: 'node_0')
          ..duplicateSelected();
      },
      verify: (cubit) =>
          expect(cubit.state.document.root.children, hasLength(2)),
    );
  });

  group('wrap and unwrap', () {
    blocTest<EditorCubit, EditorState>(
      'wrapSelected and unwrapSelected are undoable edits',
      build: _cubit,
      act: (cubit) {
        cubit
          ..addNode(type: 'Text', parentId: 'node_0')
          ..wrapSelected('Padding');
        expect(cubit.state.document.root.children.single.type, 'Padding');
        cubit.unwrapSelected();
        expect(cubit.state.document.root.children.single.type, 'Text');
      },
      verify: (cubit) => expect(cubit.state.history.canUndo, isTrue),
    );

    blocTest<EditorCubit, EditorState>(
      'canWrapSelection lists only wrappers that fit',
      build: _cubit,
      act: (cubit) => cubit.addNode(type: 'Text', parentId: 'node_0'),
      verify: (cubit) {
        expect(cubit.canWrapSelection('Center'), isTrue);
        expect(cubit.canWrapSelection('Text'), isFalse);
        expect(cubit.canWrapSelection('Positioned'), isFalse);
        expect(cubit.canUnwrap, isFalse);
      },
    );
  });

  group('keyboard navigation', () {
    // Column(node_0) > [Text(node_1), Image(node_2)]
    EditorCubit withTwoChildren() => _cubit()
      ..addNode(type: 'Text', parentId: 'node_0')
      ..addNode(type: 'Image', parentId: 'node_0');

    test('selectNeighbour walks the widgets in reading order', () {
      final cubit = withTwoChildren()..select('node_0');

      cubit.selectNeighbour(next: true);
      expect(cubit.state.selectedId, 'node_1');
      cubit.selectNeighbour(next: true);
      expect(cubit.state.selectedId, 'node_2');
      cubit.selectNeighbour(next: true);
      expect(cubit.state.selectedId, 'node_2');
      cubit.selectNeighbour(next: false);
      expect(cubit.state.selectedId, 'node_1');
    });

    test('left goes to the parent and right to the first child', () {
      final cubit = withTwoChildren()..select('node_2');

      cubit.selectParent();
      expect(cubit.state.selectedId, 'node_0');
      cubit.selectFirstChild();
      expect(cubit.state.selectedId, 'node_1');
      cubit
        ..select('node_1')
        ..selectFirstChild();
      expect(cubit.state.selectedId, 'node_1');
    });

    test('moveSelectedBy reorders among siblings as an undoable edit', () {
      final cubit = withTwoChildren()
        ..select('node_1')
        ..moveSelectedBy(1);

      expect(cubit.state.document.root.children.map((c) => c.id), [
        'node_2',
        'node_1',
      ]);

      cubit.moveSelectedBy(1);
      expect(cubit.state.document.root.children.map((c) => c.id), [
        'node_2',
        'node_1',
      ]);

      cubit.undo();
      expect(cubit.state.document.root.children.map((c) => c.id), [
        'node_1',
        'node_2',
      ]);
    });
  });

  blocTest<EditorCubit, EditorState>(
    'relabelNode is an undoable edit that keeps the selection',
    build: _cubit,
    act: (cubit) {
      cubit
        ..addNode(type: 'Text', parentId: 'node_0')
        ..relabelNode('node_1', 'Title');
      expect(cubit.state.document.root.children.single.label, 'Title');
      expect(cubit.state.selectedId, isNull);
      cubit.undo();
    },
    verify: (cubit) =>
        expect(cubit.state.document.root.children.single.label, isNull),
  );

  group('screens', () {
    test('adding a screen opens it and can be undone', () {
      final cubit = _cubit()..addScreen('Settings');

      expect(cubit.state.document.name, 'Settings');
      expect(cubit.state.document.screens.single.name, 'untitled');
      cubit.undo();
      expect(cubit.state.document.name, 'untitled');
      expect(cubit.state.document.screens, isEmpty);
    });

    test('opening a screen is not an undo step', () {
      final cubit = _cubit()..addScreen('Settings');
      final steps = cubit.state.history.past.length;

      cubit.openScreen('untitled');

      expect(cubit.state.document.name, 'untitled');
      expect(cubit.state.history.past, hasLength(steps));
      expect(cubit.state.selectedId, isNull);
    });

    test('edits go to the screen that is open', () {
      final cubit = _cubit()
        ..addScreen('Settings')
        // A new screen starts with a Scaffold whose body is node_2.
        ..addNode(type: 'Text', parentId: 'node_2');

      cubit.openScreen('untitled');

      expect(cubit.state.document.root.children, isEmpty);
      cubit.openScreen('Settings');
      expect(
        cubit.state.document.root.find('node_2')?.children.single.type,
        'Text',
      );
    });

    test('a refused change is reported and changes nothing', () async {
      final cubit = _cubit();
      final failures = <Failure>[];
      final sub = cubit.stream.listen((s) {
        if (s.failure != null) failures.add(s.failure!);
      });

      cubit.deleteScreen('untitled');
      await pumpEventQueue();

      expect(failures, hasLength(1));
      expect(cubit.state.document.name, 'untitled');
      await sub.cancel();
    });

    test('renaming the document renames the open screen', () {
      final cubit = _cubit()..addScreen('Settings');

      cubit.renameDocument('Preferences');

      expect(cubit.state.document.name, 'Preferences');
      expect(cubit.state.document.screens.single.name, 'untitled');
    });
  });

  group('pictures', () {
    test('pictures are added and removed', () {
      final cubit = _cubit()..addAssets(['/x/logo.png']);

      expect(cubit.state.document.assets.single.name, 'assets/logo.png');
      cubit.removeAsset('assets/logo.png');
      expect(cubit.state.document.assets, isEmpty);
    });

    test('adding pictures is an undo step, and adding none is not', () {
      final cubit = _cubit()..addAssets(const []);
      expect(cubit.state.history.canUndo, isFalse);

      cubit.addAssets(['/x/logo.png']);
      expect(cubit.state.history.canUndo, isTrue);
      cubit.undo();
      expect(cubit.state.document.assets, isEmpty);
    });
  });

  group('theme', () {
    test('a value of the theme is set and is an undo step', () {
      final cubit = _cubit()..setThemeValue('card', 'elevation', 4.0);

      expect(cubit.state.document.theme.parts['card'], {'elevation': 4.0});
      cubit.undo();
      expect(cubit.state.document.theme.isDefault, isTrue);
    });

    test(
      'a value the theme does not take is refused and changes nothing',
      () async {
        final cubit = _cubit();
        final failures = <Failure>[];
        final sub = cubit.stream.listen((s) {
          if (s.failure != null) failures.add(s.failure!);
        });

        cubit.setThemeValue('card', 'elevation', 'much');
        await pumpEventQueue();

        expect(failures, hasLength(1));
        expect(cubit.state.document.theme.isDefault, isTrue);
        await sub.cancel();
      },
    );

    test('a part is put back to the defaults', () {
      final cubit = _cubit()
        ..setThemeValue('card', 'elevation', 4.0)
        ..setThemeValue('appBar', 'centerTitle', true)
        ..resetThemePart('card');

      expect(cubit.state.document.theme.parts.keys, ['appBar']);
    });

    test('opening another screen keeps the theme', () {
      final cubit = _cubit()
        ..setThemeValue('card', 'elevation', 4.0)
        ..addScreen('Settings');

      expect(cubit.state.document.theme.parts['card'], {'elevation': 4.0});
    });
  });

  group('several widgets selected', () {
    EditorCubit withThree() {
      final cubit = _cubit()
        ..addNode(type: 'Text', parentId: 'node_0')
        ..addNode(type: 'Text', parentId: 'node_0')
        ..addNode(type: 'Padding', parentId: 'node_0');
      return cubit;
    }

    test('a widget is added to the selection and taken out of it', () {
      final cubit = withThree()
        ..select('node_1')
        ..toggleSelect('node_2');

      expect(cubit.state.selectedIds, ['node_2', 'node_1']);
      expect(cubit.state.isMultiSelection, isTrue);

      cubit.toggleSelect('node_2');
      expect(cubit.state.selectedIds, ['node_1']);
      expect(cubit.state.isMultiSelection, isFalse);

      cubit.toggleSelect('node_1');
      expect(cubit.state.selectedId, isNull);
    });

    test('selecting one widget leaves the others', () {
      final cubit = withThree()
        ..select('node_1')
        ..toggleSelect('node_2')
        ..select('node_3');

      expect(cubit.state.selectedIds, ['node_3']);
    });

    test('they are all removed in one undo step', () {
      final cubit = withThree()
        ..select('node_1')
        ..toggleSelect('node_2');
      final steps = cubit.state.history.past.length;

      cubit.removeSelected();

      expect(cubit.state.document.root.children.map((c) => c.id), ['node_3']);
      expect(cubit.state.history.past.length, steps + 1);
      cubit.undo();
      expect(cubit.state.document.root.children, hasLength(3));
    });

    test('they are all duplicated', () {
      final cubit = withThree()
        ..select('node_1')
        ..toggleSelect('node_2')
        ..duplicateSelected();

      expect(cubit.state.document.root.children.map((c) => c.type), [
        'Text',
        'Text',
        'Text',
        'Text',
        'Padding',
      ]);
    });

    test('they are wrapped together', () {
      final cubit = withThree()
        ..select('node_1')
        ..toggleSelect('node_2');

      expect(cubit.canWrapSelection('Row'), isTrue);
      cubit.wrapSelected('Row');

      final row = cubit.state.document.root.children.first;
      expect(row.type, 'Row');
      expect(row.children.map((c) => c.id), ['node_1', 'node_2']);
      expect(cubit.state.isMultiSelection, isFalse);
    });

    test('a property is set on all of them, in one undo step', () {
      final cubit = withThree()
        ..select('node_1')
        ..toggleSelect('node_2');
      final steps = cubit.state.history.past.length;

      cubit.updatePropOfSelection('text', 'Same');

      for (final id in ['node_1', 'node_2']) {
        expect(cubit.state.document.root.find(id)?.props['text'], 'Same');
      }
      expect(cubit.state.history.past.length, steps + 1);
      expect(cubit.state.selectedIds, hasLength(2));
      cubit.undo();
      expect(cubit.state.document.root.find('node_1')?.props['text'], isNull);
    });

    test('widgets of different types change only the main one', () {
      final cubit = withThree()
        ..select('node_1')
        ..toggleSelect('node_3');

      cubit.updatePropOfSelection('text', 'Only');

      expect(cubit.state.document.root.find('node_3')?.props['text'], isNull);
    });

    test('a widget that is gone leaves the selection when undone', () {
      final cubit = withThree()
        ..select('node_1')
        ..toggleSelect('node_2');

      cubit.undo();

      expect(cubit.state.selectedIds, isNot(contains('node_3')));
      expect(
        cubit.state.selectedIds.every(
          (id) => cubit.state.document.root.find(id) != null,
        ),
        isTrue,
      );
    });
  });
}
