import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';

/// Checks that a document read from disk can be shown and exported: every
/// widget type is registered, ids are unique and child counts follow the
/// ChildPolicy of each widget.
class DocumentValidator {
  const DocumentValidator(this._registry);

  final WidgetRegistry _registry;

  Either<Failure, Unit> validate(EditorDocument document) {
    final reason = _duplicateId(document.root, <String>{})
        ? DocumentFailureReason.invalidStructure
        : _reasonFor(_registry.violation(document.root));
    return reason == null
        ? const Right(unit)
        : Left(DocumentFailure(reason, 'Rejected document "${document.name}"'));
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
