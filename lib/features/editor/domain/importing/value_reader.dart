import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_parser.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_value.dart';

const String _placeholderName = '__value__';

const int _alphaShift = 24;
const int _redShift = 16;
const int _greenShift = 8;
const int _channelMax = 255;

/// The named colors of the Material palette that code commonly uses.
const Map<String, int> _namedColors = {
  'transparent': 0x00000000,
  'black': 0xFF000000,
  'white': 0xFFFFFFFF,
  'red': 0xFFF44336,
  'pink': 0xFFE91E63,
  'purple': 0xFF9C27B0,
  'deepPurple': 0xFF673AB7,
  'indigo': 0xFF3F51B5,
  'blue': 0xFF2196F3,
  'lightBlue': 0xFF03A9F4,
  'cyan': 0xFF00BCD4,
  'teal': 0xFF009688,
  'green': 0xFF4CAF50,
  'lightGreen': 0xFF8BC34A,
  'lime': 0xFFCDDC39,
  'yellow': 0xFFFFEB3B,
  'amber': 0xFFFFC107,
  'orange': 0xFFFF9800,
  'deepOrange': 0xFFFF5722,
  'brown': 0xFF795548,
  'grey': 0xFF9E9E9E,
  'blueGrey': 0xFF607D8B,
};

/// Turns the value of a constructor argument back into what a property stores,
/// the reverse of how the code generator writes it.
class ValueReader {
  ValueReader(this._parser);

  final CodeParser _parser;
  final Map<String, CodeValue?> _patterns = {};

  /// The value of [schema] read from [value], or null when [value] is not
  /// something the property can hold.
  Object? read(PropSchema schema, CodeValue value) {
    final template = schema.template;
    final inner = template == null ? value : _unwrap(template, value);
    if (inner == null) return null;
    return switch (schema.type) {
      PropType.string => inner is CodeString ? inner.value : null,
      PropType.number => _number(schema, inner),
      PropType.boolean => inner is CodeBool ? inner.value : null,
      PropType.color => color(inner),
      PropType.choice => _choice(schema, inner),
      PropType.edgeInsets => insets(inner),
    };
  }

  /// A number, or null for anything else.
  double? number(CodeValue value) => value is CodeNumber ? value.value : null;

  /// The ARGB value of `Color(0x...)`, `Color.fromARGB`, `Color.fromRGBO` or
  /// `Colors.name`.
  int? color(CodeValue value) {
    if (value is CodeIdentifier && value.prefix == 'Colors') {
      return _namedColors[value.name];
    }
    if (value is! CodeCall || value.name != 'Color') return null;
    final numbers = value.positional.map(number).toList();
    if (numbers.any((n) => n == null)) return null;
    final parts = numbers.whereType<double>().toList();
    return switch (value.constructor) {
      null when parts.length == 1 => parts.first.toInt(),
      'fromARGB' when parts.length == 4 => _argb(
        parts[0].round(),
        parts[1].round(),
        parts[2].round(),
        parts[3].round(),
      ),
      'fromRGBO' when parts.length == 4 => _argb(
        (parts[3] * _channelMax).round(),
        parts[0].round(),
        parts[1].round(),
        parts[2].round(),
      ),
      _ => null,
    };
  }

  /// Left, top, right and bottom of an `EdgeInsets` call, or null.
  List<double>? insets(CodeValue value) {
    if (value is CodeIdentifier &&
        value.prefix == 'EdgeInsets' &&
        value.name == 'zero') {
      return const [0, 0, 0, 0];
    }
    if (value is! CodeCall || value.name != 'EdgeInsets') return null;
    double named(String key) =>
        number(value.named[key] ?? const CodeUnknown('')) ?? 0;
    final first = value.positional.isEmpty ? null : number(value.positional[0]);
    return switch (value.constructor) {
      'all' when first != null => [first, first, first, first],
      'symmetric' => [
        named('horizontal'),
        named('vertical'),
        named('horizontal'),
        named('vertical'),
      ],
      'only' => [named('left'), named('top'), named('right'), named('bottom')],
      'fromLTRB' when value.positional.length == 4 => [
        for (final item in value.positional) number(item) ?? 0,
      ],
      _ => null,
    };
  }

  int _argb(int a, int r, int g, int b) =>
      (a << _alphaShift) | (r << _redShift) | (g << _greenShift) | b;

  Object? _number(PropSchema schema, CodeValue value) {
    if (value is! CodeNumber) return null;
    if (!schema.integer) return value.value;
    return value.isInteger ? value.value.round() : null;
  }

  Object? _choice(PropSchema schema, CodeValue value) {
    final literals = schema.literals;
    if (literals != null) {
      if (value is! CodeCall) return null;
      for (final entry in literals.entries) {
        final expected = _parser.parseExpression(entry.value);
        if (expected is CodeCall &&
            expected.qualifiedName == value.qualifiedName) {
          return entry.key;
        }
      }
      return null;
    }
    if (value is! CodeIdentifier) return null;
    final enumType = schema.enumType;
    if (enumType != null && value.prefix != null && value.prefix != enumType) {
      return null;
    }
    return schema.options.contains(value.name) ? value.name : null;
  }

  // The value inside a template such as `Text({})` or `Icon(Icons.{})`.
  CodeValue? _unwrap(String template, CodeValue value) {
    // Only the first braces count: a template may contain a closure, `() {}`.
    final pattern = _patterns.putIfAbsent(
      template,
      () => _parser.parseExpression(
        template.replaceFirst('{}', _placeholderName),
      ),
    );
    return pattern == null ? null : _unify(pattern, value);
  }

  // Matches [value] against [pattern] and returns what stands where the
  // placeholder is, or null when they do not match.
  CodeValue? _unify(CodeValue pattern, CodeValue value) {
    switch (pattern) {
      case CodeIdentifier(:final name, :final prefix)
          when name == _placeholderName:
        if (prefix == null) return value;
        return value is CodeIdentifier && value.prefix == prefix
            ? CodeIdentifier(value.name)
            : null;
      case CodeCall():
        return value is CodeCall && value.qualifiedName == pattern.qualifiedName
            ? _unifyCall(pattern, value)
            : null;
      case CodeList():
        return value is CodeList && value.items.length == pattern.items.length
            ? _firstCapture([
                for (var i = 0; i < pattern.items.length; i++)
                  _unify(pattern.items[i], value.items[i]),
              ])
            : null;
      case CodeFunction():
        return value is CodeFunction ? const CodeUnknown('') : null;
      default:
        return null;
    }
  }

  CodeValue? _unifyCall(CodeCall pattern, CodeCall value) {
    final captures = <CodeValue?>[];
    for (var i = 0; i < pattern.positional.length; i++) {
      if (i >= value.positional.length) return null;
      captures.add(_unify(pattern.positional[i], value.positional[i]));
    }
    for (final MapEntry(:key, value: inner) in pattern.named.entries) {
      final actual = value.named[key];
      if (actual == null) return null;
      captures.add(_unify(inner, actual));
    }
    return _firstCapture(captures);
  }

  // The placeholder's capture among [captures], or null when any part failed.
  CodeValue? _firstCapture(List<CodeValue?> captures) {
    if (captures.any((c) => c == null)) return null;
    for (final capture in captures.whereType<CodeValue>()) {
      if (capture is! CodeUnknown || capture.source.isNotEmpty) return capture;
    }
    // A pattern with no placeholder, such as `() {}`, matched as it is.
    return const CodeUnknown('');
  }
}
