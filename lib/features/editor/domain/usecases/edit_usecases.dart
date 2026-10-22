import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/edit_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/tree_editor.dart';

class AddNodeParams {
  const AddNodeParams({
    required this.document,
    required this.type,
    required this.parentId,
    this.index,
  });

  final EditorDocument document;
  final String type;
  final String parentId;
  final int? index;
}

class AddNode implements SyncUseCase<EditResult, AddNodeParams> {
  const AddNode(this._editor);

  final TreeEditor _editor;

  @override
  Either<Failure, EditResult> call(AddNodeParams params) => _editor.add(
    params.document,
    type: params.type,
    parentId: params.parentId,
    index: params.index,
  );
}

class MoveNodeParams {
  const MoveNodeParams({
    required this.document,
    required this.nodeId,
    required this.parentId,
    this.index,
  });

  final EditorDocument document;
  final String nodeId;
  final String parentId;
  final int? index;
}

class MoveNode implements SyncUseCase<EditResult, MoveNodeParams> {
  const MoveNode(this._editor);

  final TreeEditor _editor;

  @override
  Either<Failure, EditResult> call(MoveNodeParams params) => _editor.move(
    params.document,
    nodeId: params.nodeId,
    parentId: params.parentId,
    index: params.index,
  );
}

class RemoveNodeParams {
  const RemoveNodeParams({required this.document, required this.nodeId});

  final EditorDocument document;
  final String nodeId;
}

class RemoveNode implements SyncUseCase<EditResult, RemoveNodeParams> {
  const RemoveNode(this._editor);

  final TreeEditor _editor;

  @override
  Either<Failure, EditResult> call(RemoveNodeParams params) =>
      _editor.remove(params.document, params.nodeId);
}

class UpdateNodePropParams {
  const UpdateNodePropParams({
    required this.document,
    required this.nodeId,
    required this.name,
    this.value,
  });

  final EditorDocument document;
  final String nodeId;
  final String name;

  /// Null clears the property.
  final Object? value;
}

class UpdateNodeProp implements SyncUseCase<EditResult, UpdateNodePropParams> {
  const UpdateNodeProp(this._editor);

  final TreeEditor _editor;

  @override
  Either<Failure, EditResult> call(UpdateNodePropParams params) =>
      _editor.updateProp(
        params.document,
        nodeId: params.nodeId,
        name: params.name,
        value: params.value,
      );
}

class DuplicateNode implements SyncUseCase<EditResult, RemoveNodeParams> {
  const DuplicateNode(this._editor);

  final TreeEditor _editor;

  @override
  Either<Failure, EditResult> call(RemoveNodeParams params) =>
      _editor.duplicate(params.document, params.nodeId);
}

class PasteNodeParams {
  const PasteNodeParams({
    required this.document,
    required this.subtree,
    required this.parentId,
    this.index,
  });

  final EditorDocument document;
  final WidgetNode subtree;
  final String parentId;
  final int? index;
}

class PasteNode implements SyncUseCase<EditResult, PasteNodeParams> {
  const PasteNode(this._editor);

  final TreeEditor _editor;

  @override
  Either<Failure, EditResult> call(PasteNodeParams params) =>
      _editor.insertSubtree(
        params.document,
        params.subtree,
        parentId: params.parentId,
        index: params.index,
      );
}

class WrapNodeParams {
  const WrapNodeParams({
    required this.document,
    required this.nodeId,
    required this.wrapperType,
  });

  final EditorDocument document;
  final String nodeId;
  final String wrapperType;
}

class WrapNode implements SyncUseCase<EditResult, WrapNodeParams> {
  const WrapNode(this._editor);

  final TreeEditor _editor;

  @override
  Either<Failure, EditResult> call(WrapNodeParams params) => _editor.wrap(
    params.document,
    nodeId: params.nodeId,
    wrapperType: params.wrapperType,
  );
}

class UnwrapNode implements SyncUseCase<EditResult, RemoveNodeParams> {
  const UnwrapNode(this._editor);

  final TreeEditor _editor;

  @override
  Either<Failure, EditResult> call(RemoveNodeParams params) =>
      _editor.unwrap(params.document, params.nodeId);
}

class RelabelNodeParams {
  const RelabelNodeParams({
    required this.document,
    required this.nodeId,
    required this.label,
  });

  final EditorDocument document;
  final String nodeId;
  final String label;
}

class RelabelNode implements SyncUseCase<EditResult, RelabelNodeParams> {
  const RelabelNode(this._editor);

  final TreeEditor _editor;

  @override
  Either<Failure, EditResult> call(RelabelNodeParams params) =>
      _editor.relabel(params.document, params.nodeId, params.label);
}
