import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/data/services/analyzer_code_parser.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_value.dart';

void main() {
  const parser = AnalyzerCodeParser();

  test('reads what the build method of a widget class returns', () {
    final parsed = parser.parse('''
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Hello');
  }
}
''');

    expect(parsed.errors, isEmpty);
    expect(parsed.className, 'HomeView');
    final widget = parsed.widget as CodeCall;
    expect(widget.name, 'Text');
    expect((widget.positional.single as CodeString).value, 'Hello');
  });

  test('reads an expression body and a bare widget expression', () {
    final arrow = parser.parse(
      'class A extends StatelessWidget { Widget build(c) => Center(); }',
    );
    final bare = parser.parse('Center(child: Text("x"));');

    expect((arrow.widget as CodeCall).name, 'Center');
    expect((bare.widget as CodeCall).named.keys, ['child']);
  });

  test('tells constructors, named arguments and literals apart', () {
    final call =
        parser
                .parse(
                  "const Image.network('a.png', width: -2.5, fit: BoxFit.cover, "
                  'opacity: 3, flag: true, items: [1, 2], onTap: () {})',
                )
                .widget
            as CodeCall;

    expect(call.qualifiedName, 'Image.network');
    final width = call.named['width'] as CodeNumber;
    expect(width.value, -2.5);
    expect(width.isInteger, isFalse);
    expect((call.named['opacity'] as CodeNumber).isInteger, isTrue);
    expect((call.named['fit'] as CodeIdentifier).prefix, 'BoxFit');
    expect((call.named['flag'] as CodeBool).value, isTrue);
    expect((call.named['items'] as CodeList).items, hasLength(2));
    expect(call.named['onTap'], isA<CodeFunction>());
  });

  test('keeps what it cannot read as unknown', () {
    final call =
        parser
                .parse(r"Text('a $b', style: Theme.of(context).textTheme.body)")
                .widget
            as CodeCall;

    expect(call.positional.single, isA<CodeUnknown>());
    expect(call.named['style'], isA<CodeUnknown>());
  });

  test('reports syntax errors with their line', () {
    final parsed = parser.parse('Column(\n  children: [Text("x"),\n);');

    expect(parsed.errors, isNotEmpty);
    expect(parsed.errors.first, startsWith('line '));
    expect(parsed.widget, isNull);
  });

  test('parseExpression returns null for text that is not an expression', () {
    expect(parser.parseExpression('Icon(Icons.add)'), isA<CodeCall>());
    expect(parser.parseExpression('Icon(('), isNull);
  });
}
