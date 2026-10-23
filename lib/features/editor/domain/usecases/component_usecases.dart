import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/component_params.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/component_rules.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';

class ComponentParams {
  const ComponentParams({
    required this.document,
    this.name = '',
    this.nodeId = '',
    this.prop = '',
  });

  final EditorDocument document;

  /// The name of the component to make.
  final String name;

  /// The widget the operation is about.
  final String nodeId;

  /// The property of the widget, for binding it to a parameter.
  final String prop;
}

class AddComponent implements SyncUseCase<EditorDocument, ComponentParams> {
  const AddComponent(this._editor);

  final ScreenEditor _editor;

  @override
  Either<Failure, EditorDocument> call(ComponentParams params) =>
      _editor.addComponent(params.document, params.name);
}

/// Turns a widget and everything in it into a component, and puts a use of the
/// component in its place.
class ExtractComponent implements SyncUseCase<EditorDocument, ComponentParams> {
  const ExtractComponent(this._editor, this._registry);

  final ScreenEditor _editor;
  final WidgetRegistry _registry;

  @override
  Either<Failure, EditorDocument> call(ComponentParams params) =>
      _editor.extract(
        params.document,
        params.nodeId,
        params.name,
        canBeRoot: (type) => canBeComponentRoot(_registry, type),
      );
}

/// Replaces a use of a component with a copy of what it holds.
class DetachComponent implements SyncUseCase<EditorDocument, ComponentParams> {
  const DetachComponent(this._editor);

  final ScreenEditor _editor;

  @override
  Either<Failure, EditorDocument> call(ComponentParams params) =>
      _editor.detach(params.document, params.nodeId);
}

/// Binds a property of the open component to a parameter. The parameter's
/// name is in [ComponentParams.name].
class BindProp implements SyncUseCase<EditorDocument, ComponentParams> {
  const BindProp(this._params);

  final ComponentParamsEditor _params;

  @override
  Either<Failure, EditorDocument> call(ComponentParams params) =>
      _params.bind(params.document, params.nodeId, params.prop, params.name);
}

class UnbindProp implements SyncUseCase<EditorDocument, ComponentParams> {
  const UnbindProp(this._params);

  final ComponentParamsEditor _params;

  @override
  Either<Failure, EditorDocument> call(ComponentParams params) =>
      _params.unbind(params.document, params.nodeId, params.prop);
}
