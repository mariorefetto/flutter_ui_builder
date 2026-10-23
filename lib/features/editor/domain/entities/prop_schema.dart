import 'package:flutter_ui_builder/features/editor/domain/entities/edge_insets_value.dart';

/// Kinds of property the properties panel knows how to edit.
enum PropType { string, number, boolean, color, choice, edgeInsets }

/// Describes one editable property of a widget.
class PropSchema {
  const PropSchema({
    required this.name,
    required this.type,
    this.defaultValue,
    this.options = const <String>[],
    this.label,
    this.argument,
    this.enumType,
    this.template,
    this.group,
    this.integer = false,
    this.alwaysEmit = false,
    this.literals,
    this.category,
    this.iconPicker = false,
    this.screenPicker = false,
    this.componentPicker = false,
    this.assetPicker = false,
  });

  /// Key used in WidgetNode.props.
  final String name;
  final PropType type;

  /// Value used when the node does not define the property. Null means "omit".
  /// For widgets with a declarative code generator it must equal the default
  /// of the Flutter constructor, because equal values are left out of the code.
  final Object? defaultValue;

  /// Allowed values when [type] is PropType.choice.
  final List<String> options;

  /// Optional human readable label for the properties panel.
  final String? label;

  /// Name of the constructor argument, when it differs from [name].
  final String? argument;

  /// Enum written before a choice value in the code: 'TextAlign' gives
  /// TextAlign.center. Without it the choice is written as a string.
  final String? enumType;

  /// Wraps the written value, with '{}' standing for it:
  /// 'Text({})' or 'Duration(milliseconds: {})'. A choice with a template
  /// and no [enumType] is written as a bare identifier: 'Icon(Icons.{})'.
  final String? template;

  /// Name of the constructor argument this property is nested in, such as
  /// 'decoration'. The class is set by the widget definition.
  final String? group;

  /// A number property that holds a whole number.
  final bool integer;

  /// Write the argument even when the value is the default, for required
  /// constructor arguments.
  final bool alwaysEmit;

  /// For a choice, the code written for each option, when it is not simply
  /// `EnumType.option`: 'outline' becomes 'OutlineInputBorder()'.
  final Map<String, String>? literals;

  /// Group shown in the properties panel. When null it is worked out from the
  /// property name and type by propCategoryOf.
  final String? category;

  /// A string that names one of the project's pictures when the widget's
  /// source is an asset, and is typed otherwise.
  final bool assetPicker;

  /// A string naming a component of the project, picked from them.
  final bool componentPicker;

  /// A string naming a screen of the project, edited by picking from the
  /// project's screens.
  final bool screenPicker;

  /// A choice of Material icon names, edited with the icon picker rather
  /// than a drop-down.
  final bool iconPicker;

  /// Whether [value] is a valid stored value for this property.
  bool accepts(Object? value) => switch (type) {
    PropType.string => value is String,
    PropType.number => integer ? value is int : value is num,
    PropType.boolean => value is bool,
    PropType.color => value is int,
    PropType.choice => value is String && options.contains(value),
    PropType.edgeInsets => EdgeInsetsValue.tryParse(value) != null,
  };
}
