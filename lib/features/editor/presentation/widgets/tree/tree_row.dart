import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/drop_plan.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/drag_session_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/drag_session_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/drag_payload.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_dimensions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/drag/dashed_outline.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/drag_feedback.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/editor_shortcuts.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/rename_widget.dart';

/// Where on a row a drop is: the top and bottom quarters put the widget next
/// to the row's, the middle puts it inside when the widget takes children.
enum _Zone { before, inside, after }

const double _edgeZone = 0.25;

/// One row of the outline: it selects its widget, can be dragged to move it,
/// takes drops, and is renamed with a long press.
class TreeRow extends StatefulWidget {
  const TreeRow({
    required this.node,
    required this.depth,
    required this.isRoot,
    required this.selected,
    super.key,
  });

  final WidgetNode node;
  final int depth;
  final bool isRoot;
  final bool selected;

  @override
  State<TreeRow> createState() => _TreeRowState();
}

class _TreeRowState extends State<TreeRow> {
  _Zone _zone = _Zone.inside;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditorCubit>();
    final session = context.watch<DragSessionCubit>().state;
    return DragTarget<DragPayload>(
      onWillAcceptWithDetails: (details) =>
          _plan(cubit, details.data, details.offset) != null,
      onMove: (details) => setState(() => _locate(details.offset)),
      onAcceptWithDetails: (details) {
        _locate(details.offset);
        cubit.drop(
          details.data,
          widget.node.id,
          _zone == _Zone.before ? DropSide.before : DropSide.after,
          preferInside: _zone == _Zone.inside,
        );
      },
      builder: (context, candidates, rejected) => _draggable(
        context,
        _row(context, cubit, session, candidates.firstOrNull),
      ),
    );
  }

  Widget _draggable(BuildContext context, Widget row) {
    if (widget.isRoot) return row;
    final session = context.read<DragSessionCubit>();
    return Draggable<DragPayload>(
      data: MoveNodePayload(widget.node.id),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DragFeedback(label: widget.node.type),
      onDragStarted: () => session.start(nodeId: widget.node.id),
      onDragEnd: (_) => session.end(),
      childWhenDragging: Opacity(opacity: draggedOpacity, child: row),
      child: row,
    );
  }

  Widget _row(
    BuildContext context,
    EditorCubit cubit,
    DragSessionState session,
    DragPayload? hovered,
  ) {
    final colors = context.colorScheme;
    final plan = hovered == null ? null : _plan(cubit, hovered, null);
    final overCanvas = session.targetId == widget.node.id;
    final dragged = session.draggedId == widget.node.id;
    final tile = ListTile(
      dense: true,
      selected: widget.selected,
      tileColor: overCanvas
          ? colors.primary.withValues(alpha: dropTintOpacity)
          : null,
      contentPadding: EdgeInsetsDirectional.only(
        start: AppConstants.spacingSM + widget.depth * AppConstants.spacingMD,
        end: AppConstants.spacingSM,
      ),
      title: Text(_title()),
      onTap: () {
        cubit.select(widget.node.id);
        EditorShortcuts.reclaimFocus(context);
      },
      onLongPress: () {
        cubit.select(widget.node.id);
        renameSelectedWidget(context);
      },
    );
    final base = dragged
        ? DashedOutline(color: colors.primary, child: tile)
        : tile;
    if (plan == null) return base;
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: _dropMark(colors, inside: plan.parentId == widget.node.id),
      child: base,
    );
  }

  // The name the user gave the widget, then its type; with both, the type
  // follows in brackets.
  String _title() {
    final label = widget.node.label;
    return label == null ? widget.node.type : '$label  (${widget.node.type})';
  }

  // A tint for a drop inside, and a line above or below for a drop next to it.
  BoxDecoration _dropMark(ColorScheme colors, {required bool inside}) {
    if (inside) {
      return BoxDecoration(
        color: colors.primary.withValues(alpha: dropTintOpacity),
        border: Border.all(
          color: colors.primary,
          width: AppConstants.borderWidthMedium,
        ),
      );
    }
    final line = BorderSide(
      color: colors.tertiary,
      width: AppConstants.borderWidthMedium,
    );
    return BoxDecoration(
      border: _zone == _Zone.before ? Border(top: line) : Border(bottom: line),
    );
  }

  DropPlan? _plan(EditorCubit cubit, DragPayload payload, Offset? global) {
    if (global != null) _locate(global);
    return cubit.planDrop(
      payload,
      widget.node.id,
      _zone == _Zone.before ? DropSide.before : DropSide.after,
      preferInside: _zone == _Zone.inside,
    );
  }

  void _locate(Offset global) {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize || box.size.isEmpty) return;
    final fraction = box.globalToLocal(global).dy / box.size.height;
    _zone = fraction < _edgeZone
        ? _Zone.before
        : fraction > 1 - _edgeZone
        ? _Zone.after
        : _Zone.inside;
  }
}
