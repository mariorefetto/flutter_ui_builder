import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_node_model.freezed.dart';
part 'widget_node_model.g.dart';

/// JSON representation of a WidgetNode.
@freezed
abstract class WidgetNodeModel with _$WidgetNodeModel {
  @JsonSerializable(explicitToJson: true, checked: true)
  const factory WidgetNodeModel({
    required String id,
    required String type,
    @JsonKey(includeIfNull: false) String? label,
    @Default(<String, dynamic>{}) Map<String, dynamic> props,
    @Default(<WidgetNodeModel>[]) List<WidgetNodeModel> children,
  }) = _WidgetNodeModel;

  factory WidgetNodeModel.fromJson(Map<String, dynamic> json) =>
      _$WidgetNodeModelFromJson(json);

  factory WidgetNodeModel.fromEntity(WidgetNode node) => WidgetNodeModel(
    id: node.id,
    type: node.type,
    label: node.label,
    props: Map<String, dynamic>.of(node.props),
    children: node.children.map(WidgetNodeModel.fromEntity).toList(),
  );

  // Freezed needs this private constructor to allow members like toEntity().
  const WidgetNodeModel._();

  WidgetNode toEntity() => WidgetNode(
    id: id,
    type: type,
    label: label,
    props: Map<String, Object?>.of(props),
    children: children.map((child) => child.toEntity()).toList(),
  );
}
