import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/object_selector.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/prop_description.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/prop_row.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/widget_about.dart';

/// The properties of the selected node, in the style of an IDE properties
/// window: an object selector, a search field, categorized or alphabetical
/// rows with the name beside the editor, and a description of the property
/// last clicked. Every edit goes through the cubit, so it is undoable.
class PropertiesPanel extends StatefulWidget {
  const PropertiesPanel({required this.registry, super.key});

  final WidgetRegistry registry;

  @override
  State<PropertiesPanel> createState() => _PropertiesPanelState();
}

class _PropertiesPanelState extends State<PropertiesPanel> {
  final TextEditingController _search = TextEditingController();
  final Set<String> _collapsed = {};
  bool _categorized = true;
  String? _focused;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorCubit, EditorState>(
      buildWhen: (previous, current) =>
          previous.document != current.document ||
          previous.selectedId != current.selectedId,
      builder: (context, state) {
        final selected = state.selectedId;
        final node = selected == null
            ? null
            : state.document.root.find(selected);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ObjectSelector(root: state.document.root, selectedId: selected),
            if (node != null)
              WidgetAbout(definition: widget.registry.definitionFor(node.type)),
            _toolbar(context),
            Expanded(
              child: node == null
                  ? Padding(
                      padding: const EdgeInsets.all(AppConstants.spacingSM),
                      child: Text(context.l10n.editorNoSelection),
                    )
                  : _rows(context, node),
            ),
            if (node != null) _description(node),
          ],
        );
      },
    );
  }

  Widget _toolbar(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingSM),
      child: Row(
        children: [
          IconButton(
            tooltip: l10n.propsCategorized,
            visualDensity: VisualDensity.compact,
            isSelected: _categorized,
            icon: const Icon(AppIcons.list),
            onPressed: () => setState(() => _categorized = true),
          ),
          IconButton(
            tooltip: l10n.propsAlphabetical,
            visualDensity: VisualDensity.compact,
            isSelected: !_categorized,
            icon: const Icon(AppIcons.sortAlpha),
            onPressed: () => setState(() => _categorized = false),
          ),
          Expanded(
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(AppIcons.search),
                hintText: l10n.propsSearch,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rows(BuildContext context, WidgetNode node) {
    final definition = widget.registry.definitionFor(node.type);
    final query = _search.text.trim().toLowerCase();
    final visible = definition.props
        .where((prop) => prop.name.toLowerCase().contains(query))
        .toList();
    return ListView(
      // A new node gets fresh field state instead of inheriting the old text.
      key: ValueKey(node.id),
      children: _categorized
          ? _grouped(context, node, definition, visible)
          : _flat(node, definition, visible),
    );
  }

  List<Widget> _flat(
    WidgetNode node,
    WidgetDefinition definition,
    List<PropSchema> props,
  ) {
    final sorted = [...props]..sort((a, b) => a.name.compareTo(b.name));
    return [for (final prop in sorted) _row(node, definition, prop)];
  }

  List<Widget> _grouped(
    BuildContext context,
    WidgetNode node,
    WidgetDefinition definition,
    List<PropSchema> props,
  ) {
    final byGroup = <String, List<PropSchema>>{};
    for (final prop in props) {
      byGroup.putIfAbsent(propCategoryOf(prop), () => []).add(prop);
    }
    return [
      for (final group in propGroups)
        if (byGroup[group] case final members?) ...[
          _GroupHeader(
            group: group,
            expanded: !_collapsed.contains(group),
            onTap: () => setState(
              () => _collapsed.contains(group)
                  ? _collapsed.remove(group)
                  : _collapsed.add(group),
            ),
          ),
          if (!_collapsed.contains(group))
            for (final prop in members) _row(node, definition, prop),
        ],
    ];
  }

  Widget _row(WidgetNode node, WidgetDefinition definition, PropSchema prop) {
    final cubit = context.read<EditorCubit>();
    return PropRow(
      key: ValueKey('prop-${prop.name}'),
      schema: prop,
      props: definition.resolve(node),
      modified: node.props.containsKey(prop.name),
      focused: _focused == prop.name,
      onFocus: () => setState(() => _focused = prop.name),
      onChanged: (value) => cubit.updateProp(node.id, prop.name, value),
    );
  }

  Widget _description(WidgetNode node) {
    final definition = widget.registry.definitionFor(node.type);
    final focused = definition.props
        .where((prop) => prop.name == _focused)
        .firstOrNull;
    return focused == null
        ? const SizedBox.shrink()
        : PropDescription(schema: focused);
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.group,
    required this.expanded,
    required this.onTap,
  });

  final String group;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ColoredBox(
        color: context.colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingXS,
            vertical: AppConstants.spacingXS,
          ),
          child: Row(
            children: [
              Icon(
                expanded ? AppIcons.expand : AppIcons.collapsed,
                size: AppConstants.spacingLG,
              ),
              Text(
                propGroupLabel(context.l10n, group),
                style: context.textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
