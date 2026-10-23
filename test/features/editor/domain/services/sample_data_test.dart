import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/data/services/analyzer_code_parser.dart';
import 'package:flutter_ui_builder/features/editor/data/services/dart_style_code_formatter.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_importer.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/sample_data.dart';

void main() {
  final registry = WidgetRegistry(builtinDefinitions);
  final generator = DocumentCodeGenerator(
    registry,
    const DartStyleCodeFormatter(),
  );

  const row = WidgetNode(
    id: 'node_2',
    type: 'ListTile',
    props: {'title': 'Item {n}', 'subtitle': 'Line {n}'},
  );

  EditorDocument document(String type, Map<String, Object?> props) =>
      EditorDocument(
        name: 'Home',
        root: WidgetNode(
          id: 'node_0',
          type: 'Scaffold',
          children: [
            WidgetNode(
              id: 'node_1',
              type: type,
              props: props,
              children: const [row],
            ),
          ],
        ),
      );

  // Without spaces and the trailing commas the formatter adds.
  String compact(EditorDocument doc) => generator
      .generate(doc)
      .getOrElse(() => throw StateError('generation failed'))
      .content
      .replaceAll(RegExp(r'\s+'), '')
      .replaceAll(',)', ')');

  group('the copies', () {
    test('the number replaces the token in every text', () {
      final copy = withSampleNumber(
        const WidgetNode(
          id: 'node_1',
          type: 'Column',
          children: [
            WidgetNode(id: 'node_2', type: 'Text', props: {'text': 'No. {n}'}),
          ],
        ),
        3,
      );

      expect(copy.children.single.props['text'], 'No. 3');
    });

    test('a count is asked for only with something to repeat', () {
      expect(
        sampleCountOf(const WidgetNode(id: 'a', type: 'ListView')),
        isNull,
      );
      expect(
        sampleCountOf(
          const WidgetNode(
            id: 'a',
            type: 'ListView',
            props: {'sampleCount': 4},
            children: [WidgetNode(id: 'b', type: 'Text')],
          ),
        ),
        4,
      );
      expect(
        sampleCountOf(
          const WidgetNode(
            id: 'a',
            type: 'ListView',
            props: {'sampleCount': 0},
            children: [WidgetNode(id: 'b', type: 'Text')],
          ),
        ),
        isNull,
      );
      expect(
        sampleCountOf(
          const WidgetNode(
            id: 'a',
            type: 'ListView',
            props: {'sampleCount': 100000},
            children: [WidgetNode(id: 'b', type: 'Text')],
          ),
        ),
        maxSampleCopies,
      );
    });
  });

  group('code', () {
    test('a list with a count is a builder over its first widget', () {
      final code = compact(document('ListView', {'sampleCount': 5}));

      expect(
        code,
        contains(
          'ListView.builder(itemCount:5,itemBuilder:(context,index)=>ListTile(',
        ),
      );
      expect(code, contains(r"title:Text('Item${index+1}')"));
      expect(code, isNot(contains('{n}')));
    });

    test('a list without a count keeps writing its children', () {
      final code = compact(document('ListView', {}));

      expect(code, contains('ListView(children:[ListTile('));
      expect(code, isNot(contains('builder')));
    });

    test('a grid keeps its columns in the delegate of the builder', () {
      final code = compact(
        document('GridView', {
          'sampleCount': 6,
          'crossAxisCount': 3,
          'mainAxisSpacing': 8.0,
        }),
      );

      expect(
        code,
        contains(
          'GridView.builder(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount('
          'crossAxisCount:3,mainAxisSpacing:8.0),itemCount:6,',
        ),
      );
    });

    test('lists and grids with counts are valid Dart', () async {
      final directory = Directory('lib/tmp_sample_check')..createSync();
      addTearDown(() => directory.deleteSync(recursive: true));
      var index = 0;
      for (final doc in [
        document('ListView', {
          'sampleCount': 5,
          'padding': [8.0, 8.0, 8.0, 8.0],
        }),
        document('GridView', {'sampleCount': 6, 'crossAxisCount': 3}),
      ]) {
        final file = generator
            .generate(doc.copyWith(name: 'screen_${index++}'))
            .getOrElse(() => throw StateError('generation failed'));
        File(
          '${directory.path}/${file.fileName}',
        ).writeAsStringSync(file.content);
      }

      final result = await Process.run('dart', [
        'analyze',
        '--fatal-infos',
        directory.path,
      ]);

      expect(result.exitCode, 0, reason: '${result.stdout}');
    }, timeout: const Timeout(Duration(minutes: 3)));
  });

  group('reading code back', () {
    String codeOf(EditorDocument doc) => generator
        .generate(doc)
        .getOrElse(() => throw StateError('generation failed'))
        .content;

    for (final (type, props, count) in [
      ('ListView', <String, Object?>{'sampleCount': 5}, 5),
      ('GridView', <String, Object?>{'sampleCount': 6, 'crossAxisCount': 3}, 6),
    ]) {
      test('a $type with a count comes back the same', () {
        final doc = document(type, props);
        final imported = CodeImporter(registry, const AnalyzerCodeParser())
            .import(codeOf(doc))
            .getOrElse(() => throw StateError('import failed'));

        final list = imported.document.root.children.single;
        expect(list.type, type);
        expect(list.props['sampleCount'], count);
        expect(list.children.single.props['title'], 'Item {n}');
        expect(codeOf(imported.document.copyWith(name: doc.name)), codeOf(doc));
        expect(imported.issues, isEmpty);
      });
    }
  });
}
