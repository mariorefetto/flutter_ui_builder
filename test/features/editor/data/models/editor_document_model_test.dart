import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/data/models/editor_document_model.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';

void main() {
  const document = EditorDocument(
    name: 'sample',
    root: WidgetNode(
      id: 'root',
      type: 'Column',
      children: [
        WidgetNode(id: 'text', type: 'Text', props: {'text': 'Hello'}),
      ],
    ),
  );

  test('entity survives a model and JSON round trip', () {
    final json = EditorDocumentModel.fromEntity(document).toJson();
    final restored = EditorDocumentModel.fromJson(json).toEntity();

    expect(restored, document);
  });

  test('JSON contains the schema version', () {
    final json = EditorDocumentModel.fromEntity(document).toJson();

    expect(json['schemaVersion'], currentSchemaVersion);
  });

  test('a widget name survives the JSON and an unnamed widget omits it', () {
    const named = EditorDocument(
      name: 'sample',
      root: WidgetNode(
        id: 'root',
        type: 'Column',
        label: 'Page',
        children: [WidgetNode(id: 'a', type: 'Text')],
      ),
    );
    final json = EditorDocumentModel.fromEntity(named).toJson();
    final root = json['root'] as Map<String, dynamic>;

    expect(root['label'], 'Page');
    expect(
      (root['children'] as List<dynamic>).first as Map<String, dynamic>,
      isNot(contains('label')),
    );
    expect(EditorDocumentModel.fromJson(json).toEntity(), named);
  });
}
