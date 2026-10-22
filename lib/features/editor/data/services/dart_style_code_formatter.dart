import 'package:dart_style/dart_style.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/code_formatter.dart';

class DartStyleCodeFormatter implements CodeFormatter {
  const DartStyleCodeFormatter();

  @override
  String format(String source) {
    try {
      return DartFormatter(
        languageVersion: DartFormatter.latestLanguageVersion,
      ).format(source);
    } on FormatterException catch (e) {
      // dart_style reports invalid code with its own exception type.
      throw FormatException(e.message());
    }
  }
}
