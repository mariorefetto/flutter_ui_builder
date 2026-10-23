import 'package:flutter_ui_builder/features/editor/domain/entities/component_param.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_screen.freezed.dart';

/// A screen or a component of the project that is not the one being edited.
/// A component is a widget made once and used in several places.
@freezed
abstract class ProjectScreen with _$ProjectScreen {
  const factory ProjectScreen({
    required String name,
    required WidgetNode root,
    @Default(false) bool component,

    /// What a component takes from where it is used.
    @Default(<ComponentParam>[]) List<ComponentParam> params,
  }) = _ProjectScreen;
}
