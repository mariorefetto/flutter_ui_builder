import 'package:flutter_ui_builder/features/editor/data/models/widget_node_model.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_document_model.freezed.dart';
part 'editor_document_model.g.dart';

/// JSON representation of an EditorDocument, the format saved to disk.
@freezed
abstract class EditorDocumentModel with _$EditorDocumentModel {
  @JsonSerializable(explicitToJson: true, checked: true)
  const factory EditorDocumentModel({
    required String name,
    required WidgetNodeModel root,
    @Default(currentSchemaVersion) int schemaVersion,
  }) = _EditorDocumentModel;

  factory EditorDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$EditorDocumentModelFromJson(json);

  factory EditorDocumentModel.fromEntity(EditorDocument document) =>
      EditorDocumentModel(
        name: document.name,
        root: WidgetNodeModel.fromEntity(document.root),
        schemaVersion: document.schemaVersion,
      );

  // Freezed needs this private constructor to allow members like toEntity().
  const EditorDocumentModel._();

  EditorDocument toEntity() => EditorDocument(
    name: name,
    root: root.toEntity(),
    schemaVersion: schemaVersion,
  );
}
