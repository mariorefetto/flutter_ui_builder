import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/drop_plan.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/drop_planner.dart';

class PlanDropParams {
  const PlanDropParams({
    required this.document,
    required this.targetId,
    required this.side,
    required this.childType,
    this.movingNodeId,
    this.preferInside = true,
  });

  final EditorDocument document;
  final String targetId;
  final DropSide side;
  final String childType;
  final String? movingNodeId;
  final bool preferInside;
}

class PlanDrop implements SyncUseCase<DropPlan, PlanDropParams> {
  const PlanDrop(this._planner);

  final DropPlanner _planner;

  @override
  Either<Failure, DropPlan> call(PlanDropParams params) => _planner.plan(
    params.document,
    targetId: params.targetId,
    side: params.side,
    childType: params.childType,
    movingNodeId: params.movingNodeId,
    preferInside: params.preferInside,
  );
}
