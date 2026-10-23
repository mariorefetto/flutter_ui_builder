import 'package:flutter_ui_builder/features/editor/data/models/component_param_json.dart';
import 'package:flutter_ui_builder/features/editor/data/models/widget_node_model.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_screen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_screen_model.freezed.dart';
part 'project_screen_model.g.dart';

/// JSON representation of a ProjectScreen.
@freezed
abstract class ProjectScreenModel with _$ProjectScreenModel {
  @JsonSerializable(explicitToJson: true, checked: true)
  const factory ProjectScreenModel({
    required String name,
    required WidgetNodeModel root,
    @Default(false) bool component,
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> params,
  }) = _ProjectScreenModel;

  factory ProjectScreenModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectScreenModelFromJson(json);

  factory ProjectScreenModel.fromEntity(ProjectScreen screen) =>
      ProjectScreenModel(
        name: screen.name,
        root: WidgetNodeModel.fromEntity(screen.root),
        component: screen.component,
        params: paramsToJson(screen.params),
      );

  const ProjectScreenModel._();

  ProjectScreen toEntity() => ProjectScreen(
    name: name,
    root: root.toEntity(),
    component: component,
    params: paramsFromJson(params),
  );
}
