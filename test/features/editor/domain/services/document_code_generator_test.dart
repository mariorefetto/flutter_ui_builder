import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/data/services/dart_style_code_formatter.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_file.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/identifier_names.dart';

void main() {
  final generator = DocumentCodeGenerator(
    WidgetRegistry(builtinDefinitions),
    const DartStyleCodeFormatter(),
  );

  const document = EditorDocument(
    name: 'my home screen',
    root: WidgetNode(
      id: 'node_0',
      type: 'Column',
      children: [
        WidgetNode(
          id: 'node_1',
          type: 'Container',
          props: {
            'width': 120,
            'color': 0xFF2196F3,
            'alignment': 'center',
            'margin': [4.0, 4.0, 4.0, 4.0],
          },
          children: [
            WidgetNode(id: 'node_2', type: 'Text', props: {'text': r"it's $5"}),
          ],
        ),
        WidgetNode(
          id: 'node_3',
          type: 'Row',
          children: [
            WidgetNode(id: 'node_4', type: 'Image', props: {'url': 'a.png'}),
            WidgetNode(
              id: 'node_5',
              type: 'Padding',
              props: {
                'padding': [1.0, 2.0, 3.0, 4.0],
              },
              children: [WidgetNode(id: 'node_6', type: 'Stack')],
            ),
          ],
        ),
      ],
    ),
  );

  GeneratedFile generate() => generator
      .generate(document)
      .getOrElse(() => throw StateError('expected a generated file'));

  test('names the file and class after the document', () {
    final file = generate();

    expect(file.fileName, 'my_home_screen_view.g.dart');
    expect(file.content, contains('class MyHomeScreenView'));
  });

  test('marks the file as generated', () {
    expect(generate().content.split('\n').first, contains(generatedFileMarker));
  });

  test('output is formatted and escapes strings', () {
    final content = generate().content;

    expect(content, contains(r"Text('it\'s \$5'"));
    expect(content, endsWith('}\n'));
  });

  test('output is valid Dart that analyzes without errors', () async {
    // Written next to the sources so the analyzer resolves package imports.
    final file = File('lib/tmp_generated_check.dart')
      ..writeAsStringSync(generate().content);
    addTearDown(file.deleteSync);

    final result = await Process.run('dart', [
      'analyze',
      '--fatal-infos',
      file.path,
    ]);

    expect(result.exitCode, 0, reason: '${result.stdout}');
  }, timeout: const Timeout(Duration(minutes: 2)));

  group('identifier names', () {
    test('pascalCase and snakeCase', () {
      expect(pascalCase('my home-screen'), 'MyHomeScreen');
      expect(snakeCase('My Home-Screen'), 'my_home_screen');
    });

    test('fall back for names that are not identifiers', () {
      expect(pascalCase('***'), 'Generated');
      expect(pascalCase('2fast'), 'Generated2fast');
      expect(snakeCase('2fast'), 'generated_2fast');
    });
  });
}
