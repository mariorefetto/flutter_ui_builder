import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

const double _dialogWidth = 640;
const double _dialogHeight = 520;

/// Opens the answers to the questions asked most.
Future<void> showFaq(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const FaqDialog());

/// The questions people ask when they start, each with its answer, opened
/// one at a time.
class FaqDialog extends StatelessWidget {
  const FaqDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.faqTitle),
      content: SizedBox(
        width: _dialogWidth,
        height: _dialogHeight,
        child: ListView(
          children: [
            for (final (question, answer) in faqEntries(l10n))
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(
                  bottom: AppConstants.spacingMD,
                ),
                expandedAlignment: Alignment.centerLeft,
                title: Text(question),
                children: [Text(answer)],
              ),
          ],
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
}

/// The questions and their answers, in the user's language.
List<(String, String)> faqEntries(AppLocalizations l10n) => [
  (l10n.faqSaveQuestion, l10n.faqSaveAnswer),
  (l10n.faqExportQuestion, l10n.faqExportAnswer),
  (l10n.faqCodeQuestion, l10n.faqCodeAnswer),
  (l10n.faqCannotAddQuestion, l10n.faqCannotAddAnswer),
  (l10n.faqScreensQuestion, l10n.faqScreensAnswer),
  (l10n.faqComponentsQuestion, l10n.faqComponentsAnswer),
  (l10n.faqProblemsQuestion, l10n.faqProblemsAnswer),
  (l10n.faqUndoQuestion, l10n.faqUndoAnswer),
];
