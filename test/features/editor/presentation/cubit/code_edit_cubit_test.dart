import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/services/analyzer_code_parser.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_importer.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/import_usecases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_edit_cubit.dart';

void main() {
  CodeEditCubit build() => CodeEditCubit(
    importCode: ImportCode(
      CodeImporter(
        WidgetRegistry(builtinDefinitions),
        const AnalyzerCodeParser(),
      ),
    ),
  );

  const generated = "Text('a')";

  test('generated code is shown while nothing is edited', () {
    final cubit = build()..generatedChanged(generated);

    expect(cubit.state.text, generated);
    expect(cubit.state.dirty, isFalse);
    expect(cubit.state.revision, 1);

    cubit.generatedChanged("Text('b')");

    expect(cubit.state.text, "Text('b')");
    expect(cubit.state.revision, 2);
  });

  test('edited code is never overwritten by newly generated code', () {
    final cubit = build()
      ..generatedChanged(generated)
      ..edit("Text('mine')")
      ..generatedChanged("Text('other')");

    expect(cubit.state.text, "Text('mine')");
    expect(cubit.state.generated, "Text('other')");
    expect(cubit.state.dirty, isTrue);
    expect(cubit.state.revision, 1);
  });

  test('typing is checked once it pauses', () async {
    final cubit = build()..generatedChanged(generated);

    cubit.edit("Text('mine')");
    expect(cubit.state.result, isNull);

    await Future<void>.delayed(codeCheckDelay * 2);

    expect(cubit.state.result?.document.root.type, 'Text');
  });

  test('a broken text gives a failure and no result', () {
    final cubit = build()
      ..generatedChanged(generated)
      ..edit('Column(children: [');

    expect(cubit.checkNow(), isNull);
    expect(cubit.state.failure, isA<DocumentFailure>());
    expect(cubit.state.result, isNull);
  });

  test('going back to the generated text clears the check', () {
    final cubit = build()
      ..generatedChanged(generated)
      ..edit("Text('mine')")
      ..checkNow()
      ..edit(generated);

    expect(cubit.state.dirty, isFalse);
    expect(cubit.state.result, isNull);
  });

  test('revert shows the generated code again', () {
    final cubit = build()
      ..generatedChanged(generated)
      ..edit("Text('mine')")
      ..revert();

    expect(cubit.state.text, generated);
    expect(cubit.state.dirty, isFalse);
    expect(cubit.state.revision, 2);
  });

  test('applied makes the text the generated code, until it regenerates', () {
    final cubit = build()
      ..generatedChanged(generated)
      ..edit("Text('mine')")
      ..applied();

    expect(cubit.state.dirty, isFalse);

    cubit.generatedChanged("Text('mine', style: TextStyle())");

    expect(cubit.state.text, "Text('mine', style: TextStyle())");
  });
}
