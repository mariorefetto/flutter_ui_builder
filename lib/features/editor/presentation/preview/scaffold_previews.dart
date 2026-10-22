import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/scaffold_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_builder.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_helpers.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';

/// A NavigationBar needs at least two destinations.
const int _minDestinations = 2;

/// Previews of Scaffold and of the widgets that fill its slots.
final Map<String, PreviewBuilder> scaffoldPreviews = {
  'Scaffold': _scaffold,
  'AppBar': (context, props, children) => AppBar(
    title: textOf(props, 'title'),
    centerTitle: props.boolean('centerTitle'),
    backgroundColor: colorOf(props, 'backgroundColor'),
    foregroundColor: colorOf(props, 'foregroundColor'),
    elevation: props.number('elevation'),
    toolbarHeight: props.number('toolbarHeight'),
    automaticallyImplyLeading:
        props.boolean('automaticallyImplyLeading') ?? true,
    leading: iconButtonOf(props, 'leadingIcon'),
    actions: [?iconButtonOf(props, 'actionIcon')],
  ),
  'BottomAppBar': (context, props, children) => BottomAppBar(
    color: colorOf(props, 'color'),
    elevation: props.number('elevation'),
    height: props.number('height'),
    padding: insetsOf(props, 'padding'),
    child: firstChild(children),
  ),
  'FloatingActionButton': (context, props, children) => inert(
    FloatingActionButton(
      heroTag: null,
      onPressed: () {},
      backgroundColor: colorOf(props, 'backgroundColor'),
      foregroundColor: colorOf(props, 'foregroundColor'),
      mini: props.boolean('mini') ?? false,
      elevation: props.number('elevation'),
      tooltip: props.string('tooltip'),
      child: Icon(iconOf(props, 'icon')),
    ),
  ),
  'NavigationBar': _navigationBar,
  'NavigationDestination': (context, props, children) => NavigationDestination(
    icon: Icon(iconOf(props, 'icon')),
    selectedIcon: iconWidget(props, 'selectedIcon'),
    label: props.requiredString('label'),
    tooltip: props.string('tooltip'),
  ),
};

Widget _navigationBar(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) {
  if (children.length < _minDestinations) {
    return const SizedBox(height: kBottomNavigationBarHeight);
  }
  final index = props.requiredNumber('selectedIndex').round();
  return NavigationBar(
    destinations: children.widgets,
    selectedIndex: index.clamp(0, children.length - 1),
    backgroundColor: colorOf(props, 'backgroundColor'),
    elevation: props.number('elevation'),
    height: props.number('height'),
    labelBehavior: enumOf(
      NavigationDestinationLabelBehavior.values,
      props,
      'labelBehavior',
    ),
  );
}

Widget _scaffold(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) {
  Widget? slot(String argument) => children
      .where((c) => scaffoldLayout.slots[c.type] == argument)
      .firstOrNull
      ?.widget;
  final appBar = slot('appBar');
  final body = children
      .where((c) => !scaffoldLayout.slots.containsKey(c.type))
      .firstOrNull;
  // Drawn at the screen size inside its own messenger, so the editor's snack
  // bars do not appear inside the previewed screen.
  final screen = PreviewScreenScope.sizeOf(context);
  final insets = PreviewScreenScope.insetsOf(context);
  return SizedBox(
    width: screen.width,
    height: screen.height,
    child: ClipRect(
      // The system margins reach the screen through MediaQuery, so an AppBar
      // sits below the status bar and a SafeArea keeps clear of the notch.
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(size: screen, padding: insets, viewPadding: insets),
        child: ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: colorOf(props, 'backgroundColor'),
            resizeToAvoidBottomInset:
                props.boolean('resizeToAvoidBottomInset') ?? true,
            extendBody: props.boolean('extendBody') ?? false,
            extendBodyBehindAppBar:
                props.boolean('extendBodyBehindAppBar') ?? false,
            appBar: appBar == null
                ? null
                : PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: appBar,
                  ),
            body: body?.widget,
            bottomNavigationBar: slot('bottomNavigationBar'),
            floatingActionButton: slot('floatingActionButton'),
          ),
        ),
      ),
    ),
  );
}
