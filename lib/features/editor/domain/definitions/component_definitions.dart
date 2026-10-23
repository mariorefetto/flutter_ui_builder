import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_categories.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/component_binding.dart';

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
    if (name == null || name.isEmpty) return 'SizedBox.shrink()';
    final arguments = props.withPrefix(argumentPrefix);
    return 'const ${componentClassName(name)}(${_arguments(arguments)})';
  },
);

// The values a use gives the parameters, as named arguments. A colour is
// stored as a whole number and a number as a fractional one, which is how the
// two are told apart here.
String _arguments(Map<String, Object?> values) => dartArguments({
  for (final entry in values.entries)
    entry.key: switch (entry.value) {
      final String text => dartString(text),
      final int color => dartColor(color),
      final double number => dartDouble(number),
      _ => null,
    },
});
