/// A piece of Dart source reduced to what the importer cares about: calls,
/// literals, lists and identifiers. It carries no analyzer types, so the
/// domain stays independent of the parser that produced it.
sealed class CodeValue {
  const CodeValue();
}

/// A call such as `Column(...)`, `Image.network(...)` or `EdgeInsets.all(8)`.
/// For `Image.network` the [name] is `Image` and the [constructor] `network`.
final class CodeCall extends CodeValue {
  const CodeCall({
    required this.name,
    this.constructor,
    this.positional = const [],
    this.named = const {},
  });

  final String name;
  final String? constructor;
  final List<CodeValue> positional;
  final Map<String, CodeValue> named;

  /// `Image.network` or `Column`: how the call is written.
  String get qualifiedName => constructor == null ? name : '$name.$constructor';
}

final class CodeString extends CodeValue {
  const CodeString(this.value);

  final String value;
}

final class CodeNumber extends CodeValue {
  const CodeNumber(this.value, {required this.isInteger});

  final double value;

  /// Written without a fractional part, as in `8` or `0xFF112233`.
  final bool isInteger;
}

final class CodeBool extends CodeValue {
  const CodeBool(this.value);

  final bool value;
}

final class CodeList extends CodeValue {
  const CodeList(this.items);

  final List<CodeValue> items;
}

/// A name, possibly with a prefix: `center` or `Alignment.center`.
final class CodeIdentifier extends CodeValue {
  const CodeIdentifier(this.name, {this.prefix});

  final String name;
  final String? prefix;
}

/// A closure or function. Only a body that is a single expression is read,
/// as in `() => Navigator.pop(context)`; any other is left out.
final class CodeFunction extends CodeValue {
  const CodeFunction({this.body});

  final CodeValue? body;
}

/// Anything else, kept as source text for the report.
final class CodeUnknown extends CodeValue {
  const CodeUnknown(this.source);

  final String source;
}
