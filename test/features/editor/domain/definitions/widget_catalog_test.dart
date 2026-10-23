import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/data/services/analyzer_code_parser.dart';
import 'package:flutter_ui_builder/features/editor/data/services/dart_style_code_formatter.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/component_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_screen.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_importer.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_validator.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/builtin_previews.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_registry.dart';

void main() {
  final registry = WidgetRegistry(builtinDefinitions);
  final previews = PreviewRegistry(
    registry: registry,
    previews: builtinPreviews,
    parentDataTypes: parentDataPreviewTypes,
  );

  var counter = 0;
  String nextId() => 'node_${counter++}';

  bool rootOnly(WidgetNode node) =>
      registry.definitionFor(node.type).allowedParents?.isEmpty ?? false;

  // The node wrapped in whatever it needs to be valid: its required parent,
  // a Card for a Material ancestor, a SizedBox where a Column would give it
  // unbounded size. A screen widget is returned as it is.
  WidgetNode wrapped(WidgetNode node) {
    final definition = registry.definitionFor(node.type);
    final parents = definition.allowedParents;
    if (parents != null) {
      if (parents.isEmpty) return node;
      final siblings = [
        node,
        // A NavigationBar needs two destinations.
        if (node.type == 'NavigationDestination')
          WidgetNode(id: nextId(), type: node.type),
      ];
      return wrapped(
        WidgetNode(id: nextId(), type: parents.first, children: siblings),
      );
    }
    var current = node;
    if (definition.requiredAncestors != null) {
      current = WidgetNode(id: nextId(), type: 'Card', children: [current]);
    }
    if (registry.admit('Column', current.type, const []) != null) {
      current = WidgetNode(id: nextId(), type: 'SizedBox', children: [current]);
    }
    return current;
  }

  WidgetNode placed(String type, {Map<String, Object?> props = const {}}) =>
      wrapped(WidgetNode(id: nextId(), type: type, props: props));

  EditorDocument documentFor(
    List<WidgetNode> nodes, {
    String name = 'catalog',
  }) => EditorDocument(
    name: name,
    root: nodes.length == 1 && rootOnly(nodes.first)
        ? nodes.first
        : WidgetNode(id: nextId(), type: 'Column', children: nodes),
  );

  // A value for every property that differs from its default, so the preview
  // and the code generator are exercised on all of them at once.
  Map<String, Object?> sampleProps(WidgetDefinition definition) => {
    for (final prop in definition.props)
      prop.name: switch (prop.type) {
        // Going back needs no other screen to exist.
        PropType.string => prop.screenPicker ? navigateBack : 'x',
        PropType.number => 2,
        PropType.boolean => !(prop.defaultValue as bool? ?? false),
        PropType.color => 0xFF123456,
        PropType.choice => prop.options.firstWhere(
          (option) => option != prop.defaultValue,
        ),
        PropType.edgeInsets => [1.0, 2.0, 3.0, 4.0],
      },
  };

  // One document with every widget that fits in a Column, and one document
  // for each screen widget, which can only be a root.
  List<EditorDocument> catalog({bool full = false}) {
    final tops = [
      // A use of a component needs a project with that component, so it has
      // its own tests.
      for (final d in registry.all.where((d) => d.type != componentType))
        placed(d.type, props: full ? sampleProps(d) : const {}),
    ];
    return [
      documentFor(tops.where((t) => !rootOnly(t)).toList()),
      for (final (index, top) in tops.where(rootOnly).indexed)
        documentFor([top], name: 'screen_$index'),
    ];
  }

  Future<void> pumpDocument(WidgetTester tester, EditorDocument document) {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Builder(
              builder: (context) => previews.build(context, document.root),
            ),
          ),
        ),
      ),
    );
  }

  Iterable<(WidgetDefinition, PropSchema)> allProps() sync* {
    for (final definition in registry.all) {
      for (final prop in definition.props) {
        yield (definition, prop);
      }
    }
  }

  test('types and labels are unique', () {
    final types = registry.all.map((d) => d.type).toList();

    expect(types.toSet(), hasLength(types.length));
  });

  test('every default value is accepted by its own schema', () {
    for (final (definition, prop) in allProps()) {
      if (prop.defaultValue == null) continue;
      expect(
        prop.accepts(prop.defaultValue),
        isTrue,
        reason: '${definition.type}.${prop.name}',
      );
    }
  });

  test('every catalog document is structurally valid', () {
    for (final document in catalog()) {
      expect(
        DocumentValidator(registry).validate(document).isRight(),
        isTrue,
        reason: document.name,
      );
    }
  });

  testWidgets('every widget previews without errors', (tester) async {
    for (final document in catalog()) {
      await pumpDocument(tester, document);

      expect(tester.takeException(), isNull, reason: document.name);
    }
  });

  testWidgets('every widget previews with all its properties set', (
    tester,
  ) async {
    for (final document in catalog(full: true)) {
      await pumpDocument(tester, document);

      expect(tester.takeException(), isNull, reason: document.name);
    }
  });

  testWidgets('every choice option previews without errors', (tester) async {
    for (final (definition, prop) in allProps()) {
      if (prop.type != PropType.choice) continue;
      // The icon lists have thousands of names; the ends and the middle show
      // that the lookup works without building a screen for each.
      final options = prop.options.length > 40
          ? [
              prop.options.first,
              prop.options[prop.options.length ~/ 2],
              prop.options.last,
            ]
          : prop.options;
      for (final option in options) {
        final node = placed(definition.type, props: {prop.name: option});
        await pumpDocument(tester, documentFor([node]));

        expect(
          tester.takeException(),
          isNull,
          reason: '${definition.type}.${prop.name} = $option',
        );
      }
    }
  });

  // Generates every document, writes the files next to the sources so the
  // analyzer resolves package imports, and analyzes them together.
  Future<void> expectValidDart(List<EditorDocument> documents) async {
    final generator = DocumentCodeGenerator(
      registry,
      const DartStyleCodeFormatter(),
    );
    final files = <File>[];
    addTearDown(() {
      for (final file in files) {
        file.deleteSync();
      }
    });
    for (final (index, document) in documents.indexed) {
      final content = generator
          .generate(document)
          .fold(
            (failure) =>
                throw StateError('generation failed: ${failure.message}'),
            (file) => file.content,
          );
      files.add(
        File('lib/tmp_catalog_check_$index.dart')..writeAsStringSync(content),
      );
    }

    final result = await Process.run('dart', [
      'analyze',
      '--fatal-infos',
      ...files.map((file) => file.path),
    ]);

    expect(result.exitCode, 0, reason: '${result.stdout}');
  }

  test('screens that open each other generate valid Dart', () async {
    final generator = DocumentCodeGenerator(
      registry,
      const DartStyleCodeFormatter(),
    );
    WidgetNode scaffold(String target) => WidgetNode(
      id: 'node_0',
      type: 'Scaffold',
      children: [
        WidgetNode(
          id: 'node_1',
          type: 'Column',
          children: [
            WidgetNode(
              id: 'node_2',
              type: 'ElevatedButton',
              props: {'navigateTo': target},
              children: const [WidgetNode(id: 'node_3', type: 'Text')],
            ),
            const WidgetNode(
              id: 'node_4',
              type: 'TextButton',
              props: {'navigateTo': navigateBack},
              children: [WidgetNode(id: 'node_5', type: 'Text')],
            ),
          ],
        ),
      ],
    );
    final files = generator
        .generateAll(
          EditorDocument(
            name: 'Home',
            root: scaffold('Settings'),
            screens: [ProjectScreen(name: 'Settings', root: scaffold('Home'))],
          ),
        )
        .getOrElse(() => throw StateError('generation failed'));
    final directory = Directory('lib/tmp_navigation_check')..createSync();
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

  test('components and their uses generate valid Dart', () async {
    final generator = DocumentCodeGenerator(
      registry,
      const DartStyleCodeFormatter(),
    );
    const card = WidgetNode(
      id: 'node_0',
      type: 'Card',
      children: [WidgetNode(id: 'node_1', type: 'Text')],
    );
    const use = WidgetNode(
      id: 'node_1',
      type: 'Component',
      props: {'component': 'Greeting'},
    );
    final files = generator
        .generateAll(
          const EditorDocument(
            name: 'Home',
            root: WidgetNode(id: 'node_0', type: 'Column', children: [use]),
            screens: [
              ProjectScreen(name: 'Greeting', component: true, root: card),
              ProjectScreen(
                name: 'Group',
                component: true,
                root: WidgetNode(
                  id: 'node_0',
                  type: 'Column',
                  children: [
                    WidgetNode(
                      id: 'node_1',
                      type: 'Component',
                      props: {'component': 'Greeting'},
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .getOrElse(() => throw StateError('generation failed'));
    final directory = Directory('lib/tmp_component_check')..createSync();
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

  test(
    'the catalog generates valid Dart',
    () => expectValidDart(catalog()),
    timeout: const Timeout(Duration(minutes: 3)),
  );

  test(
    'the catalog with all properties set generates valid Dart',
    () => expectValidDart(catalog(full: true)),
    timeout: const Timeout(Duration(minutes: 3)),
  );

  // A node reduced to what the document means: its type, the value of every
  // property with defaults applied, and its children. Numbers compare as
  // doubles because a stored 2 and a read 2.0 are the same value.
  Map<String, Object?> normalize(WidgetNode node) {
    final definition = registry.definitionFor(node.type);
    final props = definition.resolve(node);
    Object? valueOf(PropSchema schema) {
      final name = schema.name;
      return switch (schema.type) {
        PropType.string => props.string(name),
        PropType.number => props.number(name),
        PropType.boolean => props.boolean(name),
        PropType.color => props.color(name),
        PropType.choice => props.choice(name),
        PropType.edgeInsets => props.edgeInsets(name),
      };
    }

    return {
      'type': node.type,
      'props': {
        for (final schema in definition.props) schema.name: valueOf(schema),
      },
      'children': node.children.map(normalize).toList(),
    };
  }

  // The code of a document must come back as the same code after it is read
  // into a document and written again. Properties that overlap, such as a
  // radius and the radius of each corner, may end up spelled differently in
  // the model, but they write the same code.
  void expectRoundTrip(List<EditorDocument> documents) {
    final generator = DocumentCodeGenerator(
      registry,
      const DartStyleCodeFormatter(),
    );
    String codeOf(EditorDocument document) => generator
        .generate(document)
        .getOrElse(() => throw StateError('generation failed'))
        .content;
    final importer = CodeImporter(registry, const AnalyzerCodeParser());
    for (final document in documents) {
      final code = codeOf(document);
      final result = importer.import(code);

      expect(
        result.isRight(),
        isTrue,
        reason: '${document.name}: ${result.fold((f) => f.message, (_) => '')}',
      );
      final imported = result.getOrElse(() => throw StateError('no result'));
      expect(
        normalize(imported.document.root)['type'],
        normalize(document.root)['type'],
        reason: document.name,
      );
      // The name is read from the class, written in another case.
      expect(
        codeOf(imported.document.copyWith(name: document.name)),
        code,
        reason: document.name,
      );
      expect(
        imported.issues,
        isEmpty,
        reason:
            '${document.name}: ${imported.issues.map((i) => '${i.kind} ${i.widgetType} ${i.argument}')}',
      );
    }
  }

  test('code generated for the catalog imports back to the same widgets', () {
    expectRoundTrip(catalog());
  });

  test('code generated with every property set imports back unchanged', () {
    expectRoundTrip(catalog(full: true));
  });
}
