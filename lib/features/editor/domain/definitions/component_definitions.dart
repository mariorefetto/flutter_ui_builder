import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';

/// The type of the node that shows a component of the project.
const String componentType = 'Component';

/// A use of a component the user made. It holds nothing of its own: it shows
/// the component named by its property, so changing the component changes
/// every place it is used. In code it is a call to the component's class.
final WidgetDefinition componentDefinition = WidgetDefinition(
  type: componentType,
  label: 'Component',
  category: componentsCategory,
  childPolicy: ChildPolicy.none,
  constructor: 'Component',
  props: const [
    PropSchema(
      name: componentProp,
      type: PropType.string,
      componentPicker: true,
    ),
  ],
  generateCode: (props, children) {
    final name = props.string(componentProp);
    return name == null || name.isEmpty
        ? 'SizedBox.shrink()'
        : 'const ${componentClassName(name)}()';
  },
);
