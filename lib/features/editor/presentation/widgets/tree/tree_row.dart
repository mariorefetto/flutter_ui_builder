import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
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
import 'package:flutter_ui_builder/features/editor/presentation/widgets/widget_icons.dart';

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
    required this.category,
    required this.expanded,
    required this.onToggle,
    super.key,
  });

  final WidgetNode node;
  final int depth;
  final bool isRoot;
  final bool selected;

  /// The category of the widget's type, which picks its icon and colour.
  final String category;

  /// Whether the children are shown; meaningless for a widget without any.
  final bool expanded;
  final VoidCallback onToggle;

  @override
  State<TreeRow> createState() => _TreeRowState();
}

class _TreeRowState extends State<TreeRow> {
  _Zone _zone = _Zone.inside;
  bool _hovered = false;

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
    final tile = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: () {
          cubit.select(widget.node.id);
          EditorShortcuts.reclaimFocus(context);
        },
        onLongPress: () {
          cubit.select(widget.node.id);
          renameSelectedWidget(context);
        },
        child: Container(
          height: treeRowHeight,
          color: _background(colors, overCanvas),
          padding: const EdgeInsets.only(right: AppConstants.spacingSM),
          child: Row(
            children: [
              _Guides(depth: widget.depth, color: colors.outlineVariant),
              _Chevron(
                visible: widget.node.children.isNotEmpty,
                expanded: widget.expanded,
                onTap: widget.onToggle,
              ),
              Icon(
                iconForWidget(widget.node.type, widget.category),
                size: treeIconSize,
                color: colorForCategory(colors, widget.category),
              ),
              const SizedBox(width: AppConstants.spacingSM),
              Flexible(child: _title(context)),
              if (widget.node.children.isNotEmpty && !widget.expanded)
                _CountBadge(count: widget.node.children.length),
              if (_hovered || widget.selected) ...[
                const Spacer(),
                if (!widget.isRoot) ..._actions(context, cubit),
              ],
            ],
          ),
        ),
      ),
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

  // The name the user gave the widget, or its type, then in a lighter tone
  // what it shows (a Text's words, an Icon's name) or, for a named widget, its
  // type.
  Widget _title(BuildContext context) {
    final label = widget.node.label;
    final detail = label == null ? _summary(widget.node) : widget.node.type;
    final style = context.textTheme.bodyMedium;
    return Text.rich(
      TextSpan(
        text: label ?? widget.node.type,
        style: widget.selected
            ? style?.copyWith(fontWeight: FontWeight.w600)
            : style,
        children: [
          if (detail != null)
            TextSpan(
              text: '  $detail',
              style: style?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Color? _background(ColorScheme colors, bool overCanvas) {
    if (overCanvas) return colors.primary.withValues(alpha: dropTintOpacity);
    if (widget.selected) return colors.primaryContainer;
    if (_hovered) return colors.onSurface.withValues(alpha: hoverTintOpacity);
    return null;
  }

  List<Widget> _actions(BuildContext context, EditorCubit cubit) {
    final l10n = context.l10n;
    return [
      _RowAction(
        tooltip: l10n.menuDuplicate,
        icon: AppIcons.duplicate,
        onTap: () {
          cubit
            ..select(widget.node.id)
            ..duplicateSelected();
        },
      ),
      _RowAction(
        tooltip: l10n.editorDelete,
        icon: AppIcons.delete,
        onTap: () => cubit.removeNode(widget.node.id),
      ),
    ];
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

/// Properties that say most about a widget, in the order they are tried.
const List<String> _summaryProps = [
  'text',
  'title',
  'label',
  'labelText',
  'message',
  'url',
  'icon',
  'value',
  'placeholder',
];

String? _summary(WidgetNode node) {
  for (final name in _summaryProps) {
    final value = node.props[name];
    if (value is String && value.isNotEmpty) return value;
  }
  return null;
}

/// One thin vertical line per level of depth, as in the VS Code explorer, so
/// the nesting can be followed down a long column of rows.
class _Guides extends StatelessWidget {
  const _Guides({required this.depth, required this.color});

  final int depth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: AppConstants.spacingXS),
        for (var level = 0; level < depth; level++)
          SizedBox(
            width: treeIndent,
            height: treeRowHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: AppConstants.borderWidthThin,
                height: treeRowHeight,
                child: ColoredBox(color: color),
              ),
            ),
          ),
      ],
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron({
    required this.visible,
    required this.expanded,
    required this.onTap,
  });

  final bool visible;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: treeIndent,
      child: visible
          ? InkResponse(
              onTap: onTap,
              radius: treeIndent / 2,
              child: Icon(
                expanded ? AppIcons.expand : AppIcons.collapsed,
                size: treeIconSize,
                color: context.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
    );
  }
}

/// How many widgets a collapsed row hides.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: AppConstants.spacingSM),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingSM,
          ),
          child: Text('$count', style: context.textTheme.labelSmall),
        ),
      ),
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      iconSize: treeIconSize,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: treeRowHeight,
        height: treeRowHeight,
      ),
      icon: Icon(icon),
    );
  }
}
