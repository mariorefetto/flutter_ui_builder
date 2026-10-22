import 'package:flutter_ui_builder/features/editor/domain/entities/problem.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

/// The text of a problem, in the user's language.
String problemMessage(AppLocalizations l10n, Problem problem) =>
    switch (problem.code) {
      ProblemCode.navigationBarFewDestinations =>
        l10n.problemNavigationBarFewDestinations,
      ProblemCode.hiddenTextMultiline => l10n.problemHiddenTextMultiline,
      ProblemCode.avatarRadiusConflict => l10n.problemAvatarRadiusConflict,
      ProblemCode.positionedOverconstrained =>
        l10n.problemPositionedOverconstrained,
      ProblemCode.imageWithoutLabel => l10n.problemImageWithoutLabel,
      ProblemCode.imageWithoutUrl => l10n.problemImageWithoutUrl,
      ProblemCode.requiredChildMissing => l10n.problemRequiredChildMissing(
        problem.nodeType,
      ),
      ProblemCode.sliderRange => l10n.problemSliderRange,
      ProblemCode.threeLineWithoutSubtitle =>
        l10n.problemThreeLineWithoutSubtitle,
      ProblemCode.missingTooltip => l10n.problemMissingTooltip,
      ProblemCode.circleWithRadius => l10n.problemCircleWithRadius,
      ProblemCode.lowContrast => l10n.problemLowContrast,
      ProblemCode.smallTapTarget => l10n.problemSmallTapTarget,
    };
