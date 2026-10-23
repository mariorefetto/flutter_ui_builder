import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/edit_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/tree_editor.dart';

void main() {
  final editor = TreeEditor(WidgetRegistry(builtinDefinitions));

  // Column(node_0) > [Padding(node_1) > Text(node_2), Text(node_3)]
  const document = EditorDocument(
    name: 'test',
    root: WidgetNode(
      id: 'node_0',
      type: 'Column',
      children: [
        WidgetNode(
          id: 'node_1',
          type: 'Padding',
          children: [WidgetNode(id: 'node_2', type: 'Text')],
        ),
        WidgetNode(id: 'node_3', type: 'Text'),
      ],
    ),
  );

  TreeFailureReason? reasonOf(Either<Failure, EditResult> result) =>
      result.fold((f) => f is TreeFailure ? f.reason : null, (_) => null);

  EditResult success(Either<Failure, EditResult> result) =>
      result.getOrElse(() => throw StateError('expected success'));

  group('add', () {
    test('appends with a fresh id', () {
      final result = success(
        editor.add(document, type: 'Text', parentId: 'node_0'),
      );

      expect(result.nodeId, 'node_4');
      expect(result.document.root.children.last.id, 'node_4');
    });

    test('inserts at an index', () {
      final result = success(
        editor.add(document, type: 'Row', parentId: 'node_0', index: 0),
      );

      expect(result.document.root.children.first.type, 'Row');
    });

    test('refuses children under a leaf widget', () {
      expect(
        reasonOf(editor.add(document, type: 'Text', parentId: 'node_3')),
        TreeFailureReason.childNotAllowed,
      );
    });

    test('refuses a second child under a single-child widget', () {
      expect(
        reasonOf(editor.add(document, type: 'Text', parentId: 'node_1')),
        TreeFailureReason.parentFull,
      );
    });

    test('refuses an out of range index and unknown ids', () {
      expect(
        reasonOf(
          editor.add(document, type: 'Text', parentId: 'node_0', index: 3),
        ),
        TreeFailureReason.invalidIndex,
      );
      expect(
        reasonOf(editor.add(document, type: 'Text', parentId: 'x')),
        TreeFailureReason.unknownParent,
      );
      expect(
        reasonOf(editor.add(document, type: 'Nope', parentId: 'node_0')),
        TreeFailureReason.unknownType,
      );
    });
  });

  group('move', () {
    test('reorders inside the same parent', () {
      final result = success(
        editor.move(document, nodeId: 'node_3', parentId: 'node_0', index: 0),
      );

      expect(result.document.root.children.map((c) => c.id), [
        'node_3',
        'node_1',
      ]);
    });

    test('moves a node out of its container', () {
      final result = success(
        editor.move(document, nodeId: 'node_2', parentId: 'node_0', index: 0),
      );

      expect(result.document.root.children.map((c) => c.id), [
        'node_2',
        'node_1',
        'node_3',
      ]);
      expect(result.document.root.children[1].children, isEmpty);
    });

    test('refuses a second child in a full single-child container', () {
      expect(
        reasonOf(editor.move(document, nodeId: 'node_3', parentId: 'node_1')),
        TreeFailureReason.parentFull,
      );
    });

    test('refuses moving into its own subtree and moving the root', () {
      expect(
        reasonOf(editor.move(document, nodeId: 'node_1', parentId: 'node_2')),
        TreeFailureReason.cyclicMove,
      );
      expect(
        reasonOf(editor.move(document, nodeId: 'node_0', parentId: 'node_1')),
        TreeFailureReason.rootProtected,
      );
    });

    test('keeps the document unchanged when refused', () {
      editor.move(document, nodeId: 'node_3', parentId: 'node_2');

      expect(document.root.children, hasLength(2));
    });
  });

  group('remove', () {
    test('removes the subtree and points at the parent', () {
      final result = success(editor.remove(document, 'node_1'));

      expect(result.nodeId, 'node_0');
      expect(result.document.root.children.map((c) => c.id), ['node_3']);
    });

    test('refuses the root and unknown ids', () {
      expect(
        reasonOf(editor.remove(document, 'node_0')),
        TreeFailureReason.rootProtected,
      );
      expect(
        reasonOf(editor.remove(document, 'x')),
        TreeFailureReason.unknownNode,
      );
    });
  });

  group('updateProp', () {
    test('stores a valid value', () {
      final result = success(
        editor.updateProp(
          document,
          nodeId: 'node_3',
          name: 'text',
          value: 'Hi',
        ),
      );

      expect(result.document.root.children.last.props['text'], 'Hi');
      expect(document.root.children.last.props, isEmpty);
    });

    test('a null value restores the default', () {
      final withText = success(
        editor.updateProp(
          document,
          nodeId: 'node_3',
          name: 'text',
          value: 'Hi',
        ),
      ).document;
      final cleared = success(
        editor.updateProp(withText, nodeId: 'node_3', name: 'text'),
      );

      expect(cleared.document.root.children.last.props, isEmpty);
    });

    test('refuses a value of the wrong type and unknown names', () {
      expect(
        reasonOf(
          editor.updateProp(
            document,
            nodeId: 'node_3',
            name: 'fontSize',
            value: 'big',
          ),
        ),
        TreeFailureReason.invalidValue,
      );
      expect(
        reasonOf(
          editor.updateProp(document, nodeId: 'node_3', name: 'nope', value: 1),
        ),
        TreeFailureReason.unknownProp,
      );
      expect(
        reasonOf(editor.updateProp(document, nodeId: 'x', name: 'text')),
        TreeFailureReason.unknownNode,
      );
    });

    test('checks choice options and edge insets shape', () {
      expect(
        reasonOf(
          editor.updateProp(
            document,
            nodeId: 'node_0',
            name: 'mainAxisAlignment',
            value: 'diagonal',
          ),
        ),
        TreeFailureReason.invalidValue,
      );
      expect(
        editor
            .updateProp(
              document,
              nodeId: 'node_1',
              name: 'padding',
              value: [1.0, 2.0, 3.0, 4.0],
            )
            .isRight(),
        isTrue,
      );
    });
  });

  group('duplicate and paste', () {
    test('duplicate copies the subtree right after the original', () {
      final result = success(editor.duplicate(document, 'node_1'));
      final children = result.document.root.children;

      expect(children.map((c) => c.type), ['Padding', 'Padding', 'Text']);
      expect(children[1].children.single.type, 'Text');
    });

    test('a copy gets fresh ids that clash with nothing', () {
      final result = success(editor.duplicate(document, 'node_1'));
      final ids = <String>[];
      void collect(WidgetNode node) {
        ids.add(node.id);
        node.children.forEach(collect);
      }

      collect(result.document.root);

      expect(ids.toSet(), hasLength(ids.length));
      expect(result.nodeId, isNot('node_1'));
    });

    test('the root cannot be duplicated', () {
      expect(
        reasonOf(editor.duplicate(document, 'node_0')),
        TreeFailureReason.rootProtected,
      );
    });

    test('insertSubtree pastes a copy where the rules allow', () {
      const clip = WidgetNode(
        id: 'node_77',
        type: 'Padding',
        children: [WidgetNode(id: 'node_78', type: 'Text')],
      );

      final inside = success(
        editor.insertSubtree(document, clip, parentId: 'node_0', index: 0),
      );
      expect(inside.document.root.children.first.type, 'Padding');
      expect(inside.document.root.children.first.id, isNot('node_77'));

      expect(
        reasonOf(editor.insertSubtree(document, clip, parentId: 'node_3')),
        TreeFailureReason.childNotAllowed,
      );
    });
  });

  group('wrap and unwrap', () {
    test('wrap puts a new widget around a node in the same place', () {
      final result = success(
        editor.wrap(document, nodeId: 'node_3', wrapperType: 'Center'),
      );
      final wrapper = result.document.root.children.last;

      expect(wrapper.type, 'Center');
      expect(wrapper.children.single.id, 'node_3');
      expect(result.nodeId, wrapper.id);
    });

    test('wrapping the root makes the wrapper the root', () {
      final result = success(
        editor.wrap(document, nodeId: 'node_0', wrapperType: 'Padding'),
      );

      expect(result.document.root.type, 'Padding');
      expect(result.document.root.children.single.id, 'node_0');
    });

    test('wrap refuses a wrapper that cannot hold the node or fit there', () {
      expect(
        reasonOf(editor.wrap(document, nodeId: 'node_3', wrapperType: 'Text')),
        TreeFailureReason.childNotAllowed,
      );
      expect(
        reasonOf(
          editor.wrap(document, nodeId: 'node_3', wrapperType: 'Positioned'),
        ),
        TreeFailureReason.parentNotAllowed,
      );
    });

    test('unwrap replaces a node with its children', () {
      final result = success(editor.unwrap(document, 'node_1'));

      expect(result.document.root.children.map((c) => c.id), [
        'node_2',
        'node_3',
      ]);
      expect(result.nodeId, 'node_2');
    });

    test('unwrap needs children, and a root only takes a single one', () {
      expect(
        reasonOf(editor.unwrap(document, 'node_3')),
        TreeFailureReason.noChildren,
      );
      expect(
        reasonOf(editor.unwrap(document, 'node_0')),
        TreeFailureReason.rootProtected,
      );
    });

    test('wrap then unwrap gives back the original tree', () {
      final wrapped = success(
        editor.wrap(document, nodeId: 'node_1', wrapperType: 'Center'),
      );
      final restored = success(editor.unwrap(wrapped.document, wrapped.nodeId));

      expect(restored.document, document);
    });
  });

  group('relabel', () {
    test('names a node and a blank name clears it', () {
      final named = success(editor.relabel(document, 'node_3', '  Footer  '));

      expect(named.document.root.children.last.label, 'Footer');

      final cleared = success(editor.relabel(named.document, 'node_3', ' '));

      expect(cleared.document.root.children.last.label, isNull);
    });

    test('an unknown node is refused', () {
      expect(
        reasonOf(editor.relabel(document, 'x', 'a')),
        TreeFailureReason.unknownNode,
      );
    });

    test('copies keep the name', () {
      final named = success(editor.relabel(document, 'node_1', 'Card'));
      final copy = success(editor.duplicate(named.document, 'node_1'));

      expect(copy.document.root.children[1].label, 'Card');
    });
  });

  group('wrapAll', () {
    // Column > [Text 1, Text 2, Text 3, Padding > Text]
    const siblings = EditorDocument(
      name: 'test',
      root: WidgetNode(
        id: 'node_0',
        type: 'Column',
        children: [
          WidgetNode(id: 'node_1', type: 'Text'),
          WidgetNode(id: 'node_2', type: 'Text'),
          WidgetNode(id: 'node_3', type: 'Text'),
          WidgetNode(
            id: 'node_4',
            type: 'Padding',
            children: [WidgetNode(id: 'node_5', type: 'Text')],
          ),
        ],
      ),
    );

    EditorDocument wrapped(List<String> ids, [String type = 'Row']) => editor
        .wrapAll(siblings, nodeIds: ids, wrapperType: type)
        .getOrElse(() => throw StateError('wrap failed'))
        .document;

    test('the widgets go into one new widget where the first was', () {
      final doc = wrapped(['node_1', 'node_3']);

      final children = doc.root.children;
      expect(children.map((c) => c.type), ['Row', 'Text', 'Padding']);
      expect(children.first.children.map((c) => c.id), ['node_1', 'node_3']);
      expect(children[1].id, 'node_2');
    });

    test('they keep the order they had, not the order they were given', () {
      final doc = wrapped(['node_3', 'node_1']);

      expect(doc.root.children.first.children.map((c) => c.id), [
        'node_1',
        'node_3',
      ]);
    });

    test('the result points at the wrapper, which has a new id', () {
      final result = editor
          .wrapAll(siblings, nodeIds: ['node_1', 'node_2'], wrapperType: 'Row')
          .getOrElse(() => throw StateError('wrap failed'));

      expect(result.nodeId, 'node_6');
      expect(result.document.root.find('node_6')?.type, 'Row');
    });

    test('widgets of different parents are refused', () {
      expect(
        reasonOf(
          editor.wrapAll(
            siblings,
            nodeIds: ['node_1', 'node_5'],
            wrapperType: 'Row',
          ),
        ),
        TreeFailureReason.notSiblings,
      );
    });

    test('the root, an unknown widget and a type that cannot hold them', () {
      expect(
        reasonOf(
          editor.wrapAll(siblings, nodeIds: ['node_0'], wrapperType: 'Row'),
        ),
        TreeFailureReason.rootProtected,
      );
      expect(
        reasonOf(
          editor.wrapAll(siblings, nodeIds: ['nope'], wrapperType: 'Row'),
        ),
        TreeFailureReason.unknownNode,
      );
      expect(
        reasonOf(
          editor.wrapAll(
            siblings,
            nodeIds: ['node_1', 'node_2'],
            wrapperType: 'Padding',
          ),
        ),
        TreeFailureReason.parentFull,
      );
    });
  });
}
