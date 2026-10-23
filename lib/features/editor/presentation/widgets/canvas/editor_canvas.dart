import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/component_binding.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/project_scopes.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/prototype_scope.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/status_bar_appearance.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/canvas_context_menu.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/canvas_node.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/device_frame.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/scaled_box.dart';

/// The preview of the document with selection and drag and drop on top.
class EditorCanvas extends StatelessWidget {
  const EditorCanvas({
    required this.previews,
    required this.registry,
    super.key,
  });

  final PreviewRegistry previews;
  final WidgetRegistry registry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorCubit, EditorState>(
      buildWhen: (previous, current) => previous.document != current.document,
      builder: (context, state) {
        return CanvasContextMenu(
          registry: registry,
          child: LayoutBuilder(
            builder: (context, constraints) =>
                _scrollable(context, state, constraints.maxWidth),
          ),
        );
      },
    );
  }

  // The previewed screen keeps its width when the window is narrower, and the
  // area scrolls sideways instead, so the layout always has a bounded width.
  Widget _scrollable(BuildContext context, EditorState state, double width) {
    final workspace = context.watch<WorkspaceCubit>().state;
    final device = workspace.device;
    final screen = device.size(landscape: workspace.landscape);
    final appearance = statusBarAppearance(
      state.document,
      workspace.statusBar,
      themeIsDark: workspace.darkTheme,
    );
    final insets = device.insets(
      landscape: workspace.landscape,
      statusBar: appearance.visible,
    );
    final bezel = workspace.showFrame ? device.bezel : 0.0;
    const padding = AppConstants.spacingMD;
    final contentWidth = screen.width + 2 * bezel;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: math.max(width, contentWidth * workspace.zoom + 2 * padding),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(padding),
          child: Align(
            alignment: Alignment.topLeft,
            child: ScaledBox(
              scale: workspace.zoom,
              child: PreviewScreenScope(
                size: screen,
                insets: insets,
                cornerRadius: workspace.showFrame ? device.cornerRadius : 0,
                child: _framed(
                  workspace,
                  appearance,
                  insets,
                  // Built below the scope, so the screen reads its size and
                  // the margins the system keeps.
                  Builder(
                    builder: (context) => _screen(context, state, screen),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _framed(
    WorkspaceState workspace,
    StatusBarAppearance appearance,
    EdgeInsets insets,
    Widget screen,
  ) => workspace.showFrame
      ? DeviceFrame(
          device: workspace.device,
          landscape: workspace.landscape,
          insets: insets,
          appearance: appearance,
          showSafeArea: workspace.showSafeArea,
          child: screen,
        )
      : screen;

  // Every root is as wide as the screen, as it is on a device.
  Widget _screen(BuildContext context, EditorState state, Size screen) {
    final rootId = state.document.root.id;
    return SizedBox(
      width: screen.width,
      child: PrototypeScope(
        prototype: context.select((WorkspaceCubit c) => c.state.prototype),
        child: ProjectScopes(
          darkTheme: context.select((WorkspaceCubit c) => c.state.darkTheme),
          document: state.document,
          previews: previews,
          builder: (context) => previews.build(
            context,
            // A component being edited is drawn with its parameters at their
            // defaults, so a bound property still shows a value.
            state.document.component
                ? bindArguments(state.document.root, state.document.params, {})
                : state.document.root,
            wrapper: (context, node, built) => CanvasNode(
              node: node,
              isRoot: node.id == rootId,
              isEmptyContainer: _isEmptyContainer(node),
              child: built,
            ),
          ),
        ),
      ),
    );
  }

  bool _isEmptyContainer(WidgetNode node) =>
      node.children.isEmpty &&
      registry.definitionFor(node.type).childPolicy != ChildPolicy.none;
}
