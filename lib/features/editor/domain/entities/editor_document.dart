import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_document.freezed.dart';

/// Version written to saved documents, used to migrate older files.
const int currentSchemaVersion = 1;

/// A project: a named widget tree plus a schema version for migrations.
@freezed
abstract class EditorDocument with _$EditorDocument {
  const factory EditorDocument({
    required String name,
    required WidgetNode root,
    @Default(currentSchemaVersion) int schemaVersion,
  }) = _EditorDocument;
}
