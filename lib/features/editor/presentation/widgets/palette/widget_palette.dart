import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/drag_session_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/drag_payload.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/category_labels.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/drag_feedback.dart';

/// Lists the registered widgets by category, with a search field. Each entry
/// can be dragged onto the canvas or tapped to add it to the selection.
class WidgetPalette extends StatefulWidget {
  const WidgetPalette({required this.registry, super.key});

  final WidgetRegistry registry;

  @override
  State<WidgetPalette> createState() => _WidgetPaletteState();
}

class _WidgetPaletteState extends State<WidgetPalette> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final groups = _groupByCategory(query);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.spacingSM),
          child: TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixIcon: const Icon(AppIcons.search),
              hintText: context.l10n.editorPaletteSearch,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              for (final MapEntry(:key, :value) in groups.entries)
                ExpansionTile(
                  // A new key re-applies initiallyExpanded when searching.
                  key: ValueKey('$key-${query.isEmpty}'),
                  initiallyExpanded: query.isNotEmpty,
                  title: Text(categoryLabel(context.l10n, key)),
                  children: [
                    for (final definition in value)
                      _PaletteItem(definition: definition),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, List<WidgetDefinition>> _groupByCategory(String query) {
    final groups = <String, List<WidgetDefinition>>{};
    for (final definition in widget.registry.all) {
      if (!definition.label.toLowerCase().contains(query)) continue;
      groups.putIfAbsent(definition.category, () => []).add(definition);
    }
    return groups;
  }
}

class _PaletteItem extends StatelessWidget {
  const _PaletteItem({required this.definition});

  final WidgetDefinition definition;

  @override
  Widget build(BuildContext context) {
    final canAdd = context.select(
      (EditorCubit c) => c.canAddToSelection(definition.type),
    );
    final tile = ListTile(
      dense: true,
      enabled: canAdd,
      leading: const Icon(AppIcons.drag),
      title: Text(definition.label),
      onTap: () => context.read<EditorCubit>().addToSelection(definition.type),
    );
    return Draggable<DragPayload>(
      data: NewWidgetPayload(definition.type),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DragFeedback(label: definition.label),
      onDragStarted: context.read<DragSessionCubit>().start,
      onDragEnd: (_) => context.read<DragSessionCubit>().end(),
      // The entry can still be dragged to a place where it fits.
      child: canAdd
          ? tile
          : Tooltip(message: context.l10n.editorPaletteCannotAdd, child: tile),
    );
  }
}
