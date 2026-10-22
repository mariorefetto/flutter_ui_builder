import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_validator.dart';

void main() {
  final validator = DocumentValidator(WidgetRegistry(builtinDefinitions));

  EditorDocument documentOf(WidgetNode root) =>
      EditorDocument(name: 'test', root: root);

  DocumentFailureReason? reasonOf(WidgetNode root) => validator
      .validate(documentOf(root))
      .fold((f) => f is DocumentFailure ? f.reason : null, (_) => null);

  test('accepts a valid tree', () {
    expect(
      validator
          .validate(
            documentOf(
              const WidgetNode(
                id: 'a',
                type: 'Column',
                children: [WidgetNode(id: 'b', type: 'Text')],
              ),
            ),
          )
          .isRight(),
      isTrue,
    );
  });

  test('rejects an unregistered widget type', () {
    expect(
      reasonOf(const WidgetNode(id: 'a', type: 'Nope')),
      DocumentFailureReason.unknownWidget,
    );
  });

  test('rejects duplicate ids', () {
    expect(
      reasonOf(
        const WidgetNode(
          id: 'a',
          type: 'Column',
          children: [WidgetNode(id: 'a', type: 'Text')],
        ),
      ),
      DocumentFailureReason.invalidStructure,
    );
  });

  test('rejects children that break the ChildPolicy', () {
    expect(
      reasonOf(
        const WidgetNode(
          id: 'a',
          type: 'Text',
          children: [WidgetNode(id: 'b', type: 'Text')],
        ),
      ),
      DocumentFailureReason.invalidStructure,
    );
    expect(
      reasonOf(
        const WidgetNode(
          id: 'a',
          type: 'Padding',
          children: [
            WidgetNode(id: 'b', type: 'Text'),
            WidgetNode(id: 'c', type: 'Text'),
          ],
        ),
      ),
      DocumentFailureReason.invalidStructure,
    );
  });
}
