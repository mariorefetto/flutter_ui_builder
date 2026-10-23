import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/document_history.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/drop_plan.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/edit_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/component_usecases.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/edit_usecases.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/import_usecases.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/screen_usecases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/drop_resolver.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_use_cases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/drag_payload.dart';

part 'editor_cubit_screens.dart';
part 'editor_cubit_structure.dart';

/// Holds the document being edited with its undo history, the selection and
/// the clipboard.
class EditorCubit extends Cubit<EditorState> {
  EditorCubit({
    required EditorDocument initialDocument,
    required EditorUseCases useCases,
  }) : _useCases = useCases,
       _resolver = DropResolver(useCases),
       super(EditorState(history: DocumentHistory(present: initialDocument)));

  final EditorUseCases _useCases;
  final DropResolver _resolver;

  /// Selects [nodeId], or clears the selection when null or unknown.
  void select(String? nodeId) {
    final known = nodeId != null && state.document.root.find(nodeId) != null;
    emit(state.copyWith(selectedId: known ? nodeId : null));
  }

  void addNode({required String type, required String parentId, int? index}) {
    _applyEdit(
      _useCases.addNode(
        AddNodeParams(
          document: state.document,
          type: type,
          parentId: parentId,
          index: index,
        ),
      ),
      selectAffected: true,
    );
  }

  void moveNode({
    required String nodeId,
    required String parentId,
    int? index,
  }) {
    _applyEdit(
      _useCases.moveNode(
        MoveNodeParams(
          document: state.document,
          nodeId: nodeId,
          parentId: parentId,
          index: index,
        ),
      ),
      selectAffected: true,
    );
  }

  void removeNode(String nodeId) {
    _applyEdit(
      _useCases.removeNode(
        RemoveNodeParams(document: state.document, nodeId: nodeId),
      ),
      selectAffected: false,
    );
  }

  /// Where dropping [payload] on [targetId] would land, or null when the drop
  /// would be refused. Changes nothing.
  DropPlan? planDrop(
    DragPayload payload,
    String targetId,
    DropSide side, {
    bool preferInside = true,
  }) => _resolver
      .resolve(
        state.document,
        payload,
        targetId,
        side,
        preferInside: preferInside,
      )
      .fold((_) => null, (r) => r.plan);

  /// Applies the drop of [payload] on [targetId].
  void drop(
    DragPayload payload,
    String targetId,
    DropSide side, {
    bool preferInside = true,
  }) {
    _resolver
        .resolve(
          state.document,
          payload,
          targetId,
          side,
          preferInside: preferInside,
        )
        .fold(
          _reportFailure,
          (r) => _commit(r.edit.document, selectedId: r.edit.nodeId),
        );
  }

  /// Adds a widget next to or inside the selection (the root when nothing is
  /// selected). Keyboard and screen reader alternative to dragging.
  void addToSelection(String type, {Map<String, Object?> props = const {}}) =>
      drop(
        NewWidgetPayload(type, props: props),
        state.selectedId ?? state.document.root.id,
        DropSide.after,
      );

  /// Whether a widget of [type] could be added to the selection (or to the
  /// root when nothing is selected). The palette and the context menu list
  /// only what could.
  bool canAddToSelection(String type) =>
      planDrop(
        NewWidgetPayload(type),
        state.selectedId ?? state.document.root.id,
        DropSide.after,
      ) !=
      null;

  /// Whether a widget of [type] could go inside the selection. Only widgets
  /// that take children can hold anything, and only what their rules allow.
  bool canAddInside(String type) =>
      _selectionAllows((id) => _resolver.inside(state.document, id, type));

  /// Whether a widget of [type] could go right after the selection, in the
  /// selection's parent.
  bool canAddBeside(String type) =>
      _selectionAllows((id) => _resolver.beside(state.document, id, type));

  void addInsideSelection(String type) => _withSelection(
    (id) => _applyEdit(
      _resolver.inside(state.document, id, type),
      selectAffected: true,
    ),
  );

