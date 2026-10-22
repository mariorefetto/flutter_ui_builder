import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

/// The text of something the import left out, in the user's language.
String importIssueMessage(AppLocalizations l10n, ImportIssue issue) =>
    switch (issue.kind) {
      ImportIssueKind.unknownWidget => l10n.importIssueUnknownWidget(
        issue.widgetType,
      ),
      ImportIssueKind.unsupportedArgument =>
        l10n.importIssueUnsupportedArgument(issue.widgetType, issue.argument),
      ImportIssueKind.invalidValue => l10n.importIssueInvalidValue(
        issue.widgetType,
        issue.argument,
      ),
      ImportIssueKind.wrappedInScaffold => l10n.importIssueWrappedInScaffold,
    };
