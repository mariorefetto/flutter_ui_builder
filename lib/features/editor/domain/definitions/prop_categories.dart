import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

// Groups of the properties panel, in display order.
const String appearanceGroup = 'Appearance';
const String layoutGroup = 'Layout';
const String contentGroup = 'Content';
const String textGroup = 'Text';
const String behaviorGroup = 'Behavior';
const String accessibilityGroup = 'Accessibility';

/// All groups, in the order the panel shows them.
const List<String> propGroups = [
  contentGroup,
  textGroup,
  layoutGroup,
  appearanceGroup,
  behaviorGroup,
  accessibilityGroup,
];

const Set<String> _layout = {
  'width',
  'height',
  'minWidth',
  'maxWidth',
  'minHeight',
  'maxHeight',
  'padding',
  'margin',
  'contentPadding',
  'alignment',
  'flex',
  'fit',
  'left',
  'top',
  'right',
  'bottom',
  'widthFactor',
  'heightFactor',
  'aspectRatio',
  'spacing',
  'runSpacing',
  'mainAxisSize',
  'mainAxisAlignment',
  'crossAxisAlignment',
  'direction',
  'scrollDirection',
  'crossAxisCount',
  'mainAxisSpacing',
  'crossAxisSpacing',
  'childAspectRatio',
  'indent',
  'endIndent',
  'itemExtent',
  'toolbarHeight',
  'controlAffinity',
};

const Set<String> _text = {
  'text',
  'fontSize',
  'fontWeight',
  'fontFamily',
  'italic',
  'decoration',
  'letterSpacing',
  'textAlign',
  'maxLines',
  'minLines',
  'overflow',
  'softWrap',
};

const Set<String> _content = {
  'title',
  'subtitle',
  'label',
  'labelText',
  'hintText',
  'helperText',
  'errorText',
  'placeholder',
  'url',
  'icon',
  'leading',
  'trailing',
  'leadingIcon',
  'actionIcon',
  'prefixIcon',
  'suffixIcon',
  'selectedIcon',
  'avatar',
  'additionalInfo',
  'message',
  'previousPageTitle',
  'value',
};

const Set<String> _accessibility = {
  'semanticLabel',
  'semanticsLabel',
  'tooltip',
  'hint',
  'button',
  'header',
  'excludeSemantics',
  'excluding',
};

const Set<String> _appearance = {
  'borderRadius',
  'borderColor',
  'borderWidth',
  'border',
  'elevation',
  'shape',
  'opacity',
  'scale',
  'angle',
  'turns',
  'quarterTurns',
  'radius',
  'minRadius',
  'maxRadius',
  'strokeWidth',
  'thickness',
  'size',
  'iconSize',
  'repeat',
  'clipBehavior',
  'filled',
  'fillColor',
  'position',
  'pressedOpacity',
  'gradientStart',
  'gradientEnd',
  'gradientDirection',
  'radiusTopLeft',
  'radiusTopRight',
  'radiusBottomLeft',
  'radiusBottomRight',
  'borderLeftWidth',
  'borderTopWidth',
  'borderRightWidth',
  'borderBottomWidth',
  'shadowColor',
  'shadowBlur',
  'shadowSpread',
  'shadowOffsetX',
  'shadowOffsetY',
  'fallbackWidth',
  'fallbackHeight',
  'centerTitle',
  'mini',
  'statusBarStyle',
};

/// The group of the properties panel a property belongs to: its explicit
/// category, else the group its name is listed under, else one derived from
/// its type.
String propCategoryOf(PropSchema schema) {
  final explicit = schema.category;
  if (explicit != null) return explicit;
  final name = schema.name;
  if (_accessibility.contains(name)) return accessibilityGroup;
  if (_text.contains(name)) return textGroup;
  if (_layout.contains(name)) return layoutGroup;
  if (_appearance.contains(name)) return appearanceGroup;
  if (_content.contains(name)) return contentGroup;
  return switch (schema.type) {
    PropType.color => appearanceGroup,
    PropType.edgeInsets => layoutGroup,
    PropType.string => contentGroup,
    PropType.boolean || PropType.choice || PropType.number => behaviorGroup,
  };
}
