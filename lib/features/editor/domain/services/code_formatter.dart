/// Formats Dart source. Implemented in the data layer so the domain does not
/// depend on a formatter package.
abstract interface class CodeFormatter {
  /// Returns [source] formatted, or throws a FormatException when it is not
  /// valid Dart.
  String format(String source);
}
