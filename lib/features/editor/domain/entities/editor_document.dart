import 'package:flutter_ui_builder/features/editor/domain/entities/component_param.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/media_asset.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_screen.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_theme.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_document.freezed.dart';

/// Version written to saved documents, used to migrate older files.
const int currentSchemaVersion = 2;

/// A project: its screens, one of them open for editing, plus a schema
/// version for migrations.
///
/// The open screen is [name] and [root], which is what every edit works on;
/// the others wait in [screens] in their order, with the open one belonging
/// at [activeIndex]. The first screen of the project is the one the app
/// starts on.
@freezed
abstract class EditorDocument with _$EditorDocument {
  const factory EditorDocument({
    required String name,
    required WidgetNode root,

    /// The screens that are not open, in project order.
    @Default(<ProjectScreen>[]) List<ProjectScreen> screens,

    /// Where the open screen sits among all of them.
    @Default(0) int activeIndex,

    /// Whether the open one is a component rather than a screen.
    @Default(false) bool component,

    /// The parameters of the open component.
    @Default(<ComponentParam>[]) List<ComponentParam> params,

    /// The pictures of the project, shared by all its screens.
    @Default(<MediaAsset>[]) List<MediaAsset> assets,

    /// The theme of the designed app, shared by all its screens.
    @Default(ProjectTheme()) ProjectTheme theme,

    /// Screens open each other by route name, with a file that lists the
    /// routes, rather than by pushing the class of the screen.
    @Default(false) bool namedRoutes,
    @Default(currentSchemaVersion) int schemaVersion,
  }) = _EditorDocument;
}
