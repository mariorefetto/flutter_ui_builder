import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/services/document_json_codec.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_screen.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';

void main() {
  const codec = DocumentJsonCodec();

  const document = EditorDocument(
    name: 'sample',
    root: WidgetNode(
      id: 'node_0',
      type: 'Column',
      props: {'mainAxisAlignment': 'center'},
      children: [
        WidgetNode(
          id: 'node_1',
          type: 'Padding',
          props: {
            'padding': [1.0, 2.0, 3.0, 4.0],
          },
        ),
      ],
    ),
  );

  DocumentFailureReason? reasonOf(String text) {
    try {
      codec.decode(text);
    } on InvalidDocumentException catch (e) {
      return e.reason;
    }
    return null;
  }

  test('round trips a document', () {
    expect(codec.decode(codec.encode(document)), document);
  });

  test('writes indented text with sorted keys and a final newline', () {
    final text = codec.encode(document);

    expect(text, endsWith('}\n'));
    expect(text.indexOf('"children"'), lessThan(text.indexOf('"id"')));
    expect(text.indexOf('"name"'), lessThan(text.indexOf('"root"')));
    expect(text, contains('\n  "'));
  });

  test('saving twice gives identical text', () {
    expect(codec.encode(document), codec.encode(document));
  });

  test('stores the schema version', () {
    expect(codec.encode(document), contains('"schemaVersion": 2'));
  });

  test('rejects text that is not a project', () {
    expect(reasonOf('not json'), DocumentFailureReason.invalidFormat);
    expect(reasonOf('[1, 2]'), DocumentFailureReason.invalidFormat);
    expect(reasonOf('{"name": 3}'), DocumentFailureReason.invalidFormat);
  });

  test('rejects a project from a newer version', () {
    expect(
      reasonOf('{"schemaVersion": 99, "name": "a", "root": {}}'),
      DocumentFailureReason.unsupportedVersion,
    );
  });

  test('screens and components survive a save and an open', () {
    const project = EditorDocument(
      name: 'Home',
      root: WidgetNode(id: 'node_0', type: 'Column'),
      activeIndex: 1,
      component: true,
      screens: [
        ProjectScreen(
          name: 'Start',
          root: WidgetNode(id: 'node_0', type: 'Column'),
        ),
        ProjectScreen(
          name: 'Badge',
          component: true,
          root: WidgetNode(id: 'node_0', type: 'Container'),
        ),
      ],
    );

    final decoded = codec.decode(codec.encode(project));

    expect(decoded, project);
  });

  test('a file from before components reads as a screen', () {
    final decoded = codec.decode(
      '{"name":"Old","root":{"id":"node_0","type":"Column"},"schemaVersion":1}',
    );

    expect(decoded.component, isFalse);
    expect(decoded.screens, isEmpty);
  });
}
