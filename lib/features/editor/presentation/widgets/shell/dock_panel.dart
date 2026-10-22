import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';

/// A docked panel with a title bar, like the tool windows of an IDE.
class DockPanel extends StatelessWidget {
  const DockPanel({
    required this.title,
    required this.child,
    this.onClose,
    super.key,
  });

  final String title;
  final Widget child;

  /// Shows a close button in the title bar when given.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    // Material, not ColoredBox, so the ink of the list tiles inside shows.
    return Material(
      color: context.colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: context.colorScheme.surfaceContainerHigh,
            child: Padding(
              padding: const EdgeInsets.only(left: AppConstants.spacingSM),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: context.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onClose != null)
                    IconButton(
                      tooltip: context.l10n.panelClose,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(AppIcons.close),
                      onPressed: onClose,
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
