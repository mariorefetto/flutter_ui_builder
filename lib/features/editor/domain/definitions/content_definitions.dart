import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/declarative_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_builders.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

final List<PropSchema> _textProps = [
  stringProp('text', defaultValue: 'Text'),
  numberProp('fontSize', defaultValue: defaultFontSize),
  colorProp('color'),
  stringProp('fontFamily'),
  choiceProp('fontWeight', fontWeightOptions),
  boolProp('italic', defaultValue: false),
  choiceProp('decoration', textDecorationOptions),
  numberProp('letterSpacing'),
  numberProp('height'),
  choiceProp('textAlign', textAlignOptions),
  numberProp('maxLines', integer: true),
  choiceProp('overflow', textOverflowOptions),
  boolProp('softWrap', defaultValue: true),
];

String _textCode(NodeProps props) {
  final style = dartArguments({
    'fontSize': dartDouble(props.requiredNumber('fontSize')),
    'color': props.color('color').let(dartColor),
    'fontFamily': props.string('fontFamily').let(dartString),
    'fontWeight': props.choice('fontWeight').let((v) => 'FontWeight.$v'),
    'fontStyle': props.boolean('italic') == true ? 'FontStyle.italic' : null,
    'decoration': props.choice('decoration').let((v) => 'TextDecoration.$v'),
    'letterSpacing': props.number('letterSpacing').let(dartDouble),
    'height': props.number('height').let(dartDouble),
  });
  final softWrap = props.boolean('softWrap');
  final arguments = dartArguments({
    'textAlign': props.choice('textAlign').let((v) => 'TextAlign.$v'),
    'maxLines': props.number('maxLines').let((v) => '${v.round()}'),
    'overflow': props.choice('overflow').let((v) => 'TextOverflow.$v'),
    'softWrap': softWrap == false ? 'false' : null,
    'style': 'TextStyle($style)',
  });
  return 'Text(${dartString(props.requiredString('text'))}, $arguments)';
}

final WidgetDefinition textDefinition = WidgetDefinition(
  type: 'Text',
  label: 'Text',
  category: textCategory,
  childPolicy: ChildPolicy.none,
  props: _textProps,
  generateCode: (props, children) => _textCode(props),
);

final List<PropSchema> _imageProps = [
  choiceProp('source', imageSourceOptions, defaultValue: 'network'),
  stringProp('url', defaultValue: '', assetPicker: true),
  numberProp('width'),
  numberProp('height'),
  choiceProp(
    'fit',
    boxFitOptions,
    defaultValue: 'cover',
    enumType: 'BoxFit',
    alwaysEmit: true,
  ),
  choiceProp('alignment', alignmentOptions, enumType: 'Alignment'),
  choiceProp(
    'repeat',
    imageRepeatOptions,
    defaultValue: 'noRepeat',
    enumType: 'ImageRepeat',
  ),
  colorProp('color'),
  stringProp('semanticLabel'),
];

final WidgetDefinition imageDefinition = WidgetDefinition(
  type: 'Image',
  label: 'Image',
  constructor: 'Image.network',
  aliases: const {'Image.asset', 'Image.file'},
  category: imagesCategory,
  childPolicy: ChildPolicy.none,
  props: _imageProps,
  importsWhen: (props) =>
      props.choice('source') == 'file' ? const {'dart:io'} : const {},
  generateCode: (props, children) {
    final others = _imageProps
        .where((p) => p.name != 'url' && p.name != 'source')
        .toList();
    final arguments = dartArguments(propArguments(others, props, const {}));
    final source = props.requiredChoice('source');
    final path = dartString(props.requiredString('url'));
    final first = source == 'file' ? 'File($path)' : path;
    return 'Image.$source($first, $arguments)';
  },
);

final WidgetDefinition iconDefinition = WidgetDefinition(
  type: 'Icon',
  label: 'Icon',
  category: imagesCategory,
  childPolicy: ChildPolicy.none,
  props: [
    iconPickerProp('icon', defaultValue: 'add'),
    numberProp('size', defaultValue: defaultIconSize),
    colorProp('color'),
    stringProp('semanticLabel'),
  ],
  generateCode: (props, children) {
    final arguments = dartArguments({
      'size': dartDouble(props.requiredNumber('size')),
      'color': props.color('color').let(dartColor),
      'semanticLabel': props.string('semanticLabel').let(dartString),
    });
    return 'Icon(Icons.${props.requiredChoice('icon')}, $arguments)';
  },
);
