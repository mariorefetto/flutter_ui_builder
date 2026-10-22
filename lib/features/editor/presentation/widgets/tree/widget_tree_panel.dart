import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
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
          child: TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixIcon: const Icon(AppIcons.search),
              hintText: context.l10n.outlineSearch,
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<EditorCubit, EditorState>(
            buildWhen: (previous, current) =>
                previous.document != current.document ||
                previous.selectedId != current.selectedId,
            builder: (context, state) {
              final rows = _visible(state.document.root);
              return ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, index) => TreeRow(
                  node: rows[index].node,
                  depth: rows[index].depth,
                  isRoot: rows[index].node.id == state.document.root.id,
                  selected: rows[index].node.id == state.selectedId,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<_Entry> _visible(WidgetNode root) {
    final all = _flatten(root, 0);
    final query = _search.text.trim().toLowerCase();
    if (query.isEmpty) return all;
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

  List<_Entry> _flatten(WidgetNode node, int depth) => [
    _Entry(node, depth),
    for (final child in node.children) ..._flatten(child, depth + 1),
  ];
}

class _Entry {
  const _Entry(this.node, this.depth);

  final WidgetNode node;
  final int depth;
}
