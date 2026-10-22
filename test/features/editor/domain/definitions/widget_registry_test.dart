import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';

void main() {
  final registry = WidgetRegistry(builtinDefinitions);

  test('registers the core widgets, grouped by category', () {
    final types = registry.all.map((d) => d.type);

    expect(
      types,
      containsAll(['Scaffold', 'Row', 'Column', 'Stack', 'Text', 'Image']),
    );
    expect(registry.all.map((d) => d.category).toSet(), hasLength(13));
  });

  test('rejects a duplicate registration', () {
    expect(
      () => registry.register(registry.definitionFor('Text')),
      throwsStateError,
    );
  });

  test('generates code for a nested tree using schema defaults', () {
    const tree = WidgetNode(
      id: 'p',
      type: 'Padding',
      children: [
        WidgetNode(
          id: 't',
          type: 'Text',
          props: {'text': "it's", 'color': 0xFF112233},
        ),
      ],
    );

    expect(
      registry.generateCode(tree),
      'Padding(padding: EdgeInsets.all(8.0), child: '
      "Text('it\\'s', style: TextStyle(fontSize: 14.0, "
      'color: Color(0xFF112233))))',
    );
  });

  test('ignores a stored value of the wrong type', () {
    const node = WidgetNode(id: 't', type: 'Text', props: {'fontSize': 'big'});

    expect(registry.generateCode(node), contains('fontSize: 14.0'));
  });

  test('throws on an unknown widget type', () {
    expect(() => registry.definitionFor('Nope'), throwsStateError);
  });
}
