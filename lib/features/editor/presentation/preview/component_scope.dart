import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/component_param.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';

/// Draws a tree of widgets, for a component to be shown where it is used.
typedef ComponentBuilder =
    Widget Function(BuildContext context, WidgetNode root);

/// The components of the project, so that a widget that uses one can draw it.
/// [depth] counts the components being drawn inside one another, which stops
/// a component that contains itself from being drawn forever.
class ComponentScope extends InheritedWidget {
  const ComponentScope({
    required this.roots,
    required this.build,
    required super.child,
    this.params = const {},
    this.depth = 0,
    super.key,
  });

  /// The root of each component, by name.
  final Map<String, WidgetNode> roots;

  /// What each component takes, by name.
  final Map<String, List<ComponentParam>> params;
  final ComponentBuilder build;
  final int depth;

  static ComponentScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ComponentScope>();

  @override
  bool updateShouldNotify(ComponentScope oldWidget) =>
      roots != oldWidget.roots ||
      params != oldWidget.params ||
      depth != oldWidget.depth;
}
