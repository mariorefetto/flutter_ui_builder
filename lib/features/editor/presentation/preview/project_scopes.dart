import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/component_scope.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/media_scope.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/project_theme_data.dart';

/// Gives the previews below it what they need from the project: the
/// components they may show, the pictures they may draw and its theme. It sits above the
/// context the previews are built with, which is why [builder] gets a new one.
class ProjectScopes extends StatelessWidget {
  const ProjectScopes({
    required this.document,
    required this.previews,
    required this.builder,
    super.key,
  });

  final EditorDocument document;
  final PreviewRegistry previews;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MediaScope(
      files: {
        for (final asset in document.assets)
          if (asset.sourcePath != null) asset.name: asset.sourcePath!,
      },
      child: ComponentScope(
        roots: {
          for (final entry in const ScreenEditor().entriesOf(document))
            if (entry.component) entry.name: entry.root,
        },
        build: previews.build,
        // The project's own theme, not the editor's: the screens are drawn as
        // the app will be.
        child: Theme(
          data: cachedThemeDataOf(document.theme),
          child: Builder(builder: builder),
        ),
      ),
    );
  }
}
