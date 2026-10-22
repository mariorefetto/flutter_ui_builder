final RegExp _wordPattern = RegExp('[A-Za-z0-9]+');
final RegExp _leadingDigit = RegExp('^[0-9]');

const String _fallbackWord = 'Generated';

List<String> _words(String text) =>
    _wordPattern.allMatches(text).map((m) => m[0] ?? '').toList();

/// Turns free text into a Dart class name prefix: "my screen" -> "MyScreen".
String pascalCase(String text) {
  final words = _words(
    text,
  ).map((word) => word[0].toUpperCase() + word.substring(1));
  final joined = words.join();
  if (joined.isEmpty) return _fallbackWord;
  return _leadingDigit.hasMatch(joined) ? '$_fallbackWord$joined' : joined;
}

/// Turns free text into a snake_case file name: "My Screen" -> "my_screen".
String snakeCase(String text) {
  final words = _words(text).map((word) => word.toLowerCase()).toList();
  if (words.isEmpty) return _fallbackWord.toLowerCase();
  final joined = words.join('_');
  return _leadingDigit.hasMatch(joined)
      ? '${_fallbackWord.toLowerCase()}_$joined'
      : joined;
}
