import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/category_labels.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/palette/palette_item.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/widget_icons.dart';

/// Lists the registered widgets by category, as the Flutter widget catalog
/// does, with a search field, the widgets added lately, and a filter down to
/// what can go where the selection is. Each entry can be dragged onto the
/// canvas or the outline, or clicked to add it to the selection.
class WidgetPalette extends StatefulWidget {
  const WidgetPalette({required this.registry, super.key});

  final WidgetRegistry registry;

  @override
  State<WidgetPalette> createState() => _WidgetPaletteState();
}

class _WidgetPaletteState extends State<WidgetPalette> {
  final TextEditingController _search = TextEditingController();
  // Screens and layout are what a design starts from; the rest open on demand.
  late final Set<String> _collapsed = {
    for (final definition in widget.registry.all)
      if (!_openAtStart.contains(definition.category)) definition.category,
  };
  bool _onlyFitting = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    // The fit of each widget depends on the selection and the document.
    return BlocBuilder<EditorCubit, EditorState>(
      builder: (context, _) {
        final cubit = context.read<EditorCubit>();
        final groups = _groupByCategory(query, cubit);
        final recents = query.isEmpty
            ? context
                  .select((WorkspaceCubit c) => c.state.recentWidgets)
                  .where(widget.registry.contains)
                  .map(widget.registry.definitionFor)
                  .where(
                    (d) => !_onlyFitting || cubit.canAddToSelection(d.type),
                  )
                  .toList()
            : <WidgetDefinition>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SearchBar(
              controller: _search,
              onlyFitting: _onlyFitting,
              onChanged: () => setState(() {}),
              onToggleFilter: () =>
                  setState(() => _onlyFitting = !_onlyFitting),
            ),
            Expanded(
              child: groups.isEmpty && recents.isEmpty
                  ? Center(child: Text(context.l10n.paletteNoMatches))
                  : ListView(
                      children: [
                        if (recents.isNotEmpty)
                          _Section(
                            title: context.l10n.paletteRecent,
                            icon: AppIcons.recent,
                            collapsed: _collapsed.contains(_recentKey),
                            count: recents.length,
                            onToggle: () => _toggle(_recentKey),
                            children: [
                              for (final d in recents)
                                PaletteItem(
                                  definition: d,
                                  query: query,
                                  keyPrefix: _recentKey,
                                ),
                            ],
                          ),
                        for (final MapEntry(:key, :value) in groups.entries)
                          _Section(
                            title: categoryLabel(context.l10n, key),
                            icon: iconForCategory(key),
                            color: colorForCategory(context.colorScheme, key),
                            // A search opens every group that has a match.
                            collapsed:
                                query.isEmpty && _collapsed.contains(key),
                            count: value.length,
                            onToggle: () => _toggle(key),
                            children: [
                              for (final d in value)
                                PaletteItem(definition: d, query: query),
                            ],
                          ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  static const Set<String> _openAtStart = {screenCategory, layoutCategory};

  static const String _recentKey = '__recent__';

  void _toggle(String key) => setState(() {
    if (!_collapsed.remove(key)) _collapsed.add(key);
  });

  Map<String, List<WidgetDefinition>> _groupByCategory(
    String query,
    EditorCubit cubit,
  ) {
    final groups = <String, List<WidgetDefinition>>{};
    for (final definition in widget.registry.all) {
      if (!_matches(definition, query)) continue;
      if (_onlyFitting && !cubit.canAddToSelection(definition.type)) continue;
      groups.putIfAbsent(definition.category, () => []).add(definition);
    }
    return groups;
  }

  // The name, or the type it is written as in code, or its category.
  bool _matches(WidgetDefinition definition, String query) =>
      definition.label.toLowerCase().contains(query) ||
      definition.type.toLowerCase().contains(query) ||
      definition.category.toLowerCase().contains(query);
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onlyFitting,
    required this.onChanged,
    required this.onToggleFilter,
  });

  final TextEditingController controller;
  final bool onlyFitting;
  final VoidCallback onChanged;
  final VoidCallback onToggleFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingSM),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                prefixIcon: const Icon(AppIcons.search),
                hintText: context.l10n.editorPaletteSearch,
              ),
            ),
          ),
          IconButton(
            tooltip: context.l10n.paletteOnlyFitting,
            isSelected: onlyFitting,
            icon: const Icon(AppIcons.filter),
            onPressed: onToggleFilter,
          ),
        ],
      ),
    );
  }
}

/// A category header that opens and closes its widgets.
class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.collapsed,
    required this.count,
    required this.onToggle,
    required this.children,
    this.color,
  });

  final String title;
  final IconData icon;
  final Color? color;
  final bool collapsed;
  final int count;
  final VoidCallback onToggle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingSM,
              vertical: AppConstants.spacingSM,
            ),
            child: Row(
              children: [
                Icon(
                  collapsed ? AppIcons.collapsed : AppIcons.expand,
                  size: AppConstants.spacingMD,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppConstants.spacingXS),
                Icon(
                  icon,
                  size: AppConstants.spacingMD,
                  color: color ?? colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppConstants.spacingSM),
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text('$count', style: context.textTheme.labelSmall),
              ],
            ),
          ),
        ),
        if (!collapsed) ...children,
      ],
    );
  }
}
