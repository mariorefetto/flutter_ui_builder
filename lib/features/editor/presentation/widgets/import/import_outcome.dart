import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/error/failure_messages.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/import/import_messages.dart';

/// What the last render found: a failure with its detail, or the number of
/// widgets and everything that was left out.
class ImportOutcomeView extends StatelessWidget {
  const ImportOutcomeView({
    required this.result,
    required this.failure,
    super.key,
  });

  final ImportResult? result;
  final Failure? failure;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final failure = this.failure;
    final result = this.result;
    if (failure != null) {
      return _Message(
        icon: AppIcons.error,
        color: context.colorScheme.error,
        text: messageFor(l10n, failure),
        detail: failure.message,
      );
    }
    if (result == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Message(
          icon: AppIcons.success,
          color: context.colorScheme.primary,
          text: l10n.importFound(result.document.root.countNodes()),
        ),
        if (result.issues.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingSM),
          Text(l10n.importIssuesTitle, style: context.textTheme.titleSmall),
          for (final issue in result.issues)
            _Message(
              icon: AppIcons.warning,
              color: context.colorScheme.tertiary,
              text: importIssueMessage(l10n, issue),
            ),
        ],
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.color,
    required this.text,
    this.detail,
  });

  final IconData icon;
  final Color color;
  final String text;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppConstants.spacingLG),
          const SizedBox(width: AppConstants.spacingSM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text),
                if (detail != null && detail!.isNotEmpty)
                  Text(detail!, style: context.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
