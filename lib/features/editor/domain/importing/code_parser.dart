import 'package:flutter_ui_builder/features/editor/domain/importing/code_value.dart';

/// What a parser found in a piece of source.
class ParsedSource {
  const ParsedSource({this.widget, this.className, this.errors = const []});

  /// The widget expression: what a `build` method returns, or the source
  /// itself when it is a single expression.
  final CodeValue? widget;

  /// Name of the class that declares the build method, when there is one.
  final String? className;

  /// Syntax errors, each with the line it is on.
  final List<String> errors;
}

/// Reads Dart source without resolving it. Implemented in the data layer so
/// the domain does not depend on the analyzer package.
abstract interface class CodeParser {
  /// Finds the widget in [source], a widget class or a single expression.
  ParsedSource parse(String source);

  /// Reads one expression, or returns null when it is not valid Dart.
  CodeValue? parseExpression(String source);
}
