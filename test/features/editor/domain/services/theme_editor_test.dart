import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/services/dart_style_code_formatter.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/project_theme_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/theme_editor.dart';

void main() {
  const editor = ThemeEditor();
  const project = EditorDocument(
    name: 'Home',
    root: WidgetNode(id: 'node_0', type: 'Column'),
  );
  final generator = DocumentCodeGenerator(
    WidgetRegistry(builtinDefinitions),
    const DartStyleCodeFormatter(),
  );

  EditorDocument themed(List<(String, String, Object?)> values) {
    var doc = project;
    for (final (part, name, value) in values) {
      doc = editor
          .set(doc, part, name, value)
          .getOrElse(() => throw StateError('$part.$name refused'));
    }
    return doc;
  }

  // The code without spaces and trailing commas, which the formatter adds.
  String compact(String code) =>
      code.replaceAll(RegExp(r'\s+'), '').replaceAll(',)', ')');

  String themeCode(EditorDocument doc) =>
      compact(generator.generateTheme(doc).content);

  group('editing', () {
    test('a new project has the default theme', () {
      expect(project.theme.isDefault, isTrue);
    });

    test('a value is set and read back with the defaults around it', () {
      final doc = themed([('scheme', 'seedColor', 0xFF009688)]);

      final scheme = doc.theme.valuesOf(
        'scheme',
        themePartNamed('scheme')!.props,
      );
      expect(scheme.color('seedColor'), 0xFF009688);
      expect(scheme.choice('brightness'), 'light');
      expect(doc.theme.isDefault, isFalse);
    });

    test('a null value puts the default back, and an empty part goes', () {
      final doc = editor
          .set(themed([('card', 'elevation', 4.0)]), 'card', 'elevation', null)
          .getOrElse(() => throw StateError('refused'));

      expect(doc.theme.parts, isEmpty);
      expect(doc.theme.isDefault, isTrue);
    });

    test(
      'a part, a property or a value the theme does not know is refused',
      () {
        DocumentFailureReason? reason(Object result) => (result as dynamic)
            .fold((f) => f is DocumentFailure ? f.reason : null, (_) => null);

        expect(
          reason(editor.set(project, 'bogus', 'x', 1)),
          DocumentFailureReason.invalidStructure,
        );
        expect(
          reason(editor.set(project, 'card', 'bogus', 1)),
          DocumentFailureReason.invalidStructure,
        );
        expect(
          reason(editor.set(project, 'scheme', 'brightness', 'neon')),
          DocumentFailureReason.invalidStructure,
        );
        expect(
          reason(editor.set(project, 'card', 'elevation', 'much')),
          DocumentFailureReason.invalidStructure,
        );
      },
    );

    test('a part can be reset on its own', () {
      final doc = editor
          .reset(
            themed([
              ('card', 'elevation', 4.0),
              ('appBar', 'centerTitle', true),
            ]),
            'card',
          )
          .getOrElse(() => throw StateError('refused'));

      expect(doc.theme.parts.keys, ['appBar']);
    });
  });

  group('code', () {
    test('the default theme is not written out', () {
      final files = generator
          .generateAll(project)
          .getOrElse(() => throw StateError('generation failed'));

      expect(files.map((f) => f.fileName), isNot(contains(themeFileName)));
    });

    test('a changed theme is written as buildAppTheme', () {
      final doc = themed([('scheme', 'seedColor', 0xFF009688)]);

      final files = generator
          .generateAll(doc)
          .getOrElse(() => throw StateError('generation failed'));

      expect(files.last.fileName, themeFileName);
      expect(files.last.content, contains('ThemeData buildAppTheme()'));
      expect(
        compact(files.last.content),
        contains('ColorScheme.fromSeed(seedColor:Color(0xFF009688))'),
      );
    });

    test('dark, font and Material 2 are written', () {
      final code = themeCode(
        themed([
          ('scheme', 'brightness', 'dark'),
          ('scheme', 'fontFamily', 'Roboto'),
          ('scheme', 'useMaterial3', false),
        ]),
      );

      expect(code, contains('brightness:Brightness.dark'));
      expect(code, contains("fontFamily:'Roboto'"));
      expect(code, contains('useMaterial3:false'));
    });

    test('the theme of a widget is written as its theme data', () {
      final code = themeCode(
        themed([
          ('appBar', 'centerTitle', true),
          ('elevatedButton', 'borderRadius', 12.0),
          ('card', 'elevation', 0.0),
          ('divider', 'thickness', 2.0),
        ]),
      );

      expect(code, contains('appBarTheme:AppBarTheme(centerTitle:true'));
      expect(
        code,
        contains(
          'elevatedButtonTheme:ElevatedButtonThemeData(style:'
          'ElevatedButton.styleFrom(shape:RoundedRectangleBorder('
          'borderRadius:BorderRadius.circular(12.0))))',
        ),
      );
      expect(code, contains('cardTheme:CardThemeData(elevation:0.0'));
      expect(code, contains('dividerTheme:DividerThemeData(thickness:2.0'));
    });

    test('a text field theme can be an outline with round corners', () {
      final code = themeCode(
        themed([
          ('inputDecoration', 'filled', true),
          ('inputDecoration', 'border', 'outline'),
          ('inputDecoration', 'borderRadius', 8.0),
        ]),
      );

      expect(
        code,
        contains(
          'inputDecorationTheme:InputDecorationTheme(filled:true,'
          'border:OutlineInputBorder(borderRadius:BorderRadius.circular(8.0))',
        ),
      );
    });

    test('a theme with every part changed is valid Dart', () async {
      final doc = themed([
        ('scheme', 'seedColor', 0xFF009688),
        ('scheme', 'brightness', 'dark'),
        ('scheme', 'fontFamily', 'Roboto'),
        ('appBar', 'backgroundColor', 0xFF112233),
        ('appBar', 'foregroundColor', 0xFFFFFFFF),
        ('appBar', 'elevation', 2.0),
        ('appBar', 'centerTitle', true),
        for (final button in [
          'elevatedButton',
          'filledButton',
          'outlinedButton',
          'textButton',
        ]) ...[
          (button, 'foregroundColor', 0xFF445566),
          (button, 'borderRadius', 10.0),
        ],
        ('elevatedButton', 'backgroundColor', 0xFF778899),
        ('filledButton', 'elevation', 1.0),
        ('card', 'color', 0xFFAABBCC),
        ('card', 'elevation', 3.0),
        ('card', 'borderRadius', 16.0),
        ('card', 'margin', [4.0, 4.0, 4.0, 4.0]),
        ('inputDecoration', 'filled', true),
        ('inputDecoration', 'fillColor', 0xFFEEEEEE),
        ('inputDecoration', 'border', 'outline'),
        ('inputDecoration', 'borderRadius', 8.0),
        ('floatingActionButton', 'backgroundColor', 0xFF123456),
        ('floatingActionButton', 'foregroundColor', 0xFFFFFFFF),
        ('listTile', 'iconColor', 0xFF123456),
        ('listTile', 'textColor', 0xFF654321),
        ('listTile', 'tileColor', 0xFFFAFAFA),
        ('divider', 'color', 0xFF999999),
        ('divider', 'thickness', 2.0),
      ]);
      final directory = Directory('lib/tmp_theme_check')..createSync();
      addTearDown(() => directory.deleteSync(recursive: true));
      final file = generator.generateTheme(doc);
      File(
        '${directory.path}/${file.fileName}',
      ).writeAsStringSync(file.content);

      final result = await Process.run('dart', [
        'analyze',
        '--fatal-infos',
        directory.path,
      ]);

      expect(result.exitCode, 0, reason: '${result.stdout}');
    }, timeout: const Timeout(Duration(minutes: 3)));
  });
}
