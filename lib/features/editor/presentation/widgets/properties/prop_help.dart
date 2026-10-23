import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/prop_description.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

/// Options listed in a tooltip before it says "and more".
const int _shownOptions = 8;

/// The properties that have a written explanation.
const List<String> describedProps = [
  'seedColor',
  'brightness',
  'useMaterial3',
  'filled',
  'fillColor',
  'thickness',
  'iconColor',
  'textColor',
  'tileColor',
  'width',
  'height',
  'padding',
  'margin',
  'alignment',
  'color',
  'backgroundColor',
  'foregroundColor',
  'elevation',
  'borderRadius',
  'borderColor',
  'borderWidth',
  'shadowColor',
  'shadowBlur',
  'shadowSpread',
  'shadowOffsetX',
  'shadowOffsetY',
  'gradientStart',
  'gradientEnd',
  'gradientDirection',
  'fontSize',
  'fontWeight',
  'fontFamily',
  'textAlign',
  'maxLines',
  'overflow',
  'letterSpacing',
  'flex',
  'spacing',
  'mainAxisAlignment',
  'crossAxisAlignment',
  'mainAxisSize',
  'fit',
  'title',
  'subtitle',
  'label',
  'icon',
  'url',
  'source',
  'value',
  'min',
  'max',
  'enabled',
  'obscureText',
  'keyboardType',
  'duration',
  'curve',
  'opacity',
  'scale',
  'tooltip',
  'semanticLabel',
  'statusBarStyle',
  'centerTitle',
  'shape',
];

/// The sentence that explains a property, for the commonly used ones, or null.
String? propHelp(AppLocalizations l10n, String name) => switch (name) {
  'seedColor' => l10n.propHelpSeedColor,
  'brightness' => l10n.propHelpBrightness,
  'useMaterial3' => l10n.propHelpUseMaterial3,
  'filled' => l10n.propHelpFilled,
  'fillColor' => l10n.propHelpFillColor,
  'thickness' => l10n.propHelpThickness,
  'iconColor' => l10n.propHelpIconColor,
  'textColor' => l10n.propHelpTextColor,
  'tileColor' => l10n.propHelpTileColor,
  'width' => l10n.propHelpWidth,
  'height' => l10n.propHelpHeight,
  'padding' => l10n.propHelpPadding,
  'margin' => l10n.propHelpMargin,
  'alignment' => l10n.propHelpAlignment,
  'color' => l10n.propHelpColor,
  'backgroundColor' => l10n.propHelpBackgroundColor,
  'foregroundColor' => l10n.propHelpForegroundColor,
  'elevation' => l10n.propHelpElevation,
  'borderRadius' => l10n.propHelpBorderRadius,
  'borderColor' => l10n.propHelpBorderColor,
  'borderWidth' => l10n.propHelpBorderWidth,
  'shadowColor' => l10n.propHelpShadowColor,
  'shadowBlur' => l10n.propHelpShadowBlur,
  'shadowSpread' => l10n.propHelpShadowSpread,
  'shadowOffsetX' => l10n.propHelpShadowOffsetX,
  'shadowOffsetY' => l10n.propHelpShadowOffsetY,
  'gradientStart' => l10n.propHelpGradientStart,
  'gradientEnd' => l10n.propHelpGradientEnd,
  'gradientDirection' => l10n.propHelpGradientDirection,
  'fontSize' => l10n.propHelpFontSize,
  'fontWeight' => l10n.propHelpFontWeight,
  'fontFamily' => l10n.propHelpFontFamily,
  'textAlign' => l10n.propHelpTextAlign,
  'maxLines' => l10n.propHelpMaxLines,
  'overflow' => l10n.propHelpOverflow,
  'letterSpacing' => l10n.propHelpLetterSpacing,
  'flex' => l10n.propHelpFlex,
  'spacing' => l10n.propHelpSpacing,
  'mainAxisAlignment' => l10n.propHelpMainAxisAlignment,
  'crossAxisAlignment' => l10n.propHelpCrossAxisAlignment,
  'mainAxisSize' => l10n.propHelpMainAxisSize,
  'fit' => l10n.propHelpFit,
  'title' => l10n.propHelpTitle,
  'subtitle' => l10n.propHelpSubtitle,
  'label' => l10n.propHelpLabel,
  'icon' => l10n.propHelpIcon,
  'url' => l10n.propHelpUrl,
  'source' => l10n.propHelpSource,
  'value' => l10n.propHelpValue,
  'min' => l10n.propHelpMin,
  'max' => l10n.propHelpMax,
  'enabled' => l10n.propHelpEnabled,
  'obscureText' => l10n.propHelpObscureText,
  'keyboardType' => l10n.propHelpKeyboardType,
  'duration' => l10n.propHelpDuration,
  'curve' => l10n.propHelpCurve,
  'opacity' => l10n.propHelpOpacity,
  'scale' => l10n.propHelpScale,
  'tooltip' => l10n.propHelpTooltip,
  'semanticLabel' => l10n.propHelpSemanticLabel,
  'statusBarStyle' => l10n.propHelpStatusBarStyle,
  'centerTitle' => l10n.propHelpCenterTitle,
  'shape' => l10n.propHelpShape,
  _ => null,
};

/// What the tooltip of a property says: the explanation when there is one,
/// then what is always known from its schema: the kind of value, the
/// default, the options and the constructor argument it becomes in the code.
String propTooltip(AppLocalizations l10n, PropSchema schema) {
  final lines = [
    ?propHelp(l10n, schema.name),
    propTypeLabel(l10n, schema.type),
    ?_defaultLine(l10n, schema),
    ?_optionsLine(l10n, schema),
    _codeLine(l10n, schema),
  ];
  return lines.join('\n');
}

String? _defaultLine(AppLocalizations l10n, PropSchema schema) {
  final value = schema.defaultValue;
  return value == null ? null : propDefaultText(l10n, value);
}

String? _optionsLine(AppLocalizations l10n, PropSchema schema) {
  if (schema.type != PropType.choice || schema.iconPicker) return null;
  final shown = schema.options.take(_shownOptions).join(', ');
  final more = schema.options.length > _shownOptions ? ', ...' : '';
  return l10n.propsOptions('$shown$more');
}

String _codeLine(AppLocalizations l10n, PropSchema schema) {
  final argument = schema.argument ?? schema.name;
  final group = schema.group;
  return group == null
      ? l10n.propsCodeArgument(argument)
      : l10n.propsGroupedArgument(argument, group);
}
