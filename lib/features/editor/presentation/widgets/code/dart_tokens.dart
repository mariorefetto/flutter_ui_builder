/// What a stretch of Dart source is, for colouring it.
enum TokenKind {
  plain,
  comment,
  string,
  number,
  keyword,
  type,
  annotation,
  argument,
}

/// A stretch of the source and what it is. Tokens follow each other and
/// together cover the whole text.
class Token {
  const Token(this.text, this.kind);

  final String text;
  final TokenKind kind;

  @override
  bool operator ==(Object other) =>
      other is Token && other.text == text && other.kind == kind;

  @override
  int get hashCode => Object.hash(text, kind);

  @override
  String toString() => '${kind.name}(${text.replaceAll('\n', r'\n')})';
}

const String _keywords =
    'abstract|as|async|await|break|case|catch|class|const|continue|default|'
    'do|dynamic|else|enum|extends|extension|false|final|for|get|if|implements|'
    'import|in|is|late|mixin|new|null|on|override|part|required|return|set|'
    'static|super|switch|this|throw|true|try|typedef|var|void|while|with|yield';

// The order is the priority: a comment or a string hides what is inside it.
final RegExp _pattern = RegExp(
  '(?<comment>//[^\\n]*|/\\*[\\s\\S]*?(?:\\*/|\$))'
  '|(?<string>r?\'(?:\\\\.|[^\'\\\\\\n])*\'?|r?"(?:\\\\.|[^"\\\\\\n])*"?)'
  '|(?<annotation>@[A-Za-z_]\\w*)'
  '|(?<number>\\b0[xX][0-9A-Fa-f]+\\b|\\b\\d+(?:\\.\\d+)?\\b)'
  '|(?<keyword>\\b(?:$_keywords)\\b)'
  '|(?<type>\\b[A-Z_]\\w*\\b)'
  '|(?<argument>\\b[a-z_]\\w*(?=\\s*:(?!:)))',
);

/// Splits Dart [source] into coloured stretches. It reads the shapes that
/// matter for a screen's code (comments, strings, numbers, keywords, class
/// names and named arguments), not the whole grammar, so it never fails and
/// colours half-written code as well.
List<Token> tokenizeDart(String source) {
  final tokens = <Token>[];
  var at = 0;
  for (final match in _pattern.allMatches(source)) {
    if (match.start > at) {
      tokens.add(Token(source.substring(at, match.start), TokenKind.plain));
    }
    tokens.add(Token(match[0] ?? '', _kindOf(match)));
    at = match.end;
  }
  if (at < source.length) {
    tokens.add(Token(source.substring(at), TokenKind.plain));
  }
  return tokens;
}

TokenKind _kindOf(RegExpMatch match) {
  for (final kind in TokenKind.values) {
    if (kind != TokenKind.plain && match.namedGroup(kind.name) != null) {
      return kind;
    }
  }
  return TokenKind.plain;
}
