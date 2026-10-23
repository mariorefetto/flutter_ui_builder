import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/code/dart_tokens.dart';

void main() {
  List<Token> of(String source) =>
      tokenizeDart(source).where((t) => t.kind != TokenKind.plain).toList();

  test('the tokens together are the whole text', () {
    const source = "class A extends B { // hi\n  final x = 'a' + 1; }";

    expect(tokenizeDart(source).map((t) => t.text).join(), source);
  });

  test('keywords, class names, strings and numbers are told apart', () {
    expect(of("return Text('Hi', maxLines: 2);"), const [
      Token('return', TokenKind.keyword),
      Token('Text', TokenKind.type),
      Token("'Hi'", TokenKind.string),
      Token('maxLines', TokenKind.argument),
      Token('2', TokenKind.number),
    ]);
  });

  test('a hex colour is one number', () {
    expect(of('Color(0xFF2196F3)'), const [
      Token('Color', TokenKind.type),
      Token('0xFF2196F3', TokenKind.number),
    ]);
  });

  test('a comment hides what is inside it', () {
    expect(of('// return Text(1)'), const [
      Token('// return Text(1)', TokenKind.comment),
    ]);
    expect(of('/* const */ 1'), const [
      Token('/* const */', TokenKind.comment),
      Token('1', TokenKind.number),
    ]);
  });

  test('a string hides what is inside it, and may hold an escaped quote', () {
    expect(of(r"'it\'s final'"), const [
      Token(r"'it\'s final'", TokenKind.string),
    ]);
  });

  test('half-written code is coloured as far as it goes', () {
    expect(of("Text('open"), const [
      Token('Text', TokenKind.type),
      Token("'open", TokenKind.string),
    ]);
    expect(of('/* never closed'), const [
      Token('/* never closed', TokenKind.comment),
    ]);
  });

  test('annotations, and a keyword inside a word, are handled', () {
    expect(of('@override\nclassic'), const [
      Token('@override', TokenKind.annotation),
    ]);
  });

  test('empty text has no tokens', () {
    expect(tokenizeDart(''), isEmpty);
  });
}
