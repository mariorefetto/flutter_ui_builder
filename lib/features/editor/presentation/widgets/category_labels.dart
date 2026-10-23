import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

/// Translated name of a palette category. Unknown categories, such as those
/// of newly registered widgets, are shown as registered.
String categoryLabel(AppLocalizations l10n, String category) =>
    switch (category) {
      screenCategory => l10n.editorCategoryScreen,
      layoutCategory => l10n.editorCategoryLayout,
      textCategory => l10n.editorCategoryText,
      imagesCategory => l10n.editorCategoryImagesIcons,
      buttonsCategory => l10n.editorCategoryButtons,
      inputCategory => l10n.editorCategoryInput,
      informationCategory => l10n.editorCategoryInformation,
      scrollingCategory => l10n.editorCategoryScrolling,
      paintingCategory => l10n.editorCategoryPainting,
      animationCategory => l10n.editorCategoryAnimation,
      interactionCategory => l10n.editorCategoryInteraction,
      accessibilityCategory => l10n.editorCategoryAccessibility,
      cupertinoCategory => l10n.editorCategoryCupertino,
      componentsCategory => l10n.editorCategoryComponents,
      _ => category,
    };
