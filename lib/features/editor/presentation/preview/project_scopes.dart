import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/component_scope.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/media_scope.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_registry.dart';

/// Gives the previews below it what they need from the project: the
/// components they may show and the pictures they may draw. It sits above the
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
        child: Builder(builder: builder),
      ),
    );
  }
}
