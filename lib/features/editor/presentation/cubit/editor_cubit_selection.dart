part of 'editor_cubit.dart';

/// Picking several widgets, and the edits that work on all of them.
extension EditorMultiSelection on EditorCubit {
  /// Adds [nodeId] to the selection, or takes it out when it is in. The one
  /// picked last is the main one, which the properties panel shows.
  void toggleSelect(String nodeId) {
    if (state.document.root.find(nodeId) == null) return;
    final all = [...state.selectedIds];
    if (all.contains(nodeId)) {
      all.remove(nodeId);
    } else {
      all.insert(0, nodeId);
    }
    _setSelection(all.isEmpty ? null : all.first, {...all.skip(1)});
  }

  /// Sets the property [name] of every selected widget, as one undo step. The
  /// widgets must all be of one type; otherwise only the main one changes.
  void updatePropOfSelection(String name, Object? value) {
    final ids = _sameTypeSelection();
    var document = state.document;
    for (final id in ids) {
      final result = _useCases.updateNodeProp(
        UpdateNodePropParams(
          document: document,
          nodeId: id,
          name: name,
          value: value,
        ),
      );
      // One refusal stops the edit, so the widgets are never half changed.
      if (result.isLeft()) {
        result.fold(_reportFailure, (_) {});
        return;
      }
      result.fold((_) {}, (edit) => document = edit.document);
    }
    _commit(
      document,
      selectedId: state.selectedId,
      keepSelection: ids.length > 1,
    );
  }

  /// The selected widgets that a property edit reaches: all of them when they
  /// are of one type, else the main one.
  List<String> _sameTypeSelection() {
    final ids = state.selectedIds;
    final types = {for (final id in ids) state.document.root.find(id)?.type};
    return types.length == 1 ? ids : [?state.selectedId];
  }

  void _removeSelection() {
    var document = state.document;
    for (final id in state.selectedIds) {
      // One removed along with the widget it was in is already gone.
      if (document.root.find(id) == null) continue;
      final result = _useCases.removeNode(
        RemoveNodeParams(document: document, nodeId: id),
      );
      if (result.isLeft()) {
        result.fold(_reportFailure, (_) {});
        return;
      }
      result.fold((_) {}, (edit) => document = edit.document);
    }
    _commit(document, selectedId: null);
  }

  void _duplicateSelection() {
    var document = state.document;
    String? last;
    for (final id in state.selectedIds) {
      if (document.root.find(id) == null) continue;
      final result = _resolver.duplicate(document, id);
      if (result.isLeft()) {
        result.fold(_reportFailure, (_) {});
        return;
      }
      result.fold((_) {}, (edit) {
        document = edit.document;
        last = edit.nodeId;
      });
    }
    _commit(document, selectedId: last);
  }

  Either<Failure, EditResult> _wrapSelection(String type) =>
      _useCases.wrapNodes(
        WrapNodesParams(
          document: state.document,
          nodeIds: state.selectedIds,
          wrapperType: type,
        ),
      );
}
