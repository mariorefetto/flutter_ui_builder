import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/builtin_previews.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_registry.dart';

void main() {
  final registry = WidgetRegistry(builtinDefinitions);
  final previews = PreviewRegistry(
    registry: registry,
    previews: builtinPreviews,
  );

  test('every built-in definition has a preview', () {
    expect(
      () => PreviewRegistry(registry: registry, previews: const {}),
      throwsStateError,
    );
  });

  testWidgets('draws a nested tree from the model', (tester) async {
    const tree = WidgetNode(
      id: 'c',
      type: 'Column',
      children: [
        WidgetNode(id: 't', type: 'Text', props: {'text': 'Hello'}),
        WidgetNode(id: 'i', type: 'Image'),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(builder: (context) => previews.build(context, tree)),
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
  });
}
