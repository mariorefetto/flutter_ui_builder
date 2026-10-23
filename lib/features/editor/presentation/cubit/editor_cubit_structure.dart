part of 'editor_cubit.dart';

/// Moving the selection around the tree, and the operations that copy,
/// paste and restructure the selected widget.
extension EditorStructure on EditorCubit {
  /// Moves the selection to the widget before or after it in reading order.
  void selectNeighbour({required bool next}) {
    final ids = state.document.root.preorderIds();
    final selected = state.selectedId;
    final index = selected == null ? -1 : ids.indexOf(selected);
    final target = next ? index + 1 : index - 1;
    if (target >= 0 && target < ids.length) select(ids[target]);
  }

  /// Moves the selection to the parent of the selected widget.
  void selectParent() => _withSelection((id) {
    final parent = state.document.root.parentOf(id);
    if (parent != null) select(parent.id);
  });

  /// Moves the selection to the first widget inside the selected one.
  void selectFirstChild() => _withSelection((id) {
    final node = state.document.root.find(id);
    if (node != null && node.children.isNotEmpty) {
      select(node.children.first.id);
    }
  });

  /// Moves the selected widget one place up or down among its siblings.
  void moveSelectedBy(int step) => _withSelection((id) {
    final parent = state.document.root.parentOf(id);
    if (parent == null) return;
    final index = parent.children.indexWhere((child) => child.id == id);
    final target = index + step;
    if (target < 0 || target >= parent.children.length) return;
    moveNode(nodeId: id, parentId: parent.id, index: target);
  });

  /// Copies the selected widget with everything inside it.
  void copy() {
    final node = _selectedNode();
    if (node != null) _keepOnClipboard(node);
  }

  /// Copies the selected widget, then removes it.
  void cut() {
    if (!canCut) return;
    copy();
    removeSelected();
  }

  bool get hasSelection => state.selectedId != null;

  /// The root cannot be removed, so it cannot be cut either.
  bool get canCut => hasSelection && state.selectedId != state.document.root.id;

  /// Pastes the clipboard inside or beside the selection.
  void paste() {
    final clip = state.clipboard;
    if (clip == null) return;
    _applyEdit(_pasteResult(clip), selectAffected: true);
  }

  bool get canPaste {
    final clip = state.clipboard;
    return clip != null && _pasteResult(clip).isRight();
  }

  void duplicateSelected() => state.isMultiSelection
      ? _duplicateSelection()
      : _withSelection(
          (id) => _applyEdit(
            _resolver.duplicate(state.document, id),
            selectAffected: true,
          ),
        );

  bool get canDuplicate =>
      _selectionAllows((id) => _resolver.duplicate(state.document, id));

  /// Puts a new widget of [type] around the selection.
  void wrapSelected(String type) => state.isMultiSelection
      ? _applyEdit(_wrapSelection(type), selectAffected: true)
      : _withSelection(
          (id) => _applyEdit(
            _resolver.wrap(state.document, id, type),
            selectAffected: true,
          ),
        );

  bool canWrapSelection(String type) => state.isMultiSelection
      ? _wrapSelection(type).isRight()
      : _selectionAllows((id) => _resolver.wrap(state.document, id, type));

  /// Replaces the selection with the widgets inside it.
  void unwrapSelected() => _withSelection(
    (id) =>
        _applyEdit(_resolver.unwrap(state.document, id), selectAffected: true),
  );

  bool get canUnwrap =>
      _selectionAllows((id) => _resolver.unwrap(state.document, id));
}
