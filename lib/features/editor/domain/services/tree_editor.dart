import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/edit_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';

/// Structural edits of the widget tree. Every method returns a new document
/// and never changes its input; the ChildPolicy of the target parent is
/// always enforced.
class TreeEditor {
  const TreeEditor(this._registry);

  final WidgetRegistry _registry;

  /// Adds a new node of [type] under [parentId] at [index] (default: last).
  Either<Failure, EditResult> add(
    EditorDocument document, {
    required String type,
    required String parentId,
    int? index,
  }) {
    if (!_registry.contains(type)) return _fail(TreeFailureReason.unknownType);
    final parent = document.root.find(parentId);
    if (parent == null) return _fail(TreeFailureReason.unknownParent);
    final node = WidgetNode(id: document.root.nextId(), type: type);
    return _insert(document, parent, node, index);
  }

  /// Moves the node [nodeId] under [parentId] at [index] (default: last).
  /// [index] refers to the parent's children after the node is detached.
  Either<Failure, EditResult> move(
    EditorDocument document, {
    required String nodeId,
    required String parentId,
    int? index,
  }) {
    final node = document.root.find(nodeId);
    if (node == null) return _fail(TreeFailureReason.unknownNode);
    if (nodeId == document.root.id) {
      return _fail(TreeFailureReason.rootProtected);
    }
    if (node.find(parentId) != null) return _fail(TreeFailureReason.cyclicMove);
    final detached = document.copyWith(root: _detach(document.root, nodeId));
    final parent = detached.root.find(parentId);
    if (parent == null) return _fail(TreeFailureReason.unknownParent);
    return _insert(detached, parent, node, index);
  }

  /// Removes the node [nodeId] and its subtree. The result points at the
  /// former parent.
  Either<Failure, EditResult> remove(EditorDocument document, String nodeId) {
    if (document.root.find(nodeId) == null) {
      return _fail(TreeFailureReason.unknownNode);
    }
    final parent = document.root.parentOf(nodeId);
    if (parent == null) return _fail(TreeFailureReason.rootProtected);
    return Right(
      EditResult(
        document: document.copyWith(root: _detach(document.root, nodeId)),
        nodeId: parent.id,
      ),
    );
  }

  /// Sets property [name] of [nodeId] to [value]. A null [value] removes the
  /// stored value so the schema default applies again.
  Either<Failure, EditResult> updateProp(
    EditorDocument document, {
    required String nodeId,
    required String name,
    Object? value,
  }) {
    final node = document.root.find(nodeId);
    if (node == null) return _fail(TreeFailureReason.unknownNode);
    final schema = _registry
        .definitionFor(node.type)
        .props
        .where((prop) => prop.name == name)
        .firstOrNull;
    if (schema == null) return _fail(TreeFailureReason.unknownProp);
    if (value != null && !schema.accepts(value)) {
      return _fail(TreeFailureReason.invalidValue);
    }
    final props = {...node.props};
    value == null ? props.remove(name) : props[name] = value;
    final root = _mapNode(
      document.root,
      nodeId,
      (target) => target.copyWith(props: props),
    );
    return Right(
      EditResult(
        document: document.copyWith(root: root),
        nodeId: nodeId,
      ),
    );
  }

  /// Names the node [nodeId], or clears its name when [label] is blank.
  Either<Failure, EditResult> relabel(
    EditorDocument document,
    String nodeId,
    String label,
  ) {
    if (document.root.find(nodeId) == null) {
      return _fail(TreeFailureReason.unknownNode);
    }
    final trimmed = label.trim();
    final root = _mapNode(
      document.root,
      nodeId,
      (node) => node.copyWith(label: trimmed.isEmpty ? null : trimmed),
    );
    return Right(
      EditResult(
        document: document.copyWith(root: root),
        nodeId: nodeId,
      ),
    );
  }

  /// Adds a copy of [subtree], with fresh ids, under [parentId] at [index]
  /// (default: last). Used to paste.
  Either<Failure, EditResult> insertSubtree(
    EditorDocument document,
    WidgetNode subtree, {
    required String parentId,
    int? index,
  }) {
    if (!_allKnown(subtree)) return _fail(TreeFailureReason.unknownType);
    final parent = document.root.find(parentId);
    if (parent == null) return _fail(TreeFailureReason.unknownParent);
    final copy = subtree.renumbered(document.root.highestSuffix() + 1);
    return _insert(document, parent, copy, index);
  }

  /// Copies the node [nodeId] with its subtree right after the original.
  Either<Failure, EditResult> duplicate(
    EditorDocument document,
    String nodeId,
  ) {
    final node = document.root.find(nodeId);
    if (node == null) return _fail(TreeFailureReason.unknownNode);
    final parent = document.root.parentOf(nodeId);
    if (parent == null) return _fail(TreeFailureReason.rootProtected);
    final index = parent.children.indexWhere((child) => child.id == nodeId);
    return insertSubtree(document, node, parentId: parent.id, index: index + 1);
  }

