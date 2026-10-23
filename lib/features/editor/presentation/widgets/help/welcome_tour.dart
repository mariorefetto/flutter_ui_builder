import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

const double _tourWidth = 520;
const double _illustration = 72;
const double _dot = 8;

/// Shows the welcome tour the first time the editor opens, and remembers that
/// it was seen so that it does not come back.
class FirstRunTour extends StatefulWidget {
  const FirstRunTour({required this.child, super.key});

  final Widget child;

  @override
  State<FirstRunTour> createState() => _FirstRunTourState();
}

class _FirstRunTourState extends State<FirstRunTour> {
  @override
  void initState() {
    super.initState();
    // After the first frame, so the dialog opens over a built editor.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !context.read<SettingsCubit>().state.tourSeen) {
        showWelcomeTour(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Opens the welcome tour. Closing it, by finishing or skipping, counts as
/// having seen it.
Future<void> showWelcomeTour(BuildContext context) async {
  final settings = context.read<SettingsCubit>();
  await showDialog<void>(
    context: context,
    builder: (_) => const WelcomeTourDialog(),
  );
  await settings.update((s) => s.copyWith(tourSeen: true));
}

class _Step {
  const _Step(this.icon, this.title, this.body);

  final IconData icon;
  final String title;
  final String body;
}

List<_Step> _steps(AppLocalizations l10n) => [
  _Step(AppIcons.tools, l10n.tourAddTitle, l10n.tourAddBody),
  _Step(AppIcons.design, l10n.tourEditTitle, l10n.tourEditBody),
  _Step(AppIcons.code, l10n.tourCodeTitle, l10n.tourCodeBody),
  _Step(AppIcons.screens, l10n.tourProjectTitle, l10n.tourProjectBody),
];

/// A few steps that show what the editor does and where to find it.
class WelcomeTourDialog extends StatefulWidget {
  const WelcomeTourDialog({super.key});

  @override
  State<WelcomeTourDialog> createState() => _WelcomeTourDialogState();
}

class _WelcomeTourDialogState extends State<WelcomeTourDialog> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final steps = _steps(l10n);
    final step = steps[_index];
    final last = _index == steps.length - 1;
    return AlertDialog(
      title: Text(l10n.tourTitle(_index + 1, steps.length)),
      content: SizedBox(
        width: _tourWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(step.icon, size: _illustration, color: colors.primary),
            const SizedBox(height: AppConstants.spacingMD),
            Text(step.title, style: context.textTheme.titleMedium),
            const SizedBox(height: AppConstants.spacingSM),
            Text(step.body, style: context.textTheme.bodyMedium),
            const SizedBox(height: AppConstants.spacingLG),
            // The controls are in the content, not in the dialog's actions:
            // those sit in an overflow bar, which cannot space them out.
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.tourSkip),
                ),
                const Spacer(),
                for (var i = 0; i < steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingXS / 2,
                    ),
                    child: SizedBox.square(
                      dimension: _dot,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _index
                              ? colors.primary
                              : colors.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: _index == 0
                      ? null
                      : () => setState(() => _index--),
                  child: Text(l10n.tourBack),
                ),
                const SizedBox(width: AppConstants.spacingSM),
                FilledButton(
                  onPressed: () => last
                      ? Navigator.of(context).pop()
                      : setState(() => _index++),
                  child: Text(last ? l10n.tourDone : l10n.tourNext),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
