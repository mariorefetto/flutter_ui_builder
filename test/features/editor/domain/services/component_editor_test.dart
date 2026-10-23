import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/component_rules.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_validator.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';

void main() {
  const editor = ScreenEditor();
  final registry = WidgetRegistry(builtinDefinitions);

  bool canBeRoot(String type) => canBeComponentRoot(registry, type);

  EditorDocument project() => const EditorDocument(
    name: 'Home',
    root: WidgetNode(
      id: 'node_0',
      type: 'Column',
      children: [
        WidgetNode(
          id: 'node_1',
          type: 'Card',
          children: [
            WidgetNode(id: 'node_2', type: 'Text', props: {'text': 'Hi'}),
          ],
        ),
        WidgetNode(id: 'node_3', type: 'Text'),
      ],
    ),
  );

  EditorDocument extracted([String name = 'Greeting']) => editor
      .extract(project(), 'node_1', name, canBeRoot: canBeRoot)
      .getOrElse(() => throw StateError('extract failed'));

  DocumentFailureReason? reasonOf(Object result) => (result as dynamic).fold(
    (f) => f is DocumentFailure ? f.reason : null,
    (_) => null,
  );

  test('a widget becomes a component and a use of it takes its place', () {
    final doc = extracted();

    expect(editor.componentsOf(doc), ['Greeting']);
    expect(editor.screensOf(doc), ['Home']);
    expect(doc.name, 'Home', reason: 'the screen stays open');
    final use = doc.root.find('node_1');
    expect(use?.type, 'Component');
    expect(use?.props['component'], 'Greeting');
    final component = editor.rootOf(doc, 'Greeting');
    expect(component?.type, 'Card');
    expect(component?.children.single.props['text'], 'Hi');
    expect(component?.id, 'node_0', reason: 'ids start over in the component');
  });

  test('a widget that needs its parent cannot be made a component', () {
    expect(canBeRoot('Expanded'), isFalse);
    expect(canBeRoot('Scaffold'), isFalse);
    expect(canBeRoot('AppBar'), isFalse);
    expect(canBeRoot('Card'), isTrue);
    expect(
      reasonOf(
        editor.extract(
          const EditorDocument(
            name: 'Home',
            root: WidgetNode(
              id: 'node_0',
              type: 'Row',
              children: [WidgetNode(id: 'node_1', type: 'Spacer')],
            ),
          ),
          'node_1',
          'Gap',
          canBeRoot: canBeRoot,
        ),
      ),
      DocumentFailureReason.invalidStructure,
    );
  });

  test('a component name must be new', () {
    expect(
      reasonOf(
        editor.extract(project(), 'node_1', 'home', canBeRoot: canBeRoot),
      ),
      DocumentFailureReason.duplicateScreenName,
    );
  });

  test('a new component is a tab of its own and is opened', () {
    final doc = editor
        .addComponent(project(), 'Badge')
        .getOrElse(() => throw StateError('add failed'));

    expect(doc.component, isTrue);
    expect(doc.name, 'Badge');
    expect(editor.componentsOf(doc), ['Badge']);
    expect(editor.screensOf(doc), ['Home']);
  });

  test('opening a component and going back keeps what each one is', () {
    final opened = editor
        .open(extracted(), 'Greeting')
        .getOrElse(() => throw StateError('open failed'));
    final back = editor
        .open(opened, 'Home')
        .getOrElse(() => throw StateError('open failed'));

    expect(opened.component, isTrue);
    expect(back.component, isFalse);
    expect(editor.componentsOf(back), ['Greeting']);
  });

  test('renaming a component renames its uses', () {
    final renamed = editor
        .rename(extracted(), 'Greeting', 'Welcome')
        .getOrElse(() => throw StateError('rename failed'));

    expect(renamed.root.find('node_1')?.props['component'], 'Welcome');
    expect(editor.componentsOf(renamed), ['Welcome']);
  });

  test('deleting a component leaves its content where it was used', () {
    final deleted = editor
        .delete(extracted(), 'Greeting')
        .getOrElse(() => throw StateError('delete failed'));

    expect(editor.componentsOf(deleted), isEmpty);
    // The copy takes the place of the use, with ids that are new to the tree.
    final inlined = deleted.root.children.first;
    expect(inlined.type, 'Card');
    expect(inlined.children.single.props['text'], 'Hi');
  });

  test('a use can be detached into a copy that can be edited alone', () {
    final doc = extracted();

    final detached = editor
        .detach(doc, 'node_1')
        .getOrElse(() => throw StateError('detach failed'));

    expect(detached.root.children.first.type, 'Card');
    expect(detached.root.componentTargets(), isEmpty);
    expect(
      detached.root.preorderIds().toSet(),
      hasLength(detached.root.preorderIds().length),
      reason: 'ids stay unique',
    );
    expect(editor.componentsOf(detached), ['Greeting']);
  });

  test(
    'several uses are all given ids of their own when detached by delete',
    () {
      final doc = editor
          .open(extracted(), 'Home')
          .getOrElse(() => throw StateError('open failed'));
      final twice = doc.copyWith(
        root: doc.root.copyWith(
          children: [
            ...doc.root.children,
            const WidgetNode(
              id: 'node_9',
              type: 'Component',
              props: {'component': 'Greeting'},
            ),
          ],
        ),
      );

      final deleted = editor
          .delete(twice, 'Greeting')
          .getOrElse(() => throw StateError('delete failed'));

      final ids = deleted.root.preorderIds();
      expect(ids.toSet(), hasLength(ids.length));
      expect(deleted.root.countNodes(), greaterThan(twice.root.countNodes()));
    },
  );

  test('a component that uses another is found, directly or not', () {
    var doc = extracted('Outer');
    doc = editor
        .addComponent(doc, 'Inner')
        .getOrElse(() => throw StateError('add failed'));
    // Inner holds a use of Outer.
    doc = doc.copyWith(
      root: const WidgetNode(
        id: 'node_0',
        type: 'Column',
        children: [
          WidgetNode(
            id: 'node_1',
            type: 'Component',
            props: {'component': 'Outer'},
          ),
        ],
      ),
    );

    expect(editor.usesComponent(doc, 'Inner', 'Outer'), isTrue);
    expect(editor.usesComponent(doc, 'Outer', 'Inner'), isFalse);
  });

  test('a project with components passes validation', () {
    final validator = DocumentValidator(registry);

    expect(validator.validate(extracted()).isRight(), isTrue);
  });

  test('a component whose root needs a Material ancestor is still valid', () {
    final validator = DocumentValidator(registry);
    // A ListTile needs a Material ancestor, which the screen it is used in
    // gives it, not the component itself.
    final withTile = editor
        .addComponent(project(), 'Tile')
        .getOrElse(() => throw StateError('add failed'))
        .copyWith(
          root: const WidgetNode(id: 'node_0', type: 'ListTile'),
        );

    expect(validator.validate(withTile).isRight(), isTrue);
  });
}
