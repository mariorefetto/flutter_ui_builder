import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/shortcuts.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/file/file_commands.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/file/rename_dialog.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/node_menu_items.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter_ui_builder/features/settings/presentation/widgets/open_settings.dart';

/// The File, Edit and View menus. The shortcuts shown next to the entries are
/// active for the whole window.
class EditorMenuBar extends StatelessWidget {
  const EditorMenuBar({required this.registry, super.key});

  final WidgetRegistry registry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<EditorCubit, EditorState>(
      buildWhen: (previous, current) =>
          previous.history.canUndo != current.history.canUndo ||
          previous.history.canRedo != current.history.canRedo ||
          previous.selectedId != current.selectedId ||
          previous.clipboard != current.clipboard,
      builder: (context, state) => MenuBar(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(
            context.colorScheme.surfaceContainerHighest,
          ),
          elevation: const WidgetStatePropertyAll(AppConstants.elevationLevel0),
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder()),
        ),
        children: [
          SubmenuButton(
            menuChildren: _fileItems(context),
            child: Text(l10n.menuFile),
          ),
          SubmenuButton(
            menuChildren: _editItems(context, state),
            child: Text(l10n.menuEdit),
          ),
          SubmenuButton(
            menuChildren: _viewItems(context),
            child: Text(l10n.menuView),
          ),
        ],
      ),
    );
  }

  List<Widget> _fileItems(BuildContext context) {
    final l10n = context.l10n;
    return [
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.keyN),
        onPressed: () => newProject(context),
        child: Text(l10n.fileNew),
      ),
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.keyO),
        onPressed: () => openProject(context),
        child: Text(l10n.fileOpen),
      ),
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.keyS),
        onPressed: () => saveProject(context),
        child: Text(l10n.fileSave),
      ),
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.keyS, shift: true),
        onPressed: () => saveProjectAs(context),
        child: Text(l10n.fileSaveAs),
      ),
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.keyI),
        onPressed: () => importCode(context),
        child: Text(l10n.menuImportCode),
      ),
      const Divider(),
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.keyE),
        onPressed: () => context.read<CodeCubit>().export(),
        child: Text(l10n.menuExportCode),
      ),
      const Divider(),
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.comma),
        onPressed: () => openSettings(context),
        child: Text(l10n.menuSettings),
      ),
    ];
  }

  List<Widget> _editItems(BuildContext context, EditorState state) {
    final l10n = context.l10n;
    final cubit = context.read<EditorCubit>();
    return [
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.keyZ),
        onPressed: state.history.canUndo ? cubit.undo : null,
        child: Text(l10n.editorUndo),
      ),
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.keyZ, shift: true),
        onPressed: state.history.canRedo ? cubit.redo : null,
        child: Text(l10n.editorRedo),
      ),
      const Divider(),
      const ClipboardMenuItems(withShortcuts: true),
      const Divider(),
      AddWidgetMenu(registry: registry, placement: AddPlacement.inside),
      AddWidgetMenu(registry: registry, placement: AddPlacement.beside),
      RestructureMenuItems(registry: registry),
      ComponentMenuItems(registry: registry),
      const RenameWidgetMenuItem(),
      const Divider(),
      MenuItemButton(
        shortcut: const SingleActivator(LogicalKeyboardKey.delete),
        onPressed: cubit.canCut ? cubit.removeSelected : null,
        child: Text(l10n.editorDelete),
      ),
      MenuItemButton(
        onPressed: () => _rename(context),
        child: Text(l10n.menuRename),
      ),
    ];
  }

  List<Widget> _viewItems(BuildContext context) {
    final l10n = context.l10n;
    final workspace = context.read<WorkspaceCubit>();
    final theme = context.read<SettingsCubit>();
    final state = workspace.state;
    return [
      _CheckedItem(
        label: l10n.menuToolbox,
        checked: state.leftPanel == LeftPanel.toolbox,
        onPressed: () => workspace.toggleLeftPanel(LeftPanel.toolbox),
      ),
      _CheckedItem(
        label: l10n.menuOutline,
        checked: state.leftPanel == LeftPanel.outline,
        onPressed: () => workspace.toggleLeftPanel(LeftPanel.outline),
      ),
      _CheckedItem(
        label: l10n.menuProperties,
        checked: state.propertiesVisible,
        onPressed: workspace.toggleProperties,
      ),
      _CheckedItem(
        label: l10n.menuProblems,
        checked: state.problemsVisible,
        onPressed: workspace.toggleProblems,
      ),
      const Divider(),
      _CheckedItem(
        label: l10n.menuDesign,
        checked: state.centerTab == CenterTab.design,
        onPressed: () => workspace.showCenterTab(CenterTab.design),
      ),
      _CheckedItem(
        label: l10n.menuCode,
        checked: state.centerTab == CenterTab.code,
        onPressed: () => workspace.showCenterTab(CenterTab.code),
      ),
      const Divider(),
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.equal),
        onPressed: workspace.zoomIn,
        child: Text(l10n.menuZoomIn),
      ),
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.minus),
        onPressed: workspace.zoomOut,
        child: Text(l10n.menuZoomOut),
      ),
      MenuItemButton(
        shortcut: commandKey(LogicalKeyboardKey.digit0),
        onPressed: workspace.resetZoom,
        child: Text(l10n.menuZoomReset),
      ),
      const Divider(),
      SubmenuButton(
        menuChildren: [
          for (final (mode, label) in [
            (ThemeMode.system, l10n.settingsThemeSystem),
            (ThemeMode.light, l10n.settingsThemeLight),
            (ThemeMode.dark, l10n.settingsThemeDark),
          ])
            _CheckedItem(
              label: label,
              checked: theme.themeMode == mode,
              onPressed: () => theme.setThemeMode(mode),
            ),
        ],
        child: Text(l10n.menuTheme),
      ),
    ];
  }

  Future<void> _rename(BuildContext context) async {
    final cubit = context.read<EditorCubit>();
    final name = await showDialog<String>(
      context: context,
      builder: (context) =>
          RenameDialog(initialName: cubit.state.document.name),
    );
    if (name != null) cubit.renameDocument(name);
  }
}

/// A menu entry with a check mark in front when [checked].
class _CheckedItem extends StatelessWidget {
  const _CheckedItem({
    required this.label,
    required this.checked,
    required this.onPressed,
  });

  final String label;
  final bool checked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      leadingIcon: Icon(
        checked ? AppIcons.check : null,
        size: AppConstants.spacingMD,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
