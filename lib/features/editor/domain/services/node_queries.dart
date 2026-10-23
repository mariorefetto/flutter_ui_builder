import 'package:flutter_ui_builder/features/editor/domain/definitions/component_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';

const String _idPrefix = 'node_';

/// Read-only helpers over a node tree.
extension NodeQueries on WidgetNode {
  /// The node with [targetId] in this subtree, or null.
  WidgetNode? find(String targetId) {
    if (id == targetId) return this;
    for (final child in children) {
      final found = child.find(targetId);
      if (found != null) return found;
    }
    return null;
  }

  /// The parent of the node with [targetId] in this subtree, or null.
  WidgetNode? parentOf(String targetId) {
    for (final child in children) {
      if (child.id == targetId) return this;
      final found = child.parentOf(targetId);
      if (found != null) return found;
    }
    return null;
  }

  /// The nodes from this one down to the node with [targetId], or an empty
  /// list when it is not in this subtree.
  List<WidgetNode> pathTo(String targetId) {
    if (id == targetId) return [this];
    for (final child in children) {
      final below = child.pathTo(targetId);
      if (below.isNotEmpty) return [this, ...below];
    }
    return const [];
  }

  /// The ids of this subtree in reading order: a node, then its children.
  List<String> preorderIds() => [
    id,
    for (final child in children) ...child.preorderIds(),
  ];

  /// The screens that widgets in this subtree open, by name. Going back is
  /// not a screen.
  Set<String> navigationTargets() => {
    if (props[navigateToProp] case final String target
        when target.isNotEmpty && target != navigateBack)
      target,
    for (final child in children) ...child.navigationTargets(),
  };

  /// The components that widgets in this subtree show, by name.
  Set<String> componentTargets() => {
    if (props[componentProp] case final String name
        when type == componentType && name.isNotEmpty)
      name,
    for (final child in children) ...child.componentTargets(),
  };

  /// Number of nodes in this subtree, itself included.
  int countNodes() => children.fold(1, (total, c) => total + c.countNodes());

  /// An id not used anywhere in this subtree.
  String nextId() => '$_idPrefix${_highestSuffix() + 1}';

  /// The highest numeric suffix among the ids of this subtree.
  int highestSuffix() => _highestSuffix();

  /// A copy of this subtree whose ids are consecutive, starting at
  /// [firstSuffix], so it can join another document without clashing.
  WidgetNode renumbered(int firstSuffix) {
    var next = firstSuffix;
    WidgetNode visit(WidgetNode node) {
      final fresh = '$_idPrefix${next++}';
      return node.copyWith(
        id: fresh,
        children: [for (final child in node.children) visit(child)],
      );
    }

    return visit(this);
  }

  int _highestSuffix() {
    final own = id.startsWith(_idPrefix)
        ? int.tryParse(id.substring(_idPrefix.length)) ?? 0
        : 0;
    return children.fold(own, (best, c) {
      final value = c._highestSuffix();
      return value > best ? value : best;
    });
  }
}
