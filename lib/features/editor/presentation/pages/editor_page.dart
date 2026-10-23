import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/di/injection.dart';
import 'package:flutter_ui_builder/core/error/failure_messages.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/new_document.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_edit_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/drag_session_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/problems_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/project_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/project_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_dimensions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/designer_toolbar.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/editor_canvas.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/code/code_view.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/media/media_panel.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/palette/widget_palette.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/problems/problems_panel.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/properties_panel.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/activity_strip.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/center_tabs.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/dock_panel.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/document_tab.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/editor_menu_bar.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/editor_shortcuts.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/editor_toolbar.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/splitter.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/status_bar.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/tree/widget_tree_panel.dart';

/// The editor window, laid out like an IDE: menu bar and toolbar on top, a
/// toolbox or outline on the left, the designer and the code in the middle,
/// properties on the right and a status bar at the bottom.
class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final initialDocument = createEmptyDocument();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<EditorCubit>(param1: initialDocument)),
        BlocProvider(create: (_) => sl<ProjectCubit>(param1: initialDocument)),
        BlocProvider(create: (_) => sl<CodeCubit>(param1: initialDocument)),
        BlocProvider(create: (_) => sl<ProblemsCubit>(param1: initialDocument)),
        BlocProvider(
          create: (context) {
            // The code was generated before anything listened for it.
            final edit = sl<CodeEditCubit>();
            final code = context.read<CodeCubit>().state;
            if (code case CodeReady(:final files) when files.isNotEmpty) {
              edit.generatedChanged(files.first.content);
            }
            return edit;
          },
        ),
        BlocProvider(create: (_) => sl<WorkspaceCubit>()),
        BlocProvider(create: (_) => sl<DragSessionCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<EditorCubit, EditorState>(
            listenWhen: (previous, current) => current.failure != null,
            listener: _showFailure,
          ),
          BlocListener<EditorCubit, EditorState>(
            listenWhen: (previous, current) =>
                previous.document != current.document,
            listener: (context, state) {
              context.read<CodeCubit>().update(state.document);
              context.read<ProblemsCubit>().update(state.document);
            },
          ),
          BlocListener<ProjectCubit, ProjectState>(
            listenWhen: (previous, current) => current.event != null,
            listener: _onProjectEvent,
          ),
          BlocListener<CodeCubit, CodeState>(listener: _onCodeEvent),
        ],
        child: EditorShortcuts(
          child: Scaffold(
            body: Column(
              children: [
                EditorMenuBar(registry: sl<WidgetRegistry>()),
                const EditorToolbar(),
                const Expanded(child: _Workspace()),
                const _ProblemsDock(),
                const StatusBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFailure(BuildContext context, EditorState state) {
    final failure = state.failure;
    if (failure == null) return;
    _snack(context, messageFor(context.l10n, failure));
  }

  void _onProjectEvent(BuildContext context, ProjectState state) {
    switch (state.event) {
      case ProjectOpened(:final document):
        context.read<EditorCubit>().replaceDocument(document);
      case ProjectSaved():
        _snack(context, context.l10n.fileSaved);
      case ProjectFailed(:final failure):
        _snack(context, messageFor(context.l10n, failure));
      case null:
        break;
    }
  }

  void _onCodeEvent(BuildContext context, CodeState state) {
    // The editor shows the generated code of the (first) file.
    if (state case CodeReady(:final files) when files.isNotEmpty) {
      context.read<CodeEditCubit>().generatedChanged(files.first.content);
    }
    switch (state) {
      case CodeExported(:final count):
        _snack(context, context.l10n.codeExported(count));
      case CodeExportFailed(:final failure):
        _snack(context, messageFor(context.l10n, failure));
      case CodeReady() || CodeFailed() || CodeExporting():
        break;
    }
  }

  void _snack(BuildContext context, String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
}

class _Workspace extends StatelessWidget {
  const _Workspace();

  @override
  Widget build(BuildContext context) {
    final registry = sl<WidgetRegistry>();
    final workspace = context.read<WorkspaceCubit>();
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) => Row(
        children: [
          const ActivityStrip(),
          if (state.leftPanel case final panel?) ...[
            SizedBox(
              width: state.leftWidth,
              child: _leftDock(context, panel, registry),
            ),
            Splitter(onDrag: workspace.resizeLeft),
          ],
          Expanded(child: _Center(registry: registry)),
          if (state.propertiesVisible) ...[
            Splitter(onDrag: (delta) => workspace.resizeRight(-delta)),
            SizedBox(
              width: state.rightWidth,
              child: DockPanel(
                title: context.l10n.panelProperties,
                onClose: workspace.toggleProperties,
                child: PropertiesPanel(registry: registry),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _leftDock(
    BuildContext context,
    LeftPanel panel,
    WidgetRegistry registry,
  ) {
    final l10n = context.l10n;
    final close = context.read<WorkspaceCubit>().closeLeftPanel;
    return switch (panel) {
      LeftPanel.toolbox => DockPanel(
        title: l10n.panelToolbox,
        onClose: close,
        child: WidgetPalette(registry: registry),
      ),
      LeftPanel.outline => DockPanel(
        title: l10n.panelOutline,
        onClose: close,
        child: const WidgetTreePanel(),
      ),
      LeftPanel.media => DockPanel(
        title: l10n.panelMedia,
        onClose: close,
        child: const MediaPanel(),
      ),
    };
  }
}

class _Center extends StatelessWidget {
  const _Center({required this.registry});

  final WidgetRegistry registry;

  @override
  Widget build(BuildContext context) {
    final tab = context.select((WorkspaceCubit c) => c.state.centerTab);
    final placement = context.select(
      (WorkspaceCubit c) => c.state.codePlacement,
    );
    final workspace = context.read<WorkspaceCubit>();
    final designer = _Designer(registry: registry);
    final body = switch (placement) {
      // Both stay built so the designer keeps its scroll position.
      CodePlacement.tab => IndexedStack(
        index: tab.index,
        children: [designer, const CodeView()],
      ),
      CodePlacement.right => Row(
        children: [
          Expanded(child: designer),
          Splitter(onDrag: (delta) => workspace.resizeCodeWidth(-delta)),
          SizedBox(
            width: context.select((WorkspaceCubit c) => c.state.codeWidth),
            child: const CodeView(),
          ),
        ],
      ),
      CodePlacement.bottom => Column(
        children: [
          Expanded(child: designer),
          Splitter(
            axis: Axis.horizontal,
            onDrag: (delta) => workspace.resizeCodeHeight(-delta),
          ),
          SizedBox(
            height: context.select((WorkspaceCubit c) => c.state.codeHeight),
            child: const CodeView(),
          ),
        ],
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DocumentTab(),
        Expanded(child: body),
        const CenterTabs(),
      ],
    );
  }
}

class _Designer extends StatelessWidget {
  const _Designer({required this.registry});

  final WidgetRegistry registry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DesignerToolbar(),
        Expanded(
          child: ColoredBox(
            color: context.colorScheme.surfaceContainerHighest,
            child: EditorCanvas(
              previews: sl<PreviewRegistry>(),
              registry: registry,
            ),
          ),
        ),
      ],
    );
  }
}

/// The problems panel under the workspace, when it is shown.
class _ProblemsDock extends StatelessWidget {
  const _ProblemsDock();

  @override
  Widget build(BuildContext context) {
    final visible = context.select(
      (WorkspaceCubit c) => c.state.problemsVisible,
    );
    return visible
        ? const SizedBox(height: problemsPanelHeight, child: ProblemsPanel())
        : const SizedBox.shrink();
  }
}
