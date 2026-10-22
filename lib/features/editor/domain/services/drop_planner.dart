import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/drop_plan.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';

/// Decides where a drop on a target node lands.
///
/// A target that can take more children receives the node inside itself.
/// Any other target (a leaf, or a single-child widget that is already full)
/// receives it next to itself, in its parent.
class DropPlanner {
  const DropPlanner(this._registry);

  final WidgetRegistry _registry;

  /// [childType] is the type of the widget being dropped; [movingNodeId] is
  /// set when an existing node is being moved. With [preferInside] off the
  /// drop always goes next to the target, never into it.
  Either<Failure, DropPlan> plan(
    EditorDocument document, {
    required String targetId,
    required DropSide side,
    required String childType,
    String? movingNodeId,
    bool preferInside = true,
  }) {
    final target = document.root.find(targetId);
    if (target == null) return _fail(TreeFailureReason.unknownParent);
    if (targetId == movingNodeId) return _fail(TreeFailureReason.cyclicMove);
    if (preferInside && _acceptsInside(target, childType, movingNodeId)) {
      return Right(DropPlan(parentId: targetId));
    }
    final parent = document.root.parentOf(targetId);
    if (parent == null) return _fail(TreeFailureReason.childNotAllowed);
    return Right(_besideTarget(parent, targetId, side, movingNodeId));
  }

  bool _acceptsInside(
    WidgetNode target,
    String childType,
    String? movingNodeId,
  ) {
    final siblings = [
      for (final child in target.children)
        if (child.id != movingNodeId) child.type,
    ];
    return _registry.admitOrWrap(target.type, childType, siblings) == null;
  }

  DropPlan _besideTarget(
    WidgetNode parent,
    String targetId,
    DropSide side,
    String? movingNodeId,
  ) {
    final ids = parent.children.map((child) => child.id).toList();
    var index = ids.indexOf(targetId) + (side == DropSide.after ? 1 : 0);
    // The index refers to the children after the moved node is detached.
    final movingIndex = movingNodeId == null ? -1 : ids.indexOf(movingNodeId);
    if (movingIndex >= 0 && movingIndex < index) index -= 1;
    return DropPlan(parentId: parent.id, index: index);
  }

  Either<Failure, DropPlan> _fail(TreeFailureReason reason) =>
      Left(TreeFailure(reason));
}
