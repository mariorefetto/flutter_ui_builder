import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/services/document_json_codec.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
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
    expect(codec.encode(document), contains('"schemaVersion": 1'));
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
}
