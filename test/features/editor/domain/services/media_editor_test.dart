import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/media_asset.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/media_editor.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';

void main() {
  const editor = MediaEditor();
  const project = EditorDocument(
    name: 'Home',
    root: WidgetNode(id: 'node_0', type: 'Column'),
  );

  test('a file becomes a picture called assets/<its name>', () {
    final doc = editor.add(project, ['/home/me/logo.png']);

    expect(doc.assets, const [
      MediaAsset(name: 'assets/logo.png', sourcePath: '/home/me/logo.png'),
    ]);
  });

  test('two files with the same name get names of their own', () {
    final doc = editor.add(project, [
      '/a/logo.png',
      '/b/logo.png',
      '/c/logo.png',
    ]);

    expect(doc.assets.map((a) => a.name), [
      'assets/logo.png',
      'assets/logo_2.png',
      'assets/logo_3.png',
    ]);
  });

  test('the same file is not added twice', () {
    final once = editor.add(project, ['/a/logo.png']);
    final twice = editor.add(once, ['/a/logo.png']);

    expect(twice.assets, hasLength(1));
  });

  test('a picture can be removed, and the others stay', () {
    final doc = editor.add(project, ['/a/one.png', '/a/two.png']);

    final removed = editor.remove(doc, 'assets/one.png');

    expect(removed.assets.map((a) => a.name), ['assets/two.png']);
  });

  test('the text for pubspec.yaml lists the pictures in order', () {
    final doc = editor.add(project, ['/a/b.png', '/a/a.png']);

    expect(
      pubspecAssets(doc),
      'flutter:\n  assets:\n    - assets/a.png\n    - assets/b.png',
    );
    expect(pubspecAssets(project), isEmpty);
  });

  test('opening another screen keeps the pictures', () {
    final withPicture = editor.add(project, ['/a/logo.png']);
    final other = const ScreenEditor()
        .add(withPicture, 'Settings')
        .getOrElse(() => throw StateError('add failed'));

    expect(other.assets, withPicture.assets);
  });
}
