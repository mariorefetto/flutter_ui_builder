import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/services/dart_style_code_formatter.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/new_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_validator.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/builtin_previews.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/icon_table.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';

void main() {
  final registry = WidgetRegistry(builtinDefinitions);

  group('admit', () {
    test('a Scaffold takes one of each slot and a single body', () {
      expect(registry.admit('Scaffold', 'AppBar', const []), isNull);
      expect(
        registry.admit('Scaffold', 'AppBar', const ['AppBar']),
        TreeFailureReason.slotTaken,
      );
      expect(registry.admit('Scaffold', 'Column', const ['AppBar']), isNull);
      expect(
        registry.admit('Scaffold', 'Text', const ['AppBar', 'Column']),
        TreeFailureReason.slotTaken,
      );
      expect(registry.admit('Scaffold', 'AppBar', const ['Column']), isNull);
    });

    test('slot widgets only go inside a Scaffold', () {
      expect(
        registry.admit('Column', 'AppBar', const []),
        TreeFailureReason.parentNotAllowed,
      );
    });

    test('the ChildPolicy still applies', () {
      expect(
        registry.admit('Text', 'Text', const []),
        TreeFailureReason.childNotAllowed,
      );
      expect(
        registry.admit('Padding', 'Text', const ['Text']),
        TreeFailureReason.parentFull,
      );
    });
  });

  test('the starter document is valid', () {
    expect(
      DocumentValidator(registry).validate(createEmptyDocument()).isRight(),
      isTrue,
    );
  });

  test('every icon option has an IconData', () {
    expect(iconOptions.every(iconsByName.containsKey), isTrue);
  });

  test('a full screen generates valid Dart', () async {
    final generator = DocumentCodeGenerator(
      registry,
      const DartStyleCodeFormatter(),
    );
    final document = createEmptyDocument().copyWith(
      root: const WidgetNode(
        id: 'node_0',
        type: 'Scaffold',
        children: [
          WidgetNode(id: 'node_1', type: 'AppBar', props: {'title': 'Home'}),
          WidgetNode(
            id: 'node_2',
            type: 'Column',
            children: [WidgetNode(id: 'node_3', type: 'Icon')],
          ),
          WidgetNode(
            id: 'node_4',
            type: 'BottomAppBar',
            children: [WidgetNode(id: 'node_5', type: 'Text')],
          ),
          WidgetNode(id: 'node_6', type: 'FloatingActionButton'),
        ],
      ),
    );
    final content = generator
        .generate(document)
        .getOrElse(() => throw StateError('expected a file'))
        .content;

    expect(content, contains('appBar: AppBar(title: Text(\'Home\'))'));
    expect(content, contains('bottomNavigationBar: BottomAppBar('));
    expect(content, contains('floatingActionButton: FloatingActionButton('));

    final file = File('lib/tmp_scaffold_check.dart')
      ..writeAsStringSync(content);
    addTearDown(file.deleteSync);
    final result = await Process.run('dart', [
      'analyze',
      '--fatal-infos',
      file.path,
    ]);
    expect(result.exitCode, 0, reason: '${result.stdout}');
  }, timeout: const Timeout(Duration(minutes: 2)));

  testWidgets('the starter screen is drawn with its AppBar and body', (
    tester,
  ) async {
    final previews = PreviewRegistry(
      registry: registry,
      previews: builtinPreviews,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) =>
              previews.build(context, createEmptyDocument().root),
        ),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.byType(Column), findsWidgets);
  });

  testWidgets('a SafeArea keeps clear of the system margins of the screen', (
    tester,
  ) async {
    final previews = PreviewRegistry(
      registry: registry,
      previews: builtinPreviews,
    );
    const screen = WidgetNode(
      id: 'node_0',
      type: 'Scaffold',
      children: [
        WidgetNode(
          id: 'node_1',
          type: 'SafeArea',
          children: [
            WidgetNode(id: 'node_2', type: 'Text', props: {'text': 'inside'}),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: PreviewScreenScope(
          size: const Size(390, 844),
          insets: const EdgeInsets.only(top: 47, bottom: 34),
          child: Builder(builder: (context) => previews.build(context, screen)),
        ),
      ),
    );

    final frame = tester.getTopLeft(find.byType(Scaffold));
    final text = tester.getTopLeft(find.text('inside'));
    expect(text.dy - frame.dy, greaterThanOrEqualTo(47));
  });

  test('an AppBar status bar style brings in the services library', () {
    final generator = DocumentCodeGenerator(
      registry,
      const DartStyleCodeFormatter(),
    );
    String code(Map<String, Object?> appBarProps) => generator
        .generate(
          EditorDocument(
            name: 'test',
            root: WidgetNode(
              id: 'node_0',
              type: 'Scaffold',
              children: [
                WidgetNode(id: 'node_1', type: 'AppBar', props: appBarProps),
              ],
            ),
          ),
        )
        .getOrElse(() => throw StateError('expected a file'))
        .content;

    const services = "import 'package:flutter/services.dart';";

    expect(code({'statusBarStyle': 'light'}), contains(services));
    expect(
      code({'statusBarStyle': 'light'}),
      contains('systemOverlayStyle: SystemUiOverlayStyle.light'),
    );
    expect(code(const {}), isNot(contains(services)));
  });
}
