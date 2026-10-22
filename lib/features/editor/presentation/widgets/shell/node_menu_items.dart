import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/shortcuts.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/category_labels.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/rename_widget.dart';

/// The widgets "Wrap with" offers: the containers people reach for most.
const List<String> wrapChoices = [
  'Padding',
  'Center',
  'Align',
  'SizedBox',
  'Container',
  'Expanded',
  'Flexible',
  'Column',
  'Row',
  'Stack',
  'Card',
  'SafeArea',
  'Opacity',
  'ClipRRect',
  'GestureDetector',
  'InkWell',
  'Visibility',
  'SingleChildScrollView',
  'Wrap',
];

/// Cut, copy, paste and duplicate. The shortcuts are registered only where
/// [withShortcuts] is set, because two menus may not claim the same keys.
class ClipboardMenuItems extends StatelessWidget {
  const ClipboardMenuItems({required this.withShortcuts, super.key});

  final bool withShortcuts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<EditorCubit>();
    SingleActivator? key(LogicalKeyboardKey k) =>
        withShortcuts ? commandKey(k) : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MenuItemButton(
          shortcut: key(LogicalKeyboardKey.keyX),
          onPressed: cubit.canCut ? cubit.cut : null,
          child: Text(l10n.menuCut),
        ),
        MenuItemButton(
          shortcut: key(LogicalKeyboardKey.keyC),
          onPressed: cubit.hasSelection ? cubit.copy : null,
          child: Text(l10n.menuCopy),
        ),
        MenuItemButton(
          shortcut: key(LogicalKeyboardKey.keyV),
          onPressed: cubit.canPaste ? cubit.paste : null,
          child: Text(l10n.menuPaste),
        ),
        MenuItemButton(
          shortcut: key(LogicalKeyboardKey.keyD),
          onPressed: cubit.canDuplicate ? cubit.duplicateSelected : null,
          child: Text(l10n.menuDuplicate),
        ),
      ],
    );
  }
}

/// Where a new widget goes in relation to the selection.
enum AddPlacement { inside, beside }

/// A submenu listing, by category, only the widgets that can be added to the
/// selection at [placement]: inside it, or next to it. The list is worked out
/// when the menu opens. With nothing to offer, the entry is disabled.
class AddWidgetMenu extends StatelessWidget {
  const AddWidgetMenu({
    required this.registry,
    required this.placement,
    super.key,
  });

  final WidgetRegistry registry;
  final AddPlacement placement;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<EditorCubit>();
    final inside = placement == AddPlacement.inside;
    final label = inside ? l10n.menuAddInside : l10n.menuAddBeside;
    final fits = inside ? cubit.canAddInside : cubit.canAddBeside;
    final add = inside ? cubit.addInsideSelection : cubit.addBesideSelection;
    final byCategory = <String, List<WidgetDefinition>>{};
    for (final definition in registry.all) {
      if (fits(definition.type)) {
        byCategory.putIfAbsent(definition.category, () => []).add(definition);
      }
    }
    if (byCategory.isEmpty) return MenuItemButton(child: Text(label));
    return SubmenuButton(
      menuChildren: [
        for (final MapEntry(:key, :value) in byCategory.entries)
          SubmenuButton(
            menuChildren: [
              for (final definition in value)
                MenuItemButton(
                  onPressed: () => add(definition.type),
                  child: Text(definition.label),
                ),
            ],
            child: Text(categoryLabel(l10n, key)),
          ),
      ],
      child: Text(label),
    );
  }
}

/// The first entry of the context menu: which widget it is about.
class SelectedWidgetHeader extends StatelessWidget {
  const SelectedWidgetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<EditorCubit>().state;
    final id = state.selectedId;
    final node = id == null ? null : state.document.root.find(id);
    return MenuItemButton(
      child: Text(
        node == null ? '' : '${node.type}  (${node.id})',
        style: context.textTheme.labelLarge,
      ),
    );
  }
}

/// "Wrap with" lists the containers that can go around the selection, and
/// "Remove wrapper" replaces the selection with what is inside it.
class RestructureMenuItems extends StatelessWidget {
  const RestructureMenuItems({required this.registry, super.key});

  final WidgetRegistry registry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<EditorCubit>();
    final wrappers = [
      for (final type in wrapChoices)
        if (registry.contains(type) && cubit.canWrapSelection(type)) type,
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SubmenuButton(
          menuChildren: [
            for (final type in wrappers)
              MenuItemButton(
                onPressed: () => cubit.wrapSelected(type),
                child: Text(registry.definitionFor(type).label),
              ),
          ],
          child: Text(l10n.menuWrapWith),
        ),
        MenuItemButton(
          onPressed: cubit.canUnwrap ? cubit.unwrapSelected : null,
          child: Text(l10n.menuUnwrap),
        ),
      ],
    );
  }
}

/// The entry that names the selected widget in the outline.
class RenameWidgetMenuItem extends StatelessWidget {
  const RenameWidgetMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      shortcut: const SingleActivator(LogicalKeyboardKey.f2),
      onPressed: context.read<EditorCubit>().hasSelection
          ? () => renameSelectedWidget(context)
          : null,
      child: Text(context.l10n.menuRenameWidget),
    );
  }
}