  /// Puts a new [wrapperType] node where [nodeId] is, with that node as its
  /// child. The result points at the wrapper.
  Either<Failure, EditResult> wrap(
    EditorDocument document, {
    required String nodeId,
    required String wrapperType,
  }) {
    if (!_registry.contains(wrapperType)) {
      return _fail(TreeFailureReason.unknownType);
    }
    final node = document.root.find(nodeId);
    if (node == null) return _fail(TreeFailureReason.unknownNode);
    final wrapper = WidgetNode(
      id: document.root.nextId(),
      type: wrapperType,
      children: [node],
    );
    final root = nodeId == document.root.id
        ? wrapper
        : _replace(document.root, nodeId, [wrapper]);
    return _restructured(document, root, wrapper.id);
  }

  /// Replaces the node [nodeId] with its own children. The result points at
  /// the first child that took its place.
  Either<Failure, EditResult> unwrap(EditorDocument document, String nodeId) {
    final node = document.root.find(nodeId);
    if (node == null) return _fail(TreeFailureReason.unknownNode);
    if (node.children.isEmpty) return _fail(TreeFailureReason.noChildren);
    final isRoot = nodeId == document.root.id;
    // A root can only be replaced by a single child.
    if (isRoot && node.children.length != 1) {
      return _fail(TreeFailureReason.rootProtected);
    }
    final root = isRoot
        ? node.children.first
        : _replace(document.root, nodeId, node.children);
    return _restructured(document, root, node.children.first.id);
  }

  Either<Failure, EditResult> _restructured(
    EditorDocument document,
    WidgetNode root,
    String nodeId,
  ) {
    final broken = _registry.violation(root);
    if (broken != null) return _fail(broken);
    return Right(
      EditResult(
        document: document.copyWith(root: root),
        nodeId: nodeId,
      ),
    );
  }

  // The node itself, or inside the wrapper its parent forbids it without.
  WidgetNode _wrappedIfNeeded(
    EditorDocument document,
    WidgetNode parent,
    WidgetNode node,
    List<String> siblings,
  ) {
    if (_registry.admit(parent.type, node.type, siblings) == null) return node;
    final wrapper = _registry.autoWrapperFor(parent.type, node.type, siblings);
    if (wrapper == null) return node;
    final highest = math.max(
      document.root.highestSuffix(),
      node.highestSuffix(),
    );
    return WidgetNode(
      id: 'node_${highest + 1}',
      type: wrapper,
      children: [node],
    );
  }

  bool _allKnown(WidgetNode node) =>
      _registry.contains(node.type) && node.children.every(_allKnown);

  // Swaps the node [targetId] for [replacement] in its parent's children.
  WidgetNode _replace(
    WidgetNode node,
    String targetId,
    List<WidgetNode> replacement,
  ) => node.copyWith(
    children: [
      for (final child in node.children)
        if (child.id == targetId)
          ...replacement
        else
          _replace(child, targetId, replacement),
    ],
  );

  Either<Failure, EditResult> _insert(
    EditorDocument document,
    WidgetNode parent,
    WidgetNode node,
    int? index,
  ) {
    final count = parent.children.length;
    final position = index ?? count;
    final siblings = parent.children.map((child) => child.type).toList();
    final refusal = _registry.admitOrWrap(parent.type, node.type, siblings);
    if (refusal != null) return _fail(refusal);
    // The wrapper, when one is needed, goes where the node would have gone.
    final placed = _wrappedIfNeeded(document, parent, node, siblings);
    if (position < 0 || position > count) {
      return _fail(TreeFailureReason.invalidIndex);
    }
    final root = _mapNode(document.root, parent.id, (target) {
      final children = [...target.children]..insert(position, placed);
      return target.copyWith(children: children);
    });
    // The new child and everything under it must also suit their new
    // ancestors, which only the whole tree can tell.
    final broken = _registry.violation(root);
    if (broken != null) return _fail(broken);
    return Right(
      EditResult(
        document: document.copyWith(root: root),
        nodeId: node.id,
      ),
    );
  }

  WidgetNode _detach(WidgetNode root, String nodeId) => root.copyWith(
    children: [
      for (final child in root.children)
        if (child.id != nodeId) _detach(child, nodeId),
    ],
  );

  WidgetNode _mapNode(
    WidgetNode node,
    String targetId,
    WidgetNode Function(WidgetNode) transform,
  ) {
    if (node.id == targetId) return transform(node);
    return node.copyWith(
      children: [
        for (final child in node.children) _mapNode(child, targetId, transform),
      ],
    );
  }

  Either<Failure, EditResult> _fail(TreeFailureReason reason) =>
      Left(TreeFailure(reason));
}
