import 'package:flutter_ui_builder/features/editor/data/models/media_asset_model.dart';
import 'package:flutter_ui_builder/features/editor/data/models/project_screen_model.dart';
import 'package:flutter_ui_builder/features/editor/data/models/widget_node_model.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_document_model.freezed.dart';
part 'editor_document_model.g.dart';

/// JSON representation of an EditorDocument, the format saved to disk. A file
/// written before projects had several screens has none of the screen fields
/// and reads as a project of one screen.
@freezed
abstract class EditorDocumentModel with _$EditorDocumentModel {
  @JsonSerializable(explicitToJson: true, checked: true)
  const factory EditorDocumentModel({
    required String name,
    required WidgetNodeModel root,
    @Default(<ProjectScreenModel>[]) List<ProjectScreenModel> screens,
    @Default(0) int activeIndex,
    @Default(false) bool component,
    @Default(<MediaAssetModel>[]) List<MediaAssetModel> assets,
    @Default(<String, dynamic>{}) Map<String, dynamic> theme,
    @Default(currentSchemaVersion) int schemaVersion,
  }) = _EditorDocumentModel;

  factory EditorDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$EditorDocumentModelFromJson(json);

  factory EditorDocumentModel.fromEntity(EditorDocument document) =>
      EditorDocumentModel(
        name: document.name,
        root: WidgetNodeModel.fromEntity(document.root),
        screens: document.screens.map(ProjectScreenModel.fromEntity).toList(),
        activeIndex: document.activeIndex,
        component: document.component,
        assets: document.assets.map(MediaAssetModel.fromEntity).toList(),
        theme: {
          for (final entry in document.theme.parts.entries)
            if (entry.value.isNotEmpty) entry.key: entry.value,
        },
        schemaVersion: document.schemaVersion,
      );

  // Freezed needs this private constructor to allow members like toEntity().
  const EditorDocumentModel._();

  EditorDocument toEntity() => EditorDocument(
    name: name,
    root: root.toEntity(),
    screens: screens.map((s) => s.toEntity()).toList(),
    activeIndex: activeIndex.clamp(0, screens.length),
    component: component,
    assets: assets.map((a) => a.toEntity()).toList(),
    theme: ProjectTheme(parts: _themeParts(theme)),
    schemaVersion: schemaVersion,
  );
}

// The theme as saved: a map of parts, each a map of values. Anything of
// another shape is dropped rather than failing the whole file.
Map<String, Map<String, Object?>> _themeParts(Map<String, dynamic> saved) => {
  for (final entry in saved.entries)
    if (entry.value case final Map<String, dynamic> values)
      entry.key: {...values},
};
