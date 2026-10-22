import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';

/// What could not be carried over from the code, so the user is told.
enum ImportIssueKind {
  /// A widget the builder does not have, replaced by its child or a placeholder.
  unknownWidget,

  /// An argument the widget has no property for, ignored.
  unsupportedArgument,

  /// An argument whose value is not a literal the importer can read, ignored.
  invalidValue,

  /// The code needed a Scaffold above it, so one was added.
  wrappedInScaffold,
}

class ImportIssue {
  const ImportIssue({
    required this.kind,
    required this.widgetType,
    this.argument = '',
  });

  final ImportIssueKind kind;

  /// The widget the issue is about, as written in the code.
  final String widgetType;

  /// The argument, for the kinds that are about one.
  final String argument;
}

/// The document built from code, with everything that was left out.
class ImportResult {
  const ImportResult({
    required this.document,
    required this.issues,
    this.named = false,
  });

  final EditorDocument document;
  final List<ImportIssue> issues;

  /// The name of the document comes from a class in the code. Without one the
  /// document has a default name that should not replace a real one.
  final bool named;
}
