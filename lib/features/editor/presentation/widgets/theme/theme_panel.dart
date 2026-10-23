import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/project_theme_definitions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/prop_row.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

/// The theme of the app: the colours and font of all of it, and the theme of
/// each kind of widget, such as how every elevated button looks. A part opens
/// to its properties, which are edited as those of a widget are, and a part
/// can be put back to Flutter's defaults. The screens are drawn with this
/// theme and the code gets it as `buildAppTheme`.
class ThemePanel extends StatefulWidget {
  const ThemePanel({super.key});

  @override
  State<ThemePanel> createState() => _ThemePanelState();
}

class _ThemePanelState extends State<ThemePanel> {
  // The colours and font are open; the themes of the widgets open on demand.
  final Set<String> _open = {'scheme'};
  String? _focused;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<EditorCubit, EditorState>(
      buildWhen: (previous, current) =>
          previous.document.theme != current.document.theme,
      builder: (context, state) {
        final theme = state.document.theme;
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingSM),
              child: Text(
                l10n.themeIntro,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            for (final part in themeParts) ...[
              _Header(
                title: partTitle(l10n, part.name),
                open: _open.contains(part.name),
                changed: theme.parts[part.name]?.isNotEmpty ?? false,
                onTap: () => setState(
                  () => _open.contains(part.name)
                      ? _open.remove(part.name)
                      : _open.add(part.name),
                ),
                onReset: () =>
                    context.read<EditorCubit>().resetThemePart(part.name),
              ),
              if (_open.contains(part.name))
                for (final schema in part.props)
                  PropRow(
                    key: ValueKey('theme-${part.name}-${schema.name}'),
                    schema: schema,
                    props: theme.valuesOf(part.name, part.props),
                    modified:
                        theme.parts[part.name]?.containsKey(schema.name) ??
                        false,
                    focused: _focused == '${part.name}.${schema.name}',
                    onFocus: () => setState(
                      () => _focused = '${part.name}.${schema.name}',
                    ),
                    onChanged: (value) => context
                        .read<EditorCubit>()
                        .setThemeValue(part.name, schema.name, value),
                  ),
            ],
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.open,
    required this.changed,
    required this.onTap,
    required this.onReset,
  });

  final String title;
  final bool open;

  /// The part has values of its own, so it can be reset.
  final bool changed;
  final VoidCallback onTap;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return InkWell(
      onTap: onTap,
      child: ColoredBox(
        color: colors.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingXS,
            vertical: AppConstants.spacingXS,
          ),
          child: Row(
            children: [
              Icon(
                open ? AppIcons.expand : AppIcons.collapsed,
                size: AppConstants.spacingLG,
              ),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: changed ? FontWeight.w700 : null,
                  ),
                ),
              ),
              if (changed)
                IconButton(
                  tooltip: context.l10n.themeReset,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(AppIcons.reset),
                  onPressed: onReset,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The name of a part of the theme, in the user's language.
String partTitle(AppLocalizations l10n, String part) => switch (part) {
  'scheme' => l10n.themeScheme,
  'appBar' => l10n.themeAppBar,
  'elevatedButton' => l10n.themeElevatedButton,
  'filledButton' => l10n.themeFilledButton,
  'outlinedButton' => l10n.themeOutlinedButton,
  'textButton' => l10n.themeTextButton,
  'card' => l10n.themeCard,
  'inputDecoration' => l10n.themeInput,
  'floatingActionButton' => l10n.themeFab,
  'listTile' => l10n.themeListTile,
  'divider' => l10n.themeDivider,
  _ => part,
};
