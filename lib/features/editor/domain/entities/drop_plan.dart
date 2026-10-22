/// Which edge of the target node a drop is closest to.
enum DropSide { before, after }

/// Where a dragged node ends up: under [parentId] at [index]
/// (null means "after the last child").
class DropPlan {
  const DropPlan({required this.parentId, this.index});

  final String parentId;
  final int? index;

  @override
  bool operator ==(Object other) =>
      other is DropPlan && other.parentId == parentId && other.index == index;

  @override
  int get hashCode => Object.hash(parentId, index);
}
