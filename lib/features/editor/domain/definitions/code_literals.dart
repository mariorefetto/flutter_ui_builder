import 'package:flutter_ui_builder/features/editor/domain/entities/edge_insets_value.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_child.dart';

const int _hexRadix = 16;
const int _colorHexDigits = 8;

/// Escapes [value] so it can be embedded in a single-quoted Dart string literal.
String dartString(String value) {
  final escaped = value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll(r'$', r'\$')
      .replaceAll('\n', r'\n');
  return "'$escaped'";
}

/// Writes [value] as a Dart double literal (14 becomes 14.0).
String dartDouble(double value) => value.toString();

/// Writes an ARGB [value] as a Color constructor call.
String dartColor(int value) {
  final hex = value.toRadixString(_hexRadix).toUpperCase();
  return 'Color(0x${hex.padLeft(_colorHexDigits, '0')})';
}

/// Writes [value] as an EdgeInsets constructor call.
String dartEdgeInsets(EdgeInsetsValue value) {
  final EdgeInsetsValue(:left, :top, :right, :bottom) = value;
  if (left == top && top == right && right == bottom) {
    return 'EdgeInsets.all(${dartDouble(left)})';
  }
  return 'EdgeInsets.fromLTRB(${dartDouble(left)}, ${dartDouble(top)}, '
      '${dartDouble(right)}, ${dartDouble(bottom)})';
}

/// Builds a named argument list, skipping entries whose value is null.
String dartArguments(Map<String, String?> arguments) => arguments.entries
    .where((entry) => entry.value != null)
    .map((entry) => '${entry.key}: ${entry.value}')
    .join(', ');

/// Applies [transform] to a non-null receiver; used to build optional
/// arguments without nested conditionals.
extension NullableLet<T extends Object> on T? {
  R? let<R>(R Function(T value) transform) {
    final value = this;
    return value == null ? null : transform(value);
  }
}

/// Writes the child list of a multi-child widget.
String dartChildren(List<GeneratedChild> children) =>
    '[${children.map((child) => child.code).join(', ')}]';

/// Writes the single child of a widget, or null when it has none.
String? dartChild(List<GeneratedChild> children) =>
    children.isEmpty ? null : children.first.code;
