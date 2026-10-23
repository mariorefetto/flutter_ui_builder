import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_screen.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';

void main() {
  const editor = ScreenEditor();

  WidgetNode button(String id, String? target) => WidgetNode(
    id: id,
    type: 'ElevatedButton',
    props: {'navigateTo': ?target},
  );

  EditorDocument project() => EditorDocument(
    name: 'Home',
    root: WidgetNode(
      id: 'node_0',
      type: 'Column',
      children: [button('node_1', 'Settings')],
    ),
  );

  EditorDocument withSettings() => editor
      .add(project(), 'Settings')
      .getOrElse(() => throw StateError('add failed'));

  DocumentFailureReason? reasonOf(Object result) => (result as dynamic).fold(
    (f) => f is DocumentFailure ? f.reason : null,
    (_) => null,
  );

  test('a project starts with one screen', () {
    expect(editor.namesOf(project()), ['Home']);
  });

  test('a new screen is added last and opened', () {
    final added = withSettings();

    expect(editor.namesOf(added), ['Home', 'Settings']);
    expect(added.name, 'Settings');
    expect(added.root.type, 'Scaffold');
    expect(added.activeIndex, 1);
    expect(added.screens.single.name, 'Home');
  });

  test('a name must be new, and not write the same class as another', () {
    expect(
      reasonOf(editor.add(project(), '  ')),
      DocumentFailureReason.emptyName,
    );
    expect(
      reasonOf(editor.add(project(), 'home')),
      DocumentFailureReason.duplicateScreenName,
    );
    expect(
      reasonOf(editor.add(project(), 'Ho me')),
      isNull,
      reason: 'a different class name is allowed',
    );
  });

  test('opening a screen swaps it with the open one', () {
    final reopened = editor
        .open(withSettings(), 'Home')
        .getOrElse(() => throw StateError('open failed'));

    expect(reopened.name, 'Home');
    expect(reopened.root.id, 'node_0');
    expect(editor.namesOf(reopened), ['Home', 'Settings']);
    expect(reopened.activeIndex, 0);
    expect(
      reasonOf(editor.open(project(), 'Nope')),
      DocumentFailureReason.unknownScreen,
    );
  });

  test('renaming a screen follows the widgets that open it', () {
    final renamed = editor
        .rename(withSettings(), 'Settings', 'Preferences')
        .getOrElse(() => throw StateError('rename failed'));
    final home = editor.rootOf(renamed, 'Home');

    expect(editor.namesOf(renamed), ['Home', 'Preferences']);
    expect(home?.children.single.props['navigateTo'], 'Preferences');
  });

  test('a screen cannot be renamed to another one', () {
    expect(
      reasonOf(editor.rename(withSettings(), 'Settings', 'Home')),
      DocumentFailureReason.duplicateScreenName,
    );
  });

  test('deleting a screen clears the widgets that opened it', () {
    final deleted = editor
        .delete(withSettings(), 'Settings')
        .getOrElse(() => throw StateError('delete failed'));

    expect(editor.namesOf(deleted), ['Home']);
    expect(deleted.name, 'Home');
    expect(
      deleted.root.children.single.props.containsKey('navigateTo'),
      isFalse,
    );
  });

  test('the last screen cannot be deleted', () {
    expect(
      reasonOf(editor.delete(project(), 'Home')),
      DocumentFailureReason.lastScreen,
    );
  });

  test('deleting a screen before the open one keeps the open one', () {
    final doc = editor
        .add(withSettings(), 'Profile')
        .getOrElse(() => throw StateError('add failed'));
    final deleted = editor
        .delete(doc, 'Home')
        .getOrElse(() => throw StateError('delete failed'));

    expect(deleted.name, 'Profile');
    expect(editor.namesOf(deleted), ['Settings', 'Profile']);
    expect(deleted.activeIndex, 1);
  });

  test('a duplicate gets a name of its own and is opened', () {
    final first = editor
        .duplicate(project(), 'Home')
        .getOrElse(() => throw StateError('duplicate failed'));
    final second = editor
        .duplicate(first, 'Home')
        .getOrElse(() => throw StateError('duplicate failed'));

    expect(editor.namesOf(second), ['Home', 'Home copy', 'Home copy 2']);
    expect(second.name, 'Home copy 2');
  });

  test('a screen can be made the first, the one the app starts on', () {
    final moved = editor
        .makeHome(withSettings(), 'Settings')
        .getOrElse(() => throw StateError('move failed'));

    expect(editor.namesOf(moved), ['Settings', 'Home']);
    expect(moved.name, 'Settings', reason: 'the open screen stays open');
    expect(moved.activeIndex, 0);
  });

  group('include', () {
    ProjectScreen entry(
      String name, {
      bool component = false,
      String? target,
    }) => ProjectScreen(
      name: name,
      component: component,
      root: WidgetNode(
        id: 'node_0',
        type: 'Column',
        children: [
          if (target != null)
            WidgetNode(
              id: 'node_1',
              type: 'ElevatedButton',
              props: {'navigateTo': target},
            ),
        ],
      ),
    );

    test('screens and components are added after the others', () {
      final doc = editor.include(project(), [
        entry('Profile'),
        entry('Badge', component: true),
      ]);

      expect(editor.namesOf(doc), ['Home', 'Profile', 'Badge']);
      expect(editor.componentsOf(doc), ['Badge']);
      expect(doc.name, 'Home', reason: 'the open screen stays open');
    });

    test('a name that is taken gets a number', () {
      final doc = editor.include(project(), [entry('home'), entry('Home')]);

      expect(editor.namesOf(doc), ['Home', 'home 2', 'Home 3']);
    });

    test('a widget that names a screen by its class is pointed at it', () {
      final doc = editor.include(project(), [
        entry('my screen'),
        entry('Other', target: 'MyScreen'),
      ]);

      expect(
        editor.rootOf(doc, 'Other')?.children.single.props['navigateTo'],
        'my screen',
      );
    });
  });
}
