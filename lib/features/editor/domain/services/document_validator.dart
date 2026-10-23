import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/identifier_names.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';

/// Checks that a document read from disk can be shown and exported: every
/// widget type is registered, ids are unique and child counts follow the
/// ChildPolicy of each widget.
class DocumentValidator {
  const DocumentValidator(this._registry);

  final WidgetRegistry _registry;

  Either<Failure, Unit> validate(EditorDocument document) {
    final reason = _screensReason(document);
    return reason == null
        ? const Right(unit)
        : Left(DocumentFailure(reason, 'Rejected document "${document.name}"'));
  }

  // Every screen is checked, and no two may write the same class.
  DocumentFailureReason? _screensReason(EditorDocument document) {
    const editor = ScreenEditor();
    final names = editor.namesOf(document).map(pascalCase).toList();
    if (names.toSet().length != names.length) {
      return DocumentFailureReason.invalidStructure;
    }
    for (final entry in editor.entriesOf(document)) {
      final reason = _duplicateId(entry.root, <String>{})
          ? DocumentFailureReason.invalidStructure
          : _reasonFor(
              _registry.violation(entry.root, detached: entry.component),
            );
      if (reason != null) return reason;
    }
    return null;
  }

  bool _duplicateId(WidgetNode node, Set<String> seen) =>
      !seen.add(node.id) ||
      node.children.any((child) => _duplicateId(child, seen));

  DocumentFailureReason? _reasonFor(TreeFailureReason? violation) =>
      switch (violation) {
        null => null,
        TreeFailureReason.unknownType => DocumentFailureReason.unknownWidget,
        _ => DocumentFailureReason.invalidStructure,
      };
}
