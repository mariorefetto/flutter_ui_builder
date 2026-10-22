import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/drop_plan.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/drag_session_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/drag_payload.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_dimensions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/canvas_context_menu.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/drag/dashed_outline.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/drag/drop_label.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/drag_feedback.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/editor_shortcuts.dart';

/// Bars that sit at the top of the screen, below the status bar.
const Set<String> _topBars = {'AppBar', 'CupertinoNavigationBar'};

/// Wraps the preview of one node so it can be selected, dragged to a new
/// place and used as a drop target.
class CanvasNode extends StatefulWidget {
  const CanvasNode({
    required this.node,
    required this.isRoot,
    required this.isEmptyContainer,
    required this.child,
    super.key,
  });

  final WidgetNode node;
  final bool isRoot;

  /// True when the node can hold children but has none, so it needs a minimum
  /// size to remain a visible drop target.
  final bool isEmptyContainer;
  final Widget child;

  @override
  State<CanvasNode> createState() => _CanvasNodeState();
}

class _CanvasNodeState extends State<CanvasNode> {
  DropSide _side = DropSide.after;
  Axis _axis = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditorCubit>();
    if (context.select((WorkspaceCubit c) => c.state.prototype)) {
      return _prototype(context, cubit);
    }
    final selected = context.select(
      (EditorCubit c) => c.state.selectedId == widget.node.id,
    );
    return DragTarget<DragPayload>(
      onWillAcceptWithDetails: (details) {
        final accepts = _planFor(cubit, details.data, details.offset) != null;
        if (accepts) context.read<DragSessionCubit>().hover(widget.node.id);
        return accepts;
      },
      onLeave: (_) => context.read<DragSessionCubit>().leave(widget.node.id),
      onMove: (details) => setState(() => _locate(details.offset)),
      onAcceptWithDetails: (details) {
        _locate(details.offset);
        cubit.drop(details.data, widget.node.id, _side);
      },
      builder: (context, candidates, rejected) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          cubit.select(widget.node.id);
          EditorShortcuts.reclaimFocus(context);
        },
        onSecondaryTapDown: (details) =>
            _openMenu(cubit, details.globalPosition),
        child: _hovered(
          context,
          cubit,
          hovered: candidates.isNotEmpty ? candidates.first : null,
          child: _outlined(
            context,
            _decoration(
              context,
              cubit,
              selected: selected,
              hovered: candidates.isNotEmpty ? candidates.first : null,
            ),
            _draggable(_sized(widget.child)),
          ),
        ),
      ),
    );
  }

  // The outline is drawn over the node. A bar at the top of the screen is
  // outlined below the status bar, which is not part of it, and the screen's
  // own widget follows the rounded corners of the device.
  Widget _outlined(
    BuildContext context,
    BoxDecoration decoration,
    Widget child,
  ) {
    final topInset = _topBars.contains(widget.node.type)
        ? PreviewScreenScope.insetsOf(context).top
        : 0.0;
    final radius = widget.isRoot
        ? PreviewScreenScope.cornerRadiusOf(context)
        : 0.0;
    final border = decoration.border;
    final rounded = radius > 0 && (border == null || border.isUniform);
    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        Positioned.fill(
          top: topInset,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: rounded
                  ? decoration.copyWith(
                      borderRadius: BorderRadius.circular(radius),
                    )
                  : decoration,
            ),
          ),
        ),
      ],
    );
  }

  // In prototype mode only the widgets that open a screen react.
  Widget _prototype(BuildContext context, EditorCubit cubit) {
    final target = widget.node.props[navigateToProp];
    if (target is! String || target.isEmpty) return widget.child;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _follow(context, cubit, target),
        child: widget.child,
      ),
    );
  }

  void _follow(BuildContext context, EditorCubit cubit, String target) {
    final workspace = context.read<WorkspaceCubit>();
    if (target == navigateBack) {
      final previous = workspace.trailPop();
      if (previous != null) cubit.openScreen(previous);
      return;
    }
    workspace.trailPush(cubit.state.document.name);
    cubit.openScreen(target);
  }

  // While a drop is over the node, a tag says where it would land and, for a
  // drop inside, the node is tinted.
  Widget _hovered(
    BuildContext context,
    EditorCubit cubit, {
    required DragPayload? hovered,
    required Widget child,
  }) {
    final plan = hovered == null
        ? null
        : cubit.planDrop(hovered, widget.node.id, _side);
    if (plan == null) return child;
    final colors = context.colorScheme;
    final l10n = context.l10n;
    final inside = plan.parentId == widget.node.id;
    final text = inside
        ? l10n.dropInside(widget.node.type)
        : _side == DropSide.before
        ? l10n.dropBefore(widget.node.type)
        : l10n.dropAfter(widget.node.type);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (inside)
          Positioned.fill(
            child: ColoredBox(
              color: colors.primary.withValues(alpha: dropTintOpacity),
            ),
          ),
        child,
        Positioned(
          top: 0,
          left: 0,
          child: IgnorePointer(
            child: DropLabel(
              text: text,
              color: inside ? colors.primary : colors.tertiary,
            ),
          ),
        ),
      ],
    );
  }

  // Selects the node, then opens the context menu on it.
  void _openMenu(EditorCubit cubit, Offset position) {
    cubit.select(widget.node.id);
    CanvasMenuScope.maybeOf(context)?.open(position);
  }

  Widget _sized(Widget child) => widget.isEmptyContainer
      ? ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: AppConstants.spacingXXL,
            minHeight: AppConstants.spacingXXL,
          ),
          child: child,
        )
      : child;

  Widget _draggable(Widget child) {
    if (widget.isRoot) return child;
    final session = context.read<DragSessionCubit>();
    return Draggable<DragPayload>(
      data: MoveNodePayload(widget.node.id),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DragFeedback(label: widget.node.type),
      onDragStarted: () => session.start(nodeId: widget.node.id),
      onDragEnd: (_) => session.end(),
      // The place the node leaves stays visible, faded and outlined.
      childWhenDragging: DashedOutline(
        color: context.colorScheme.primary,
        child: Opacity(opacity: draggedOpacity, child: child),
      ),
      child: child,
    );
  }

  DropPlan? _planFor(EditorCubit cubit, DragPayload payload, Offset global) {
    _locate(global);
    return cubit.planDrop(payload, widget.node.id, _side);
  }

  // Works out the nearest edge of this node to the pointer.
  void _locate(Offset global) {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize || box.size.isEmpty) return;
    final local = box.globalToLocal(global);
    final dx = local.dx / box.size.width - halfExtent;
    final dy = local.dy / box.size.height - halfExtent;
    _axis = dx.abs() > dy.abs() ? Axis.horizontal : Axis.vertical;
    final offset = _axis == Axis.horizontal ? dx : dy;
    _side = offset < 0 ? DropSide.before : DropSide.after;
  }

  BoxDecoration _decoration(
    BuildContext context,
    EditorCubit cubit, {
    required bool selected,
    required DragPayload? hovered,
  }) {
    final colors = context.colorScheme;
    final plan = hovered == null
        ? null
        : cubit.planDrop(hovered, widget.node.id, _side);
    if (plan != null && plan.parentId != widget.node.id) {
      return BoxDecoration(border: _edge(colors.tertiary));
    }
    if (plan != null || selected) {
      return BoxDecoration(
        border: Border.all(
          color: colors.primary,
          width: AppConstants.borderWidthMedium,
        ),
      );
    }
    return const BoxDecoration();
  }

  // A line on the edge next to which the dragged node will be inserted.
  Border _edge(Color color) {
    final line = BorderSide(
      color: color,
      width: AppConstants.borderWidthMedium,
    );
    final before = _side == DropSide.before;
    return _axis == Axis.vertical
        ? Border(
            top: before ? line : BorderSide.none,
            bottom: before ? BorderSide.none : line,
          )
        : Border(
            left: before ? line : BorderSide.none,
            right: before ? BorderSide.none : line,
          );
  }
}
