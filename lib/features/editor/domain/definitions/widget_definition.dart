import 'package:flutter_ui_builder/features/editor/domain/definitions/slot_layout.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_child.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/component_binding.dart';

/// Produces the Dart source for a node.
/// [children] are the already generated sources of the node's children.
typedef CodeGenerator =
    String Function(NodeProps props, List<GeneratedChild> children);

/// Extra rule on top of the ChildPolicy: whether a child of [childType] may
/// join the children whose types are [siblingTypes].
typedef ChildFilter =
    bool Function(String childType, List<String> siblingTypes);

/// Everything the domain needs to know about one widget type: its editable
/// properties, how many children it accepts and how to write it as Dart code.
///
/// The matching preview lives in the presentation layer.
class WidgetDefinition {
  const WidgetDefinition({
    required this.type,
    required this.label,
    required this.category,
    required this.props,
    required this.childPolicy,
    required this.generateCode,
    this.allowedParents,
    this.forbiddenParents = const {},
    this.requiredAncestors,
    this.autoWrap = const {},
    this.childFilter,
    this.imports = const {},
    this.importsWhen,
    this.requiresChild = false,
    this.constructor,
    this.childArgument,
    this.slotLayout,
    this.aliases = const {},
  });

  /// Registry key, stored in WidgetNode.type.
  final String type;

  /// Name shown in the palette.
  final String label;

  /// Palette group (e.g. "Layout", "Content").
  final String category;

  final List<PropSchema> props;
  final ChildPolicy childPolicy;
  final CodeGenerator generateCode;

  /// Widget types this widget may be placed in. Null means any parent and an
  /// empty set means no parent at all: the widget can only be the root.
  final Set<String>? allowedParents;

  /// Widget types this widget must not be a direct child of.
  final Set<String> forbiddenParents;

  /// For a parent type this widget is forbidden in, the wrapper type that
  /// makes it fit: inserting the widget there inserts the wrapper around it.
  final Map<String, String> autoWrap;

  /// When set, at least one ancestor must be of one of these types, for
  /// example a Scaffold for a widget that needs a Material ancestor.
  final Set<String>? requiredAncestors;

  /// Optional rule that limits which children this widget accepts, used for
  /// widgets with slots such as Scaffold.
  final ChildFilter? childFilter;

  /// Libraries the generated code needs besides flutter/material.dart.
  final Set<String> imports;

  /// Libraries needed only for some property values, such as the services
  /// library for a system overlay style. Called with the resolved props.
  final Set<String> Function(NodeProps props)? importsWhen;

  /// How the widget is constructed in code, when that differs from [type]:
  /// `Image.network` or `GridView.count`.
  final String? constructor;

  /// Other constructors the widget is also built by, which code import reads
  /// as this widget, such as `Image.asset` for an Image.
  final Set<String> aliases;

  /// The constructor argument that takes the children, when it is not the
  /// usual `child` or `children`.
  final String? childArgument;

  /// For a widget with named slots, where each kind of child goes.
  final SlotLayout? slotLayout;

  /// The widget's constructor demands a child. Without one the generated code
  /// uses an empty box, and the problems panel says so.
  final bool requiresChild;

  /// The definition with [props] and [generateCode] replaced, for a widget
  /// that is another one plus something of its own.
  WidgetDefinition copyWith({
    List<PropSchema>? props,
    CodeGenerator? generateCode,
    Set<String>? aliases,
  }) => WidgetDefinition(
    type: type,
    label: label,
    category: category,
    props: props ?? this.props,
    childPolicy: childPolicy,
    generateCode: generateCode ?? this.generateCode,
    allowedParents: allowedParents,
    forbiddenParents: forbiddenParents,
    requiredAncestors: requiredAncestors,
    autoWrap: autoWrap,
    childFilter: childFilter,
    imports: imports,
    importsWhen: importsWhen,
    requiresChild: requiresChild,
    constructor: constructor,
    childArgument: childArgument,
    slotLayout: slotLayout,
    aliases: aliases ?? this.aliases,
  );

  /// The name the widget is called by in code.
  String get constructorName => constructor ?? type;

  /// Merges the values of [node] over the schema defaults. A stored value of
  /// the wrong type is ignored in favour of the default.
  NodeProps resolve(WidgetNode node) {
    final values = <String, Object?>{};
    for (final prop in props) {
      final stored = node.props[prop.name];
      values[prop.name] = prop.accepts(stored) ? stored : prop.defaultValue;
    }
    // The values a use of a component gives its parameters are not in the
    // schema, which does not know what the component takes.
    for (final entry in node.props.entries) {
      if (entry.key.startsWith(argumentPrefix)) values[entry.key] = entry.value;
    }
    return NodeProps(values);
  }
}
