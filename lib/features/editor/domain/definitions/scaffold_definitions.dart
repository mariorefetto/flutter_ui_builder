import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/declarative_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_builders.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/prop_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/slot_layout.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_child.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

const String _scaffoldType = 'Scaffold';
const String _navigationBarType = 'NavigationBar';
const String _cupertinoLibrary = 'package:flutter/cupertino.dart';
const String _servicesLibrary = 'package:flutter/services.dart';

/// Where each part of a Scaffold goes. Any other child is the body.
const SlotLayout scaffoldLayout = SlotLayout(
  slots: {
    'AppBar': 'appBar',
    'BottomAppBar': 'bottomNavigationBar',
    'NavigationBar': 'bottomNavigationBar',
    'FloatingActionButton': 'floatingActionButton',
  },
  bodyArgument: 'body',
);

/// Where the parts of a CupertinoPageScaffold go.
const SlotLayout cupertinoScaffoldLayout = SlotLayout(
  slots: {'CupertinoNavigationBar': 'navigationBar'},
  bodyArgument: 'child',
);

final List<PropSchema> _scaffoldProps = [
  colorProp('backgroundColor'),
  boolProp('resizeToAvoidBottomInset', defaultValue: true),
  boolProp('extendBody', defaultValue: false),
  boolProp('extendBodyBehindAppBar', defaultValue: false),
];

/// A widget that places its children in the slots of [layout].
WidgetDefinition _slotted({
  required String type,
  required String constructor,
  required SlotLayout layout,
  required List<PropSchema> props,
  Set<String> imports = const {},
  bool bodyRequired = false,
}) => WidgetDefinition(
  type: type,
  label: type,
  category: screenCategory,
  childPolicy: ChildPolicy.multiple,
  childFilter: layout.accepts,
  constructor: constructor,
  slotLayout: layout,
  // A screen: it can only be the root of a document.
  allowedParents: const {},
  props: props,
  imports: imports,
  generateCode: (values, children) =>
      '$constructor(${dartArguments(_slotArguments(layout, props, values, children, bodyRequired))})',
);

Map<String, String?> _slotArguments(
  SlotLayout layout,
  List<PropSchema> props,
  NodeProps values,
  List<GeneratedChild> children,
  bool bodyRequired,
) {
  final arguments = propArguments(props, values, const {});
  for (final child in children) {
    final slot = layout.slots[child.type];
    arguments[slot ?? layout.bodyArgument] ??= child.code;
  }
  if (bodyRequired) arguments[layout.bodyArgument] ??= 'SizedBox.shrink()';
  return arguments;
}

final WidgetDefinition scaffoldDefinition = _slotted(
  type: _scaffoldType,
  constructor: 'Scaffold',
  layout: scaffoldLayout,
  props: _scaffoldProps,
);

final WidgetDefinition cupertinoPageScaffoldDefinition = _slotted(
  type: 'CupertinoPageScaffold',
  constructor: 'CupertinoPageScaffold',
  layout: cupertinoScaffoldLayout,
  props: [
    colorProp('backgroundColor'),
    boolProp('resizeToAvoidBottomInset', defaultValue: true),
  ],
  imports: const {_cupertinoLibrary},
  bodyRequired: true,
);

const Set<String> _scaffoldOnly = {_scaffoldType};

const String _iconButton = 'IconButton(icon: Icon(Icons.{}), onPressed: () {})';

final WidgetDefinition appBarDefinition = simpleDefinition(
  type: 'AppBar',
  category: screenCategory,
  allowedParents: _scaffoldOnly,
  props: [
    textProp('title', defaultValue: 'Title'),
    boolProp('centerTitle'),
    colorProp('backgroundColor'),
    colorProp('foregroundColor'),
    numberProp('elevation'),
    numberProp('toolbarHeight'),
    boolProp('automaticallyImplyLeading', defaultValue: true),
    iconProp('leadingIcon', argument: 'leading', template: _iconButton),
    iconProp('actionIcon', argument: 'actions', template: '[$_iconButton]'),
    choiceProp(
      'statusBarStyle',
      statusBarStyleOptions,
      argument: 'systemOverlayStyle',
      enumType: 'SystemUiOverlayStyle',
    ),
  ],
  importsWhen: (props) => props.choice('statusBarStyle') == null
      ? const {}
      : const {_servicesLibrary},
);

final WidgetDefinition bottomAppBarDefinition = simpleDefinition(
  type: 'BottomAppBar',
  category: screenCategory,
  childPolicy: ChildPolicy.single,
  allowedParents: _scaffoldOnly,
  props: [
    colorProp('color'),
    numberProp('elevation'),
    numberProp('height'),
    insetsProp('padding'),
  ],
);

final WidgetDefinition floatingActionButtonDefinition = simpleDefinition(
  type: 'FloatingActionButton',
  category: screenCategory,
  allowedParents: _scaffoldOnly,
  fixedArguments: const {'onPressed': '() {}'},
  props: [
    iconProp('icon', defaultValue: 'add', argument: 'child'),
    colorProp('backgroundColor'),
    colorProp('foregroundColor'),
    boolProp('mini', defaultValue: false),
    numberProp('elevation'),
    stringProp('tooltip'),
  ],
);

final WidgetDefinition navigationBarDefinition = simpleDefinition(
  type: _navigationBarType,
  category: screenCategory,
  childPolicy: ChildPolicy.multiple,
  allowedParents: _scaffoldOnly,
  childArgument: 'destinations',
  acceptedChildren: const {'NavigationDestination'},
  props: [
    numberProp('selectedIndex', defaultValue: 0, integer: true),
    colorProp('backgroundColor'),
    numberProp('elevation'),
    numberProp('height'),
    choiceProp(
      'labelBehavior',
      labelBehaviorOptions,
      defaultValue: 'alwaysShow',
      enumType: 'NavigationDestinationLabelBehavior',
    ),
  ],
);

final WidgetDefinition navigationDestinationDefinition = simpleDefinition(
  type: 'NavigationDestination',
  category: screenCategory,
  allowedParents: const {_navigationBarType},
  props: [
    iconProp('icon', defaultValue: 'home'),
    stringProp('label', defaultValue: 'Label', alwaysEmit: true),
    iconProp('selectedIcon'),
    stringProp('tooltip'),
  ],
);

final WidgetDefinition cupertinoNavigationBarDefinition = simpleDefinition(
  type: 'CupertinoNavigationBar',
  category: screenCategory,
  allowedParents: const {'CupertinoPageScaffold'},
  imports: const {_cupertinoLibrary},
  props: [
    textProp('title', defaultValue: 'Title', argument: 'middle'),
    colorProp('backgroundColor'),
    stringProp('previousPageTitle'),
  ],
);
