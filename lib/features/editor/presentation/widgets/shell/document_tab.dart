import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/screen_templates.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/project_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/file/rename_dialog.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

/// The value of the "+" menu entry that adds a component.
const String _componentChoice = 'component';

enum _ScreenAction { rename, duplicate, makeHome, delete }

/// The tabs of the project's screens, above the designer. A tap opens a
/// screen, a tap on the open one renames it, a right click offers the rest,
/// and the plus adds a screen. A marker shows unsaved changes.
class DocumentTab extends StatelessWidget {
  const DocumentTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final saved = context.select((ProjectCubit c) => c.state.savedDocument);
    return ColoredBox(
      color: colors.surfaceContainerHigh,
      child: BlocBuilder<EditorCubit, EditorState>(
        buildWhen: (previous, current) => previous.document != current.document,
        builder: (context, state) {
          final document = state.document;
          final entries = const ScreenEditor().entriesOf(document);
          final names = [for (final e in entries) e.name];
          // The app starts on the first screen, whatever comes before it.
          final firstScreen = entries.indexWhere((e) => !e.component);
          final unsaved = !const ScreenEditor().sameContent(document, saved);
          return Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final (index, name) in names.indexed)
                        _ScreenTab(
                          name: name,
                          active: index == document.activeIndex,
                          home: index == firstScreen,
                          component: entries[index].component,
                          modified: unsaved && index == document.activeIndex,
                          onlyScreen: names.length == 1,
                        ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<String>(
                tooltip: context.l10n.screenNew,
                icon: const Icon(AppIcons.add),
                iconSize: AppConstants.spacingMD,
                onSelected: (choice) => _add(context, names, choice),
                itemBuilder: (context) => [
                  for (final template in ScreenTemplate.values)
                    PopupMenuItem(
                      value: template.name,
                      child: Text(_templateLabel(context.l10n, template)),
                    ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: _componentChoice,
                    child: Text(context.l10n.componentNew),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // A template's name, or the component choice, picked in the "+" menu.
  Future<void> _add(
    BuildContext context,
    List<String> names,
    String choice,
  ) async {
    final cubit = context.read<EditorCubit>();
    final l10n = context.l10n;
    final component = choice == _componentChoice;
    final template = ScreenTemplate.values.asNameMap()[choice];
    final name = await showDialog<String>(
      context: context,
      builder: (context) => RenameDialog(
        initialName: component
            ? l10n.componentDefaultName(names.length + 1)
            : template == null || template == ScreenTemplate.blank
            ? l10n.screenDefaultName(names.length + 1)
            : _templateLabel(l10n, template),
        title: component ? l10n.componentNewTitle : l10n.screenNewTitle,
        hint: component ? l10n.componentExtractTitle : l10n.screenNameHint,
      ),
    );
    if (name == null) return;
    if (component) {
      cubit.addComponent(name);
    } else {
      cubit.addScreen(name, template: template ?? ScreenTemplate.blank);
    }
  }

  String _templateLabel(AppLocalizations l10n, ScreenTemplate template) =>
      switch (template) {
        ScreenTemplate.blank => l10n.templateBlank,
        ScreenTemplate.login => l10n.templateLogin,
        ScreenTemplate.settings => l10n.templateSettings,
        ScreenTemplate.profile => l10n.templateProfile,
        ScreenTemplate.inbox => l10n.templateInbox,
        ScreenTemplate.onboarding => l10n.templateOnboarding,
      };
}

class _ScreenTab extends StatelessWidget {
  const _ScreenTab({
    required this.name,
    required this.active,
    required this.home,
    required this.component,
    required this.modified,
    required this.onlyScreen,
  });

  final String name;
  final bool active;

  /// The screen the app starts on.
  final bool home;

  /// A component rather than a screen.
  final bool component;
  final bool modified;
  final bool onlyScreen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final l10n = context.l10n;
    final cubit = context.read<EditorCubit>();
    return GestureDetector(
      onSecondaryTapUp: (details) =>
          _menu(context, details.globalPosition, cubit),
      child: Tooltip(
        message: active
            ? l10n.editorDocumentTabTooltip
            : l10n.screenOpenTooltip(name),
        child: InkWell(
          onTap: () =>
              active ? _rename(context, cubit) : cubit.openScreen(name),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: active ? colors.surface : null,
              border: Border(
                top: BorderSide(
                  color: active ? colors.primary : Colors.transparent,
                  width: AppConstants.borderWidthMedium,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMD,
                vertical: AppConstants.spacingSM,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (home || component) ...[
                    Icon(
                      component ? AppIcons.component : AppIcons.home,
                      size: AppConstants.spacingMD,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppConstants.spacingSM),
                  ],
                  Text(
                    modified ? l10n.editorTitleModified(name) : name,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: active ? null : colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _rename(BuildContext context, EditorCubit cubit) async {
    final to = await showDialog<String>(
      context: context,
      builder: (context) => RenameDialog(initialName: name),
    );
    if (to != null) cubit.renameScreen(name, to);
  }

  Future<void> _menu(
    BuildContext context,
    Offset position,
    EditorCubit cubit,
  ) async {
    final l10n = context.l10n;
    final overlay = Overlay.of(context).context.findRenderObject();
    if (overlay is! RenderBox) return;
    final action = await showMenu<_ScreenAction>(
      context: context,
      position: RelativeRect.fromRect(
        position & Size.zero,
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          value: _ScreenAction.rename,
          child: Text(l10n.screenRename),
        ),
        PopupMenuItem(
          value: _ScreenAction.duplicate,
          child: Text(l10n.menuDuplicate),
        ),
        PopupMenuItem(
          enabled: !home && !component,
          value: _ScreenAction.makeHome,
          child: Text(l10n.screenMakeHome),
        ),
        PopupMenuItem(
          enabled: !onlyScreen,
          value: _ScreenAction.delete,
          child: Text(l10n.screenDelete),
        ),
      ],
    );
    if (!context.mounted || action == null) return;
    switch (action) {
      case _ScreenAction.rename:
        await _rename(context, cubit);
      case _ScreenAction.duplicate:
        cubit.duplicateScreen(name);
      case _ScreenAction.makeHome:
        cubit.makeHomeScreen(name);
      case _ScreenAction.delete:
        cubit.deleteScreen(name);
    }
  }
}
