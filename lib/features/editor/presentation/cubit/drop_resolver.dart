import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/drop_plan.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/edit_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/edit_usecases.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/plan_drop.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_use_cases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/drag_payload.dart';

/// Works out where a dragged or pasted widget would land and what the edit
/// would be, without changing anything. The cubit applies the result.
class DropResolver {
  const DropResolver(this._useCases);

  final EditorUseCases _useCases;

  /// The plan and the edit for dropping [payload] on [targetId], or the
  /// reason it is refused.
  Either<Failure, ({DropPlan plan, EditResult edit})> resolve(
    EditorDocument document,
    DragPayload payload,
    String targetId,
    DropSide side, {
    bool preferInside = true,
  }) {
    final childType = switch (payload) {
      MoveNodePayload(:final nodeId) => document.root.find(nodeId)?.type,
      NewWidgetPayload(:final type) => type,
    };
    if (childType == null) {
      return const Left(TreeFailure(TreeFailureReason.unknownNode));
    }
    return _plan(
      document,
      targetId,
      side,
      childType,
      movingId: payload is MoveNodePayload ? payload.nodeId : null,
      preferInside: preferInside,
    ).flatMap(
      (plan) => _execute(
        document,
        payload,
        plan,
      ).map((edit) => (plan: plan, edit: edit)),
    );
  }

  /// The edit that pastes [subtree] inside or beside [targetId].
  Either<Failure, EditResult> paste(
    EditorDocument document,
    WidgetNode subtree,
    String targetId,
  ) => _plan(document, targetId, DropSide.after, subtree.type).flatMap(
    (plan) => _useCases.pasteNode(
      PasteNodeParams(
        document: document,
        subtree: subtree,
        parentId: plan.parentId,
        index: plan.index,
      ),
    ),
  );

  /// The edit that adds a [type] widget inside [nodeId].
  Either<Failure, EditResult> inside(
    EditorDocument document,
    String nodeId,
    String type,
  ) => _useCases.addNode(
    AddNodeParams(document: document, type: type, parentId: nodeId),
  );

  /// The edit that adds a [type] widget right after [nodeId], in its parent.
  Either<Failure, EditResult> beside(
    EditorDocument document,
    String nodeId,
    String type,
  ) {
    final parent = document.root.parentOf(nodeId);
    if (parent == null) {
      return const Left(TreeFailure(TreeFailureReason.rootProtected));
    }
    final index = parent.children.indexWhere((child) => child.id == nodeId);
    return _useCases.addNode(
      AddNodeParams(
        document: document,
        type: type,
        parentId: parent.id,
        index: index + 1,
      ),
    );
  }

  Either<Failure, EditResult> duplicate(
    EditorDocument document,
    String nodeId,
  ) => _useCases.duplicateNode(
    RemoveNodeParams(document: document, nodeId: nodeId),
  );

  Either<Failure, EditResult> wrap(
    EditorDocument document,
    String nodeId,
    String wrapperType,
  ) => _useCases.wrapNode(
    WrapNodeParams(
      document: document,
      nodeId: nodeId,
      wrapperType: wrapperType,
    ),
  );

  Either<Failure, EditResult> unwrap(EditorDocument document, String nodeId) =>
      _useCases.unwrapNode(
        RemoveNodeParams(document: document, nodeId: nodeId),
      );

  Either<Failure, DropPlan> _plan(
    EditorDocument document,
    String targetId,
    DropSide side,
    String childType, {
    String? movingId,
    bool preferInside = true,
  }) => _useCases.planDrop(
    PlanDropParams(
      document: document,
      targetId: targetId,
      side: side,
      childType: childType,
      movingNodeId: movingId,
      preferInside: preferInside,
    ),
  );

  Either<Failure, EditResult> _execute(
    EditorDocument document,
    DragPayload payload,
    DropPlan plan,
  ) => switch (payload) {
    NewWidgetPayload(:final type, :final props) => _useCases.addNode(
      AddNodeParams(
        document: document,
        type: type,
        parentId: plan.parentId,
        index: plan.index,
        props: props,
      ),
    ),
    MoveNodePayload(:final nodeId) => _useCases.moveNode(
      MoveNodeParams(
        document: document,
        nodeId: nodeId,
        parentId: plan.parentId,
        index: plan.index,
      ),
    ),
  };
}
