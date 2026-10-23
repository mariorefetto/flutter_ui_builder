import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/data/services/analyzer_code_parser.dart';
import 'package:flutter_ui_builder/features/editor/data/services/dart_style_code_formatter.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/screen_templates.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_importer.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_code_generator.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_linter.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';

void main() {
  final registry = WidgetRegistry(builtinDefinitions);
  final generator = DocumentCodeGenerator(
    registry,
    const DartStyleCodeFormatter(),
  );

  EditorDocument documentOf(ScreenTemplate template) =>
      EditorDocument(name: template.name, root: screenTemplateRoot(template));

  group('every template', () {
    for (final template in ScreenTemplate.values) {
      test('${template.name} follows the placement rules', () {
        expect(registry.violation(screenTemplateRoot(template)), isNull);
      });

      test('${template.name} has ids that are all different', () {
        final ids = screenTemplateRoot(template).preorderIds();

        expect(ids.toSet(), hasLength(ids.length));
        expect(ids.first, 'node_0');
      });

      test('${template.name} raises no problems in the checks', () {
        expect(linterFor().lint(documentOf(template)), isEmpty);
      });

      test('${template.name} comes back the same from its code', () {
        final document = documentOf(template);
        String codeOf(EditorDocument d) => generator
            .generate(d)
            .getOrElse(() => throw StateError('generation failed'))
            .content;
        final imported = CodeImporter(registry, const AnalyzerCodeParser())
            .import(codeOf(document))
            .getOrElse(() => throw StateError('import failed'));

        expect(
          codeOf(imported.document.copyWith(name: document.name)),
          codeOf(document),
        );
        expect(imported.issues, isEmpty);
      });
    }
  });

  test('every template generates valid Dart', () async {
    final directory = Directory('lib/tmp_template_check')..createSync();
    addTearDown(() => directory.deleteSync(recursive: true));
    for (final template in ScreenTemplate.values) {
      final file = generator
          .generate(documentOf(template))
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

  test('the blank template is the starter screen', () {
    expect(screenTemplateRoot(ScreenTemplate.blank).type, 'Scaffold');
    expect(screenTemplateRoot(ScreenTemplate.blank).children, hasLength(2));
  });
}

DocumentLinter linterFor() =>
    DocumentLinter(WidgetRegistry(builtinDefinitions));
