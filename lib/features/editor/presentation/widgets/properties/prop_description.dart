import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/value_format.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

/// Footer of the properties panel: name, kind of value and default of the
/// property that was last clicked.
class PropDescription extends StatelessWidget {
  const PropDescription({required this.schema, super.key});

  final PropSchema schema;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final defaultValue = schema.defaultValue;
    return ColoredBox(
      color: context.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingSM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schema.label ?? schema.name,
              style: context.textTheme.titleSmall,
            ),
            Text(propTypeLabel(l10n, schema.type)),
            Text(
              defaultValue == null
                  ? l10n.propsNoDefault
                  : propDefaultText(l10n, defaultValue),
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// "Default: 14", with the value written the way the panel shows it.
String propDefaultText(AppLocalizations l10n, Object value) =>
    l10n.propsDefault(_describe(value));

String _describe(Object value) => switch (value) {
  final num number => formatNumber(number.toDouble()),
  final List<Object?> list => list.join(', '),
  _ => '$value',
};

/// Translated kind of value of a property.
String propTypeLabel(AppLocalizations l10n, PropType type) => switch (type) {
  PropType.string => l10n.propsTypeString,
  PropType.number => l10n.propsTypeNumber,
  PropType.boolean => l10n.propsTypeBoolean,
  PropType.color => l10n.propsTypeColor,
  PropType.choice => l10n.propsTypeChoice,
  PropType.edgeInsets => l10n.propsTypeInsets,
};

/// Translated name of a properties panel group.
String propGroupLabel(AppLocalizations l10n, String group) => switch (group) {
  appearanceGroup => l10n.propsGroupAppearance,
  layoutGroup => l10n.propsGroupLayout,
  contentGroup => l10n.propsGroupContent,
  textGroup => l10n.propsGroupText,
  behaviorGroup => l10n.propsGroupBehavior,
  accessibilityGroup => l10n.propsGroupAccessibility,
  _ => group,
};
