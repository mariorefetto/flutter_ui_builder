import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/di/injection.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/component_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/category_labels.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/widget_about.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/widget_help.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/widget_icons.dart';

const double _dialogWidth = 1000;
const double _dialogHeight = 680;
const double _cardWidth = 300;

/// Opens the guide to the widgets.
Future<void> showWidgetGuide(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<EditorCubit>(),
    child: const WidgetGuideDialog(),
  ),
);

/// Every widget of the catalog with what it is, what it holds and where it
/// can go, filtered by its first letter or by a search. A widget can be added
/// to the screen from here.
class WidgetGuideDialog extends StatefulWidget {
  const WidgetGuideDialog({super.key});

  @override
  State<WidgetGuideDialog> createState() => _WidgetGuideDialogState();
}

class _WidgetGuideDialogState extends State<WidgetGuideDialog> {
  final TextEditingController _search = TextEditingController();
  final WidgetRegistry _registry = sl<WidgetRegistry>();
  String? _letter;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<WidgetDefinition> get _all =>
      _registry.all.where((d) => d.type != componentType).toList()..sort(
        (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final all = _all;
    final query = _search.text.trim().toLowerCase();
    final letters = {for (final d in all) d.label[0].toUpperCase()}.toList()
      ..sort();
    final shown = [
      for (final d in all)
        if ((_letter == null || d.label[0].toUpperCase() == _letter) &&
            (d.label.toLowerCase().contains(query) ||
                d.category.toLowerCase().contains(query)))
          d,
    ];
    return AlertDialog(
      title: Text(l10n.guideTitle),
      content: SizedBox(
        width: _dialogWidth,
        height: _dialogHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(AppIcons.search),
                hintText: l10n.guideSearch,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Wrap(
              spacing: AppConstants.spacingXS,
              children: [
                _LetterButton(
                  label: l10n.guideAll,
                  selected: _letter == null,
                  onTap: () => setState(() => _letter = null),
                ),
                for (final letter in letters)
                  _LetterButton(
                    label: letter,
                    selected: _letter == letter,
                    onTap: () => setState(() => _letter = letter),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Expanded(
              child: shown.isEmpty
                  ? Center(child: Text(l10n.paletteNoMatches))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: _cardWidth,
                            mainAxisExtent: 260,
                            crossAxisSpacing: AppConstants.spacingSM,
                            mainAxisSpacing: AppConstants.spacingSM,
                          ),
                      itemCount: shown.length,
                      itemBuilder: (context, index) =>
                          _GuideCard(definition: shown[index]),
                    ),
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

class _LetterButton extends StatelessWidget {
  const _LetterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusSM),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingSM,
          vertical: AppConstants.spacingXS,
        ),
        child: Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(
            color: selected ? colors.primary : colors.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.definition});

  final WidgetDefinition definition;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final tint = colorForCategory(colors, definition.category);
    final url = flutterDocsUrl(definition.type);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingSM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  iconForWidget(definition.type, definition.category),
                  color: tint,
                ),
                const SizedBox(width: AppConstants.spacingSM),
                Expanded(
                  child: Text(
                    definition.label,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            Text(
              categoryLabel(l10n, definition.category),
              style: context.textTheme.labelSmall?.copyWith(color: tint),
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widgetHelp(l10n, definition.type) ??
                          l10n.aboutGeneric(
                            categoryLabel(l10n, definition.category),
                          ),
                      style: context.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppConstants.spacingSM),
                    for (final line in aboutLines(l10n, definition))
                      Text(
                        line,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(AppIcons.add, size: AppConstants.spacingMD),
                  label: Text(l10n.guideAdd),
                  onPressed: () => context.read<EditorCubit>().addToSelection(
                    definition.type,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: l10n.aboutCopyLink,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(AppIcons.copy, size: AppConstants.spacingMD),
                  onPressed: () => Clipboard.setData(ClipboardData(text: url)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
