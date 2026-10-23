import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';

/// Widgets that only work as a direct child of a particular parent: moved into
/// a component they would lose it.
const Set<String> _parentDataTypes = {
  'Expanded',
  'Flexible',
  'Spacer',
  'Positioned',
};

/// Whether a widget of [type] can be the root of a component. It must stand
/// on its own: not a screen or one of its parts, and not a widget that
/// configures its parent.
bool canBeComponentRoot(WidgetRegistry registry, String type) {
  if (!registry.contains(type) || _parentDataTypes.contains(type)) return false;
  final definition = registry.definitionFor(type);
  final bound = definition.allowedParents;
  return definition.category != screenCategory &&
      (bound == null || bound.isEmpty);
}
