import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/drag_session_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/drag_payload.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_dimensions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/drag_feedback.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/widget_icons.dart';

const double _paletteIconBox = 24;
const double _tintOpacity = 0.12;

/// One widget of the palette: its icon in the colour of its category, its name
/// with the part that matches a search in bold, and a plus that appears under
/// the pointer. Dragging it onto the screen or the outline adds it where it is
/// dropped; clicking adds it to the selection.
class PaletteItem extends StatefulWidget {
  const PaletteItem({
    required this.definition,
    required this.query,
    this.keyPrefix = '',
    super.key,
  });

  final WidgetDefinition definition;

  /// What the palette is searched for, in lower case; empty for nothing.
  final String query;

  /// Tells the entry in the recent list from the same widget in its category.
  final String keyPrefix;

  @override
  State<PaletteItem> createState() => _PaletteItemState();
}

class _PaletteItemState extends State<PaletteItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final definition = widget.definition;
    final canAdd = context.select(
      (EditorCubit c) => c.canAddToSelection(definition.type),
    );
    final colors = context.colorScheme;
    final tint = colorForCategory(colors, definition.category);
    final session = context.read<DragSessionCubit>();
    final workspace = context.read<WorkspaceCubit>();
    final row = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: () {
          context.read<EditorCubit>().addToSelection(definition.type);
          workspace.noteAdded(definition.type);
        },
        child: Container(
          height: treeRowHeight,
          color: _hovered
              ? colors.onSurface.withValues(alpha: hoverTintOpacity)
              : null,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingSM,
          ),
          child: Opacity(
            opacity: canAdd ? 1 : disabledOpacity,
            child: Row(
              children: [
                const SizedBox(width: AppConstants.spacingMD),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: tint.withValues(alpha: _tintOpacity),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                  ),
                  child: SizedBox.square(
                    dimension: _paletteIconBox,
                    child: Icon(
                      iconForWidget(definition.type, definition.category),
                      size: treeIconSize,
                      color: tint,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSM),
                Expanded(child: _name(context)),
                if (_hovered && canAdd)
                  Icon(
                    AppIcons.add,
                    size: treeIconSize,
                    color: colors.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    return Draggable<DragPayload>(
      data: NewWidgetPayload(definition.type),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DragFeedback(label: definition.label),
      onDragStarted: session.start,
      onDragEnd: (_) => session.end(),
      onDragCompleted: () => workspace.noteAdded(definition.type),
      // The entry can still be dragged to a place where it fits.
      child: Tooltip(
        richMessage: TextSpan(text: _tooltip(context, canAdd)),
        waitDuration: const Duration(milliseconds: 500),
        child: row,
      ),
    );
  }

  // The name with the matched part in bold, and the type when it differs.
  Widget _name(BuildContext context) {
    final style = context.textTheme.bodyMedium;
    final label = widget.definition.label;
    final at = widget.query.isEmpty
        ? -1
        : label.toLowerCase().indexOf(widget.query);
    if (at < 0) {
      return Text(label, style: style, overflow: TextOverflow.ellipsis);
    }
    final end = at + widget.query.length;
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: label.substring(0, at)),
          TextSpan(
            text: label.substring(at, end),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: label.substring(end)),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  String _tooltip(BuildContext context, bool canAdd) {
    final l10n = context.l10n;
    final policy = switch (widget.definition.childPolicy) {
      ChildPolicy.none => l10n.paletteTakesNoChild,
      ChildPolicy.single => l10n.paletteTakesOneChild,
      ChildPolicy.multiple => l10n.paletteTakesChildren,
    };
    return [
      widget.definition.type,
      policy,
      if (!canAdd) l10n.editorPaletteCannotAdd else l10n.paletteClickToAdd,
    ].join('\n');
  }
}
