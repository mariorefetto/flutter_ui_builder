import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/sample_data.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_builder.dart';

/// Decorates the preview of one node, for example to make it selectable.
/// [built] is the node's own preview, already containing its children.
typedef NodeWrapper =
    Widget Function(BuildContext context, WidgetNode node, Widget built);

/// Draws a node tree as real Flutter widgets by combining the domain
/// definitions (defaults, schema) with the preview builders.
class PreviewRegistry {
  PreviewRegistry({
    required WidgetRegistry registry,
    required Map<String, PreviewBuilder> previews,
    Set<String> parentDataTypes = const {},
  }) : _registry = registry,
       _previews = previews,
       _parentDataTypes = parentDataTypes {
    _assertComplete();
  }

  final WidgetRegistry _registry;
  final Map<String, PreviewBuilder> _previews;
  final Set<String> _parentDataTypes;

  /// Builds the preview widget tree for [node]. Every node, children
  /// included, is passed through [wrapper] when given.
  Widget build(BuildContext context, WidgetNode node, {NodeWrapper? wrapper}) {
    final builder = _previews[node.type];
    if (builder == null) {
      throw StateError('No preview registered for widget type: ${node.type}');
    }
    final definition = _registry.definitionFor(node.type);
    final copies = sampleCountOf(node);
    final children = copies == null
        ? [
            for (final child in node.children)
              PreviewChild(
                type: child.type,
                widget: build(context, child, wrapper: wrapper),
              ),
          ]
        : _repeated(context, node.children.first, copies, wrapper);
    final props = definition.resolve(node);
    if (_parentDataTypes.contains(node.type)) {
      return builder(
        context,
        props,
        _insideParentData(context, node, children, wrapper),
      );
    }
    final built = builder(context, props, children);
    return wrapper == null ? built : wrapper(context, node, built);
  }

  // A list or grid that repeats its first widget, as it looks with data. Only
  // the first copy can be picked: the others are the same widget again.
  List<PreviewChild> _repeated(
    BuildContext context,
    WidgetNode template,
    int copies,
    NodeWrapper? wrapper,
  ) => [
    for (var number = 1; number <= copies; number++)
      PreviewChild(
        type: template.type,
        widget: build(
          context,
          withSampleNumber(template, number),
          wrapper: number == 1 ? wrapper : null,
        ),
      ),
  ];

  // The wrapper goes around the content of a widget such as Expanded, because
  // wrapping the widget itself would hide it from its Row, Column or Stack.
  List<PreviewChild> _insideParentData(
    BuildContext context,
    WidgetNode node,
    List<PreviewChild> children,
    NodeWrapper? wrapper,
  ) {
    final child = children.firstOrNull;
    final content =
        child?.widget ??
        const SizedBox.square(dimension: AppConstants.spacingXXL);
    return [
      PreviewChild(
        type: child?.type ?? node.type,
        widget: wrapper == null ? content : wrapper(context, node, content),
      ),
    ];
  }

  // A definition without a preview would only fail when first used.
  void _assertComplete() {
    for (final definition in _registry.all) {
      if (!_previews.containsKey(definition.type)) {
        throw StateError('No preview registered for: ${definition.type}');
      }
    }
  }
}