  void addBesideSelection(String type) => _withSelection(
    (id) => _applyEdit(
      _resolver.beside(state.document, id, type),
      selectAffected: true,
    ),
  );

  void removeSelected() => _withSelection(removeNode);

  /// Gives [nodeId] a name shown in the outline; a blank name clears it.
  void relabelNode(String nodeId, String label) => _applyEdit(
    _useCases.relabelNode(
      RelabelNodeParams(document: state.document, nodeId: nodeId, label: label),
    ),
    selectAffected: false,
  );

  /// Sets a property of [nodeId]; a null [value] restores the default.
  void updateProp(String nodeId, String name, Object? value) {
    _applyEdit(
      _useCases.updateNodeProp(
        UpdateNodePropParams(
          document: state.document,
          nodeId: nodeId,
          name: name,
          value: value,
        ),
      ),
      selectAffected: true,
    );
  }

  /// Replaces the whole document, for a new or an opened project. The undo
  /// history starts over; the clipboard stays, so a widget can be carried
  /// from one project to another.
  void replaceDocument(EditorDocument document) => emit(
    state.copyWith(
      history: DocumentHistory(present: document),
      selectedId: null,
      failure: null,
    ),
  );

  /// Makes the document that code was edited into the current one, as a single
  /// undo step. Widgets that did not move keep their ids, so the selection
  /// stays where it was when it still exists.
  void applyImported(ImportResult imported) {
    _useCases
        .applyImport(
          ApplyImportParams(previous: state.document, imported: imported),
        )
        .fold(_reportFailure, (document) {
          final selected = state.selectedId;
          final kept = selected != null && document.root.find(selected) != null;
          _commit(document, selectedId: kept ? selected : null);
        });
  }

  // The document with another screen open: not a step of the undo history.
  void _showDocument(EditorDocument document) => emit(
    state.copyWith(
      history: state.history.copyWith(present: document),
      selectedId: null,
      failure: null,
    ),
  );

  void _keepOnClipboard(WidgetNode node) =>
      emit(state.copyWith(clipboard: node));

  void undo() => _applyHistory(_useCases.undoEdit(state.history));

  void redo() => _applyHistory(_useCases.redoEdit(state.history));

  Either<Failure, EditResult> _pasteResult(WidgetNode clip) => _resolver.paste(
    state.document,
    clip,
    state.selectedId ?? state.document.root.id,
  );

  WidgetNode? _selectedNode() {
    final id = state.selectedId;
    return id == null ? null : state.document.root.find(id);
  }

  void _withSelection(void Function(String id) action) {
    final selected = state.selectedId;
    if (selected != null) action(selected);
  }

  bool _selectionAllows(Either<Failure, EditResult> Function(String id) edit) {
    final selected = state.selectedId;
    return selected != null && edit(selected).isRight();
  }

  void _applyEdit(
    Either<Failure, EditResult> result, {
    required bool selectAffected,
  }) {
    result.fold(
      _reportFailure,
      (edit) => _commit(
        edit.document,
        selectedId: selectAffected ? edit.nodeId : null,
      ),
    );
  }

  // An edit that changes nothing (a node dropped where it already is) must not
  // create an undo step.
  void _commit(EditorDocument next, {required String? selectedId}) {
    if (next == state.document) return;
    emit(
      state.copyWith(
        history: state.history.record(next),
        selectedId: selectedId,
        failure: null,
      ),
    );
  }

  void _applyHistory(Either<Failure, DocumentHistory> result) {
    result.fold(_reportFailure, (history) {
      final selected = state.selectedId;
      final stillThere =
          selected != null && history.present.root.find(selected) != null;
      emit(
        state.copyWith(
          history: history,
          selectedId: stillThere ? selected : null,
          failure: null,
        ),
      );
    });
  }

  // The failure is emitted once and cleared right away, so the same failure
  // twice in a row still reaches a BlocListener.
  void _reportFailure(Failure failure) {
    emit(state.copyWith(failure: failure));
    emit(state.copyWith(failure: null));
  }
}
