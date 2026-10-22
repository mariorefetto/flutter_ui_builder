import 'package:flutter_ui_builder/features/editor/domain/definitions/icon_names.dart';

// Values shared by several widget definitions.

/// Default font size of a Text node.
const double defaultFontSize = 14;

/// Default padding of a Padding node, applied to every side.
const double defaultPaddingValue = 8;

/// Default padding list in the storage form [left, top, right, bottom].
const List<double> defaultPadding = [
  defaultPaddingValue,
  defaultPaddingValue,
  defaultPaddingValue,
  defaultPaddingValue,
];

const List<String> mainAxisAlignmentOptions = [
  'start',
  'end',
  'center',
  'spaceBetween',
  'spaceAround',
  'spaceEvenly',
];

const List<String> crossAxisAlignmentOptions = [
  'start',
  'end',
  'center',
  'stretch',
];

/// Names of the Alignment constants a node can use.
const List<String> alignmentOptions = [
  'topLeft',
  'topCenter',
  'topRight',
  'centerLeft',
  'center',
  'centerRight',
  'bottomLeft',
  'bottomCenter',
  'bottomRight',
];

/// Names of the BoxFit values an Image node can use.
const List<String> boxFitOptions = [
  'fill',
  'contain',
  'cover',
  'fitWidth',
  'fitHeight',
  'none',
  'scaleDown',
];

/// Names of the Icons constants the Icon and FloatingActionButton nodes can
/// use: every filled and outlined Material icon. The presentation layer maps
/// each name to its IconData.
const List<String> iconOptions = iconNames;

/// Default size of an Icon node.
const double defaultIconSize = 24;

// Option lists below hold the member names of the Flutter enum or constant
// set named in their comment. A test builds every option to keep them honest.

/// MainAxisSize.
const List<String> mainAxisSizeOptions = ['min', 'max'];

/// TextAlign.
const List<String> textAlignOptions = [
  'left',
  'right',
  'center',
  'justify',
  'start',
  'end',
];

/// TextOverflow.
const List<String> textOverflowOptions = [
  'clip',
  'fade',
  'ellipsis',
  'visible',
];

/// FontWeight constants.
const List<String> fontWeightOptions = [
  'w300',
  'normal',
  'w500',
  'w600',
  'bold',
  'w800',
];

/// FlexFit.
const List<String> flexFitOptions = ['tight', 'loose'];

/// Axis.
const List<String> axisOptions = ['horizontal', 'vertical'];

/// WrapAlignment.
const List<String> wrapAlignmentOptions = [
  'start',
  'end',
  'center',
  'spaceBetween',
  'spaceAround',
  'spaceEvenly',
];

/// WrapCrossAlignment.
const List<String> wrapCrossAlignmentOptions = ['start', 'end', 'center'];

/// Default fill color of a ColoredBox, a light grey.
const int defaultFillColor = 0xFFE0E0E0;

/// Default duration of implicit animations, in milliseconds.
const int defaultAnimationMilliseconds = 300;

/// Default flex factor of Expanded, Flexible and Spacer.
const int defaultFlex = 1;

/// StackFit.
const List<String> stackFitOptions = ['loose', 'expand', 'passthrough'];

/// Clip.
const List<String> clipOptions = [
  'none',
  'hardEdge',
  'antiAlias',
  'antiAliasWithSaveLayer',
];

/// ImageRepeat.
const List<String> imageRepeatOptions = [
  'noRepeat',
  'repeat',
  'repeatX',
  'repeatY',
];

/// TextDecoration constants.
const List<String> textDecorationOptions = [
  'underline',
  'lineThrough',
  'overline',
];

/// TextInputType constants.
const List<String> keyboardTypeOptions = [
  'text',
  'number',
  'emailAddress',
  'phone',
  'multiline',
  'url',
  'visiblePassword',
  'name',
  'streetAddress',
  'datetime',
];

/// Curves constants.
const List<String> curveOptions = [
  'linear',
  'ease',
  'easeIn',
  'easeOut',
  'easeInOut',
  'fastOutSlowIn',
  'decelerate',
  'bounceOut',
  'elasticOut',
];

/// HitTestBehavior.
const List<String> hitTestBehaviorOptions = [
  'deferToChild',
  'opaque',
  'translucent',
];

/// NavigationDestinationLabelBehavior.
const List<String> labelBehaviorOptions = [
  'alwaysShow',
  'alwaysHide',
  'onlyShowSelected',
];

/// ListTileControlAffinity.
const List<String> controlAffinityOptions = ['platform', 'leading', 'trailing'];

/// DecorationPosition.
const List<String> decorationPositionOptions = ['background', 'foreground'];

/// BoxShape.
const List<String> boxShapeOptions = ['rectangle', 'circle'];

/// OverlayVisibilityMode.
const List<String> overlayVisibilityOptions = [
  'never',
  'editing',
  'always',
  'notEditing',
];

/// Border styles of a TextField, mapped to the InputBorder they create.
const List<String> inputBorderOptions = ['outline', 'underline'];
const Map<String, String> inputBorderLiterals = {
  'outline': 'OutlineInputBorder()',
  'underline': 'UnderlineInputBorder()',
};

/// SystemUiOverlayStyle constants: light icons for a dark background and the
/// other way round.
const List<String> statusBarStyleOptions = ['light', 'dark'];

/// Where an Image gets its picture: a web address, a bundled asset or a file.
const List<String> imageSourceOptions = ['network', 'asset', 'file'];

/// Seed color of a Theme node before the user picks one: the Material 3
/// baseline purple.
const int defaultSeedColor = 0xFF6750A4;

/// Brightness of a Theme node.
const List<String> brightnessOptions = ['light', 'dark'];
