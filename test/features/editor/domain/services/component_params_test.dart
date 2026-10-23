import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/services/analyzer_code_parser.dart';
import 'package:flutter_ui_builder/features/editor/data/services/dart_style_code_formatter.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/component_param.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_screen.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_importer.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/document_reconciler.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/component_binding.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/component_params.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';

void main() {
  final registry = WidgetRegistry(builtinDefinitions);
  final editor = ComponentParamsEditor(registry);
  const screens = ScreenEditor();
  final generator = DocumentCodeGenerator(
    registry,
    const DartStyleCodeFormatter(),
  );

  // The component "Badge": a Container with a Text, open for editing.
  EditorDocument badge() => const EditorDocument(
    name: 'Badge',
    component: true,
    root: WidgetNode(
      id: 'node_0',
      type: 'Container',
      props: {'color': 0xFF112233},
      children: [
        WidgetNode(id: 'node_1', type: 'Text', props: {'text': 'Hi'}),
      ],
    ),
  );

  EditorDocument bound() => editor
      .bind(badge(), 'node_1', 'text', 'title')
      .getOrElse(() => throw StateError('bind failed'));

  DocumentFailureReason? reasonOf(Object result) => (result as dynamic).fold(
    (f) => f is DocumentFailure ? f.reason : null,
    (_) => null,
  );

  group('binding', () {
    test('a property becomes a parameter with its value as the default', () {
      final doc = bound();

      expect(doc.params, const [
        ComponentParam(
          name: 'title',
          type: PropType.string,
          defaultValue: 'Hi',
        ),
      ]);
      expect(boundParam(doc.root.find('node_1')?.props['text']), 'title');
    });

    test('a colour and a number can be parameters too', () {
      final doc = editor
          .bind(bound(), 'node_0', 'color', 'tint')
          .getOrElse(() => throw StateError('bind failed'));
      final sized = editor
          .bind(doc, 'node_0', 'width', 'size')
          .getOrElse(() => throw StateError('bind failed'));

      expect(sized.params.map((p) => (p.name, p.type, p.defaultValue)), [
        ('title', PropType.string, 'Hi'),
        ('tint', PropType.color, 0xFF112233),
        ('size', PropType.number, 0.0),
      ]);
    });

    test('two properties can share a parameter of the same kind', () {
      final doc = editor
          .bind(bound(), 'node_1', 'fontFamily', 'title')
          .getOrElse(() => throw StateError('bind failed'));

      expect(doc.params, hasLength(1));
    });

    test('what cannot be a parameter is refused', () {
      // Not a component, a whole number, a choice, a bad name, a name Dart
      // keeps, a kind that does not match the parameter.
      expect(
        reasonOf(
          editor.bind(
            badge().copyWith(component: false),
            'node_1',
            'text',
            'title',
          ),
        ),
        DocumentFailureReason.invalidParameter,
      );
      expect(
        reasonOf(editor.bind(badge(), 'node_1', 'maxLines', 'lines')),
        DocumentFailureReason.invalidParameter,
      );
      expect(
        reasonOf(editor.bind(badge(), 'node_1', 'textAlign', 'align')),
        DocumentFailureReason.invalidParameter,
      );
      for (final name in ['Title', '1st', 'my title', '', 'class', 'key']) {
        expect(
          reasonOf(editor.bind(badge(), 'node_1', 'text', name)),
          DocumentFailureReason.invalidParameter,
          reason: name,
        );
      }
      expect(
        reasonOf(editor.bind(bound(), 'node_0', 'color', 'title')),
        DocumentFailureReason.invalidParameter,
      );
    });

    test('a property freed keeps the default and an unused parameter goes', () {
      final doc = editor
          .unbind(bound(), 'node_1', 'text')
          .getOrElse(() => throw StateError('unbind failed'));

      expect(doc.root.find('node_1')?.props['text'], 'Hi');
      expect(doc.params, isEmpty);
    });

    test('a parameter still used by another property stays', () {
      final shared = editor
          .bind(bound(), 'node_1', 'fontFamily', 'title')
          .getOrElse(() => throw StateError('bind failed'));

      final doc = editor
          .unbind(shared, 'node_1', 'fontFamily')
          .getOrElse(() => throw StateError('unbind failed'));

      expect(doc.params.map((p) => p.name), ['title']);
    });

    test('the component takes the value each use gives', () {
      final doc = bound();
      final given = bindArguments(doc.root, doc.params, {'title': 'Sale'});
      final other = bindArguments(doc.root, doc.params, {});
      final wrong = bindArguments(doc.root, doc.params, {'title': 5});

      expect(given.find('node_1')?.props['text'], 'Sale');
      expect(other.find('node_1')?.props['text'], 'Hi');
      expect(wrong.find('node_1')?.props['text'], 'Hi');
    });
  });

  group('code', () {
    // Without spaces and the trailing commas the formatter adds.
    String compact(String code) => code
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll(',)', ')')
        .replaceAll(',}', '}');

    test('a component with parameters takes them in its constructor', () {
      final doc = editor
          .bind(bound(), 'node_0', 'color', 'tint')
          .getOrElse(() => throw StateError('bind failed'));

      final code = compact(
        generator
            .generate(doc)
            .getOrElse(() => throw StateError('generation failed'))
            .content,
      );

      expect(
        code,
        contains(
          "constBadgeWidget({super.key,this.title='Hi',this.tint=Color(0xFF112233)})",
        ),
      );
      expect(code, contains('finalStringtitle;'));
      expect(code, contains('finalColortint;'));
      expect(code, contains('Text(title'));
      expect(code, contains('color:tint'));
      expect(code, isNot(contains('__param_')));
    });

    test('a use writes the values it gives', () {
      const use = WidgetNode(
        id: 'node_1',
        type: 'Component',
        props: {
          'component': 'Badge',
          'arg.title': 'Sale',
          'arg.tint': 4278190080,
          'arg.size': 12.0,
        },
      );

      final code = compact(
        generator
            .generate(
              const EditorDocument(
                name: 'Home',
                root: WidgetNode(id: 'node_0', type: 'Column', children: [use]),
              ),
            )
            .getOrElse(() => throw StateError('generation failed'))
            .content,
      );

      expect(
        code,
        contains(
          "constBadgeWidget(title:'Sale',tint:Color(0xFF000000),size:12.0)",
        ),
      );
    });

    test('a project with parameters is valid Dart', () async {
      final doc = editor
          .bind(bound(), 'node_0', 'color', 'tint')
          .getOrElse(() => throw StateError('bind failed'));
      final project = doc.copyWith(
        screens: const [
          ProjectScreen(
            name: 'Home',
            root: WidgetNode(
              id: 'node_0',
              type: 'Column',
              children: [
                WidgetNode(
                  id: 'node_1',
                  type: 'Component',
                  props: {
                    'component': 'Badge',
                    'arg.title': "Sale's",
                    'arg.tint': 4278190080,
                  },
                ),
                WidgetNode(
                  id: 'node_2',
                  type: 'Component',
                  props: {'component': 'Badge'},
                ),
              ],
            ),
          ),
        ],
      );
      final files = generator
          .generateAll(project)
          .getOrElse(() => throw StateError('generation failed'));
      final directory = Directory('lib/tmp_params_check')..createSync();
      addTearDown(() => directory.deleteSync(recursive: true));
      for (final file in files) {
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
    ImportResult importCode(String source) => CodeImporter(
      registry,
      const AnalyzerCodeParser(),
    ).import(source).getOrElse(() => throw StateError('import failed'));

    test('the values given to a component are read', () {
      final result = importCode('''
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [const BadgeWidget(title: 'Sale', tint: Color(0xFF000000), size: 12)]);
  }
}
''');

      final use = result.document.root.children.single;
      expect(use.props['component'], 'Badge');
      expect(argumentsOf(use), {
        'title': 'Sale',
        'tint': 0xFF000000,
        'size': 12.0,
      });
    });

    test('code edited in a component keeps its parameters bound', () {
      final doc = bound();
      // The code writes the bound text as a variable, which cannot be read.
      final edited = importCode('''
class BadgeWidget extends StatelessWidget {
  const BadgeWidget({super.key, this.title = 'Hi'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(color: Color(0xFF112233), child: Text(title));
  }
}
''');

      final result = const DocumentReconciler().reconcile(doc, edited);

      expect(result.params, doc.params);
      expect(boundParam(result.root.find('node_1')?.props['text']), 'title');
    });
  });

  group('using a component', () {
    EditorDocument project() {
      final component = bound();
      return screens
          .open(
            component.copyWith(
              screens: const [
                ProjectScreen(
                  name: 'Home',
                  root: WidgetNode(
                    id: 'node_0',
                    type: 'Column',
                    children: [
                      WidgetNode(
                        id: 'node_1',
                        type: 'Component',
                        props: {'component': 'Badge', 'arg.title': 'Sale'},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            'Home',
          )
          .getOrElse(() => throw StateError('open failed'));
    }

    test('detaching a use gives a copy with the values it gave', () {
      final doc = screens
          .detach(project(), 'node_1')
          .getOrElse(() => throw StateError('detach failed'));

      final text = doc.root.children.single.children.single;
      expect(text.props['text'], 'Sale');
      expect(doc.root.componentTargets(), isEmpty);
    });

    test('deleting the component leaves each use with its own values', () {
      final doc = screens
          .delete(project(), 'Badge')
          .getOrElse(() => throw StateError('delete failed'));

      final text = doc.root.children.single.children.single;
      expect(text.props['text'], 'Sale');
    });

    test('a copy of a component stays a component with its parameters', () {
      final doc = screens
          .duplicate(bound(), 'Badge')
          .getOrElse(() => throw StateError('duplicate failed'));

      expect(doc.component, isTrue);
      expect(doc.name, 'Badge copy');
      expect(doc.params.map((p) => p.name), ['title']);
      expect(screens.componentsOf(doc), ['Badge', 'Badge copy']);
    });

    test('opening a component and going back keeps its parameters', () {
      final doc = project();

      final reopened = screens
          .open(doc, 'Badge')
          .getOrElse(() => throw StateError('open failed'));

      expect(reopened.params.map((p) => p.name), ['title']);
      expect(
        screens
            .open(reopened, 'Home')
            .getOrElse(() => throw StateError('x'))
            .params,
        isEmpty,
      );
    });
  });
}
