import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/edit_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_validator.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/tree_editor.dart';

void main() {
  final registry = WidgetRegistry(builtinDefinitions);
  final editor = TreeEditor(registry);

  // Scaffold(node_0) > Column(node_1) > [Row(node_2), Card(node_3)]
  const screen = EditorDocument(
    name: 'screen',
    root: WidgetNode(
      id: 'node_0',
      type: 'Scaffold',
      children: [
        WidgetNode(
          id: 'node_1',
          type: 'Column',
          children: [
            WidgetNode(id: 'node_2', type: 'Row'),
            WidgetNode(id: 'node_3', type: 'Card'),
          ],
        ),
      ],
    ),
  );

  // Column(node_0) with no Material ancestor.
  const bare = EditorDocument(
    name: 'bare',
    root: WidgetNode(id: 'node_0', type: 'Column'),
  );

  TreeFailureReason? reasonOf(Either<Failure, EditResult> result) =>
      result.fold((f) => f is TreeFailure ? f.reason : null, (_) => null);

  Either<Failure, EditResult> add(
    EditorDocument document,
    String type,
    String parent,
  ) => editor.add(document, type: type, parentId: parent);

  test('a screen widget cannot be nested', () {
    expect(
      reasonOf(add(screen, 'Scaffold', 'node_1')),
      TreeFailureReason.parentNotAllowed,
    );
  });

  test('a widget that fills the width gets an Expanded in a Row', () {
    final result = add(
      screen,
      'TextField',
      'node_2',
    ).getOrElse(() => throw StateError('expected success'));
    final row = result.document.root.find('node_2');

    expect(row?.children.single.type, 'Expanded');
    expect(row?.children.single.children.single.type, 'TextField');
    // The new widget is the one selected, not its wrapper.
    expect(result.nodeId, row?.children.single.children.single.id);
  });

  test('where no wrapper helps, a width-filling widget is refused', () {
    final withWrap = add(
      screen,
      'Wrap',
      'node_1',
    ).getOrElse(() => throw StateError('expected success'));

    expect(
      reasonOf(add(withWrap.document, 'TextField', withWrap.nodeId)),
      TreeFailureReason.parentNotAllowed,
    );
    expect(add(screen, 'TextField', 'node_1').isRight(), isTrue);
  });

  test('a Material widget needs a Scaffold or a Card above it', () {
    expect(
      reasonOf(add(bare, 'TextField', 'node_0')),
      TreeFailureReason.ancestorRequired,
    );
    expect(add(screen, 'ListTile', 'node_1').isRight(), isTrue);
    expect(add(screen, 'ListTile', 'node_3').isRight(), isTrue);
  });

  test('a scrolling widget in a Column is wrapped in an Expanded', () {
    final result = add(
      screen,
      'ListView',
      'node_1',
    ).getOrElse(() => throw StateError('expected success'));
    final column = result.document.root.find('node_1');

    expect(column?.children.last.type, 'Expanded');
    expect(column?.children.last.children.single.type, 'ListView');
    expect(result.nodeId, column?.children.last.children.single.id);
  });

  test('a scrolling widget fits directly in a bounded parent only', () {
    final withBox = add(
      screen,
      'SizedBox',
      'node_1',
    ).getOrElse(() => throw StateError('expected success'));

    expect(add(withBox.document, 'ListView', withBox.nodeId).isRight(), isTrue);

    final withList = add(
      withBox.document,
      'ListView',
      withBox.nodeId,
    ).getOrElse(() => throw StateError('expected success'));
    expect(
      reasonOf(add(withList.document, 'ListView', withList.nodeId)),
      TreeFailureReason.parentNotAllowed,
    );
  });

  test('moving a widget into a Row wraps it when it needs to', () {
    final withField = add(
      screen,
      'TextField',
      'node_1',
    ).getOrElse(() => throw StateError('expected success'));

    final moved = editor
        .move(withField.document, nodeId: withField.nodeId, parentId: 'node_2')
        .getOrElse(() => throw StateError('expected success'));

    expect(
      moved.document.root.find('node_2')?.children.single.type,
      'Expanded',
    );
  });

  group('documents read from disk', () {
    final validator = DocumentValidator(registry);

    DocumentFailureReason? reasonFor(EditorDocument document) => validator
        .validate(document)
        .fold((f) => f is DocumentFailure ? f.reason : null, (_) => null);

    test('a nested screen widget is rejected', () {
      final nested = screen.copyWith(
        root: screen.root.copyWith(
          children: [
            const WidgetNode(
              id: 'node_9',
              type: 'Column',
              children: [WidgetNode(id: 'node_8', type: 'Scaffold')],
            ),
          ],
        ),
      );

      expect(reasonFor(nested), DocumentFailureReason.invalidStructure);
    });

    test('a root that needs a parent is rejected', () {
      const orphan = EditorDocument(
        name: 'orphan',
        root: WidgetNode(id: 'node_0', type: 'AppBar'),
      );

      expect(reasonFor(orphan), DocumentFailureReason.invalidStructure);
    });

    test('a Material widget outside any Scaffold is rejected', () {
      const text = EditorDocument(
        name: 'field',
        root: WidgetNode(
          id: 'node_0',
          type: 'Column',
          children: [WidgetNode(id: 'node_1', type: 'TextField')],
        ),
      );

      expect(reasonFor(text), DocumentFailureReason.invalidStructure);
    });
  });
}
