import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/di/injection.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/tree/tree_row.dart';

/// Hierarchical view of the document. A row selects its widget, in sync with
/// the canvas, and rows can be dragged to reorder and nest widgets. The
/// search field narrows the list to the widgets that match and what leads to
/// them.
class WidgetTreePanel extends StatefulWidget {
  const WidgetTreePanel({super.key});

  @override
  State<WidgetTreePanel> createState() => _WidgetTreePanelState();
}

class _WidgetTreePanelState extends State<WidgetTreePanel> {
  final TextEditingController _search = TextEditingController();
  final WidgetRegistry _registry = sl<WidgetRegistry>();

  /// Widgets whose children are hidden.
  final Set<String> _collapsed = {};

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.spacingSM),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(AppIcons.search),
                    hintText: context.l10n.outlineSearch,
                  ),
                ),
              ),
              IconButton(
                tooltip: context.l10n.outlineCollapseAll,
                icon: const Icon(AppIcons.collapseAll),
                onPressed: _collapseAll,
              ),
              IconButton(
                tooltip: context.l10n.outlineExpandAll,
                icon: const Icon(AppIcons.expandAll),
                onPressed: () => setState(_collapsed.clear),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<EditorCubit, EditorState>(
            buildWhen: (previous, current) =>
                previous.document != current.document ||
                previous.selectedId != current.selectedId,
            builder: (context, state) {
              _reveal(state.document.root, state.selectedId);
              final rows = _visible(state.document.root);
              return ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, index) => TreeRow(
                  node: rows[index].node,
                  depth: rows[index].depth,
                  isRoot: rows[index].node.id == state.document.root.id,
                  selected: rows[index].node.id == state.selectedId,
                  category: _category(rows[index].node.type),
                  expanded: !_collapsed.contains(rows[index].node.id),
                  onToggle: () => _toggle(rows[index].node.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _category(String type) =>
      _registry.contains(type) ? _registry.definitionFor(type).category : '';

  void _toggle(String id) => setState(() {
    if (!_collapsed.remove(id)) _collapsed.add(id);
  });

  void _collapseAll() {
    final root = context.read<EditorCubit>().state.document.root;
    // The root stays open: collapsed, the outline would show one line.
    final parents = _flatten(root, 0)
        .where((e) => e.node.children.isNotEmpty && e.depth > 0)
        .map((e) => e.node.id);
    setState(() {
      _collapsed
        ..clear()
        ..addAll(parents);
    });
  }

  // A selected widget must be in view: the widgets above it open.
  void _reveal(WidgetNode root, String? selectedId) {
    if (selectedId == null) return;
    for (final ancestor in root.pathTo(selectedId)) {
      if (ancestor.id != selectedId) _collapsed.remove(ancestor.id);
    }
  }

  // What is listed: everything below an open widget, or while searching the
  // matches and the widgets leading to them.
  List<_Entry> _visible(WidgetNode root) {
    final query = _search.text.trim().toLowerCase();
    if (query.isEmpty) return _flatten(root, 0, honourCollapsed: true);
    final all = _flatten(root, 0);
    final shown = <String>{};
    for (final entry in all) {
      if (_matches(entry.node, query)) {
        shown.addAll(root.pathTo(entry.node.id).map((n) => n.id));
      }
    }
    return all.where((e) => shown.contains(e.node.id)).toList();
  }

  bool _matches(WidgetNode node, String query) =>
      node.type.toLowerCase().contains(query) ||
      (node.label ?? '').toLowerCase().contains(query);

  List<_Entry> _flatten(
    WidgetNode node,
    int depth, {
    bool honourCollapsed = false,
  }) => [
    _Entry(node, depth),
    if (!honourCollapsed || !_collapsed.contains(node.id))
      for (final child in node.children)
        ..._flatten(child, depth + 1, honourCollapsed: honourCollapsed),
  ];
}

class _Entry {
  const _Entry(this.node, this.depth);

  final WidgetNode node;
  final int depth;
}
