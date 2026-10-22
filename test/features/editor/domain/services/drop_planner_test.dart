import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/drop_plan.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/drop_planner.dart';

void main() {
  final planner = DropPlanner(WidgetRegistry(builtinDefinitions));

  // Column(c) > [Text(a), Text(b), Padding(p) > Text(t)]
  const document = EditorDocument(
    name: 'test',
    root: WidgetNode(
      id: 'c',
      type: 'Column',
      children: [
        WidgetNode(id: 'a', type: 'Text'),
        WidgetNode(id: 'b', type: 'Text'),
        WidgetNode(
          id: 'p',
          type: 'Padding',
          children: [WidgetNode(id: 't', type: 'Text')],
        ),
      ],
    ),
  );

  Either<Failure, DropPlan> plan(
    String target,
    DropSide side, {
    String? moving,
    String childType = 'Text',
    bool preferInside = true,
  }) => planner.plan(
    document,
    targetId: target,
    side: side,
    childType: childType,
    movingNodeId: moving,
    preferInside: preferInside,
  );

  test('drops inside a container that accepts children', () {
    expect(plan('c', DropSide.after), const Right(DropPlan(parentId: 'c')));
  });

  test('drops beside a leaf, on the requested side', () {
    expect(
      plan('b', DropSide.before),
      const Right(DropPlan(parentId: 'c', index: 1)),
    );
    expect(
      plan('b', DropSide.after),
      const Right(DropPlan(parentId: 'c', index: 2)),
    );
  });

  test('drops beside a single-child container that is full', () {
    expect(
      plan('p', DropSide.before),
      const Right(DropPlan(parentId: 'c', index: 2)),
    );
  });

  test('accounts for the moved node when it precedes the target', () {
    expect(
      plan('b', DropSide.after, moving: 'a'),
      const Right(DropPlan(parentId: 'c', index: 1)),
    );
  });

  test('a single-child container is empty once its child is moved', () {
    expect(
      plan('p', DropSide.after, moving: 't'),
      const Right(DropPlan(parentId: 'p')),
    );
  });

  test('refuses dropping a node on itself or an unknown target', () {
    expect(plan('a', DropSide.after, moving: 'a').isLeft(), isTrue);
    expect(plan('zzz', DropSide.after).isLeft(), isTrue);
  });

  test('with preferInside off a container receives the drop beside it', () {
    expect(
      plan('p', DropSide.before, preferInside: false),
      const Right(DropPlan(parentId: 'c', index: 2)),
    );
    expect(
      plan('b', DropSide.after, preferInside: false),
      const Right(DropPlan(parentId: 'c', index: 2)),
    );
  });
}
