import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/category_labels.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/widget_help.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

const String _docsRoot = 'https://api.flutter.dev/flutter';

/// Widgets that live in the `widgets` library of Flutter. The Cupertino ones
/// are told by their name, and everything else is Material.
const Set<String> _widgetsLibrary = {
  'Column',
  'Row',
  'Stack',
  'Container',
  'Padding',
  'Center',
  'Align',
  'SizedBox',
  'Expanded',
  'Flexible',
  'Spacer',
  'SafeArea',
  'SingleChildScrollView',
  'Wrap',
  'ListView',
  'GridView',
  'Text',
  'Image',
  'Icon',
  'GestureDetector',
  'Opacity',
  'FittedBox',
  'AspectRatio',
  'IntrinsicHeight',
  'IntrinsicWidth',
  'Positioned',
  'DecoratedBox',
  'ColoredBox',
  'Transform',
  'ClipRRect',
};

/// The page of the Flutter API documentation for a widget [type].
String flutterDocsUrl(String type) {
  final library = type.startsWith('Cupertino')
      ? 'cupertino'
      : _widgetsLibrary.contains(type)
      ? 'widgets'
      : 'material';
  return '$_docsRoot/$library/$type-class.html';
}

/// What the selected widget is and where it can go: a sentence, the rules
/// about what it holds and where it may be placed, and a link to the Flutter
/// documentation. It opens and closes, and stays as it was left.
class WidgetAbout extends StatefulWidget {
  const WidgetAbout({required this.definition, super.key});

  final WidgetDefinition definition;

  @override
  State<WidgetAbout> createState() => _WidgetAboutState();
}

class _WidgetAboutState extends State<WidgetAbout> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingSM,
                vertical: AppConstants.spacingSM,
              ),
              child: Row(
                children: [
                  Icon(
                    _open ? AppIcons.expand : AppIcons.collapsed,
                    size: AppConstants.spacingMD,
                  ),
                  const SizedBox(width: AppConstants.spacingSM),
                  Icon(
                    AppIcons.info,
                    size: AppConstants.spacingMD,
                    color: colors.primary,
                  ),
                  const SizedBox(width: AppConstants.spacingSM),
                  Expanded(
                    child: Text(
                      l10n.aboutTitle,
                      style: context.textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_open) _body(context, l10n),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, AppLocalizations l10n) {
    final definition = widget.definition;
    final style = context.textTheme.bodySmall;
    final muted = style?.copyWith(color: context.colorScheme.onSurfaceVariant);
    final category = categoryLabel(l10n, definition.category);
    final url = flutterDocsUrl(definition.type);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingMD,
        0,
        AppConstants.spacingSM,
        AppConstants.spacingSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widgetHelp(l10n, definition.type) ?? l10n.aboutGeneric(category),
            style: style,
          ),
          const SizedBox(height: AppConstants.spacingSM),
          for (final line in aboutLines(l10n, definition))
            Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingXS),
              child: Text(line, style: muted),
            ),
          Row(
            children: [
              Expanded(
                child: Tooltip(
                  message: l10n.aboutDocs,
                  child: SelectableText(
                    url,
                    style: muted?.copyWith(
                      color: context.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.aboutCopyLink,
                visualDensity: VisualDensity.compact,
                icon: const Icon(AppIcons.copy),
                onPressed: () => Clipboard.setData(ClipboardData(text: url)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The rules of a widget, one sentence each: what it holds and where it may
/// be placed.
List<String> aboutLines(AppLocalizations l10n, WidgetDefinition definition) {
  final allowed = definition.allowedParents;
  final needs = definition.requiredAncestors;
  return [
    switch (definition.childPolicy) {
      ChildPolicy.none => l10n.aboutNoChild,
      ChildPolicy.single => l10n.aboutOneChild,
      ChildPolicy.multiple => l10n.aboutManyChildren,
    },
    if (definition.requiresChild) l10n.aboutNeedsChild,
    if (allowed != null && allowed.isNotEmpty)
      l10n.aboutOnlyIn((allowed.toList()..sort()).join(', ')),
    if (definition.forbiddenParents.isNotEmpty)
      l10n.aboutNotIn(
        (definition.forbiddenParents.toList()..sort()).join(', '),
      ),
    if (needs != null && needs.isNotEmpty)
      l10n.aboutNeedsMaterial((needs.toList()..sort()).join(', ')),
    if (definition.autoWrap.isNotEmpty) l10n.aboutWrapped,
  ];
}
