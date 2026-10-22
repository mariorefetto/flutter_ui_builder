import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/document_reconciler.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';

void main() {
  const reconciler = DocumentReconciler();

  const previous = EditorDocument(
    name: 'untitled',
    root: WidgetNode(
      id: 'node_0',
      type: 'Column',
      children: [
        WidgetNode(id: 'node_4', type: 'Text'),
        WidgetNode(id: 'node_7', type: 'Image'),
      ],
    ),
  );

  ImportResult imported(
    WidgetNode root, {
    String name = 'Untitled',
    bool named = true,
  }) => ImportResult(
    document: EditorDocument(name: name, root: root),
    issues: const [],
    named: named,
  );

  test('widgets in the same place with the same type keep their ids', () {
    final result = reconciler.reconcile(
      previous,
      imported(
        const WidgetNode(
          id: 'node_0',
          type: 'Column',
          props: {'spacing': 4.0},
          children: [
            WidgetNode(id: 'node_1', type: 'Text', props: {'text': 'x'}),
            WidgetNode(id: 'node_2', type: 'Image'),
          ],
        ),
      ),
    );

    expect(result.root.id, 'node_0');
    expect(result.root.props, {'spacing': 4.0});
    expect(result.root.children.map((c) => c.id), ['node_4', 'node_7']);
    expect(result.root.children.first.props, {'text': 'x'});
  });

  test('a widget that is new or of another type gets a fresh id', () {
    final result = reconciler.reconcile(
      previous,
      imported(
        const WidgetNode(
          id: 'node_0',
          type: 'Column',
          children: [
            WidgetNode(id: 'node_1', type: 'Icon'),
            WidgetNode(id: 'node_2', type: 'Image'),
            WidgetNode(id: 'node_3', type: 'Text'),
          ],
        ),
      ),
    );
    final ids = result.root.children.map((c) => c.id).toList();

    expect(ids[1], 'node_7');
    expect(ids.toSet(), hasLength(3));
    // Fresh ids start above every id in use, so none clashes.
    expect(ids[0], isNot(anyOf('node_0', 'node_4', 'node_7')));
    expect(ids[2], isNot(anyOf('node_0', 'node_4', 'node_7')));
  });

  test('a different root type renews the ids below it', () {
    final result = reconciler.reconcile(
      previous,
      imported(
        const WidgetNode(
          id: 'node_0',
          type: 'Row',
          children: [WidgetNode(id: 'node_1', type: 'Text')],
        ),
      ),
    );

    expect(result.root.id, isNot('node_0'));
    expect(result.root.children.single.id, isNot('node_4'));
  });

  test('the name follows the class unless it only differs in case', () {
    const root = WidgetNode(id: 'node_0', type: 'Column');

    expect(reconciler.reconcile(previous, imported(root)).name, 'untitled');
    expect(
      reconciler.reconcile(previous, imported(root, name: 'Home')).name,
      'Home',
    );
    expect(
      reconciler
          .reconcile(previous, imported(root, name: 'Imported', named: false))
          .name,
      'untitled',
    );
  });
}
