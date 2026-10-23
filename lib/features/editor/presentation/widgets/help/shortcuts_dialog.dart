import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_command.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

const double _dialogWidth = 480;

/// Opens the list of keyboard shortcuts.
Future<void> showShortcuts(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const ShortcutsDialog());

/// Every shortcut of the editor by group, with the keys on the right, as they
/// are on this computer.
class ShortcutsDialog extends StatelessWidget {
  const ShortcutsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.menuShortcuts),
      content: SizedBox(
        width: _dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final group in ShortcutGroup.values) ...[
                _Heading(_groupLabel(l10n, group)),
                for (final command in EditorCommand.values)
                  if (command.group == group) _Row(command: command),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonClose),
        ),
      ],
    );
  }

  String _groupLabel(AppLocalizations l10n, ShortcutGroup group) =>
      switch (group) {
        ShortcutGroup.file => l10n.menuFile,
        ShortcutGroup.edit => l10n.menuEdit,
        ShortcutGroup.structure => l10n.shortcutsStructure,
        ShortcutGroup.view => l10n.menuView,
        ShortcutGroup.help => l10n.menuHelp,
      };
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: AppConstants.spacingMD,
      bottom: AppConstants.spacingXS,
    ),
    child: Text(
      text.toUpperCase(),
      style: context.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: context.colorScheme.onSurfaceVariant,
      ),
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.command});

  final EditorCommand command;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingXS),
      child: Row(
        children: [
          Expanded(child: Text(command.label(context.l10n))),
          for (final activator in command.activators) ...[
            const SizedBox(width: AppConstants.spacingSM),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingSM,
                  vertical: AppConstants.spacingXS,
                ),
                child: Text(
                  shortcutLabel(activator),
                  style: context.textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
