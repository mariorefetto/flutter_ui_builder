import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/document_history.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';

EditorDocument _named(String name) => EditorDocument(
  name: name,
  root: const WidgetNode(id: 'r', type: 'Column'),
);

void main() {
  test('undo and redo walk through the recorded snapshots', () {
    final history = DocumentHistory(
      present: _named('a'),
    ).record(_named('b')).record(_named('c'));

    final undone = history.undo().undo();
    expect(undone.present.name, 'a');
    expect(undone.canUndo, isFalse);

    expect(undone.redo().present.name, 'b');
  });

  test('recording a new edit clears the redo stack', () {
    final history = DocumentHistory(
      present: _named('a'),
    ).record(_named('b')).undo().record(_named('c'));

    expect(history.canRedo, isFalse);
  });

  test('the undo stack is capped', () {
    var history = DocumentHistory(present: _named('0'));
    for (var i = 1; i <= maxHistoryLength + 5; i++) {
      history = history.record(_named('$i'));
    }

    expect(history.past, hasLength(maxHistoryLength));
  });
}
