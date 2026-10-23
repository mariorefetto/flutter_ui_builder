import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_definition.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/child_policy.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_child.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';

/// Lookup table from node type to its definition, plus the code generation
/// walk over a tree.
class WidgetRegistry {
  WidgetRegistry(Iterable<WidgetDefinition> definitions) {
    definitions.forEach(register);
  }

  final Map<String, WidgetDefinition> _definitions = {};

  void register(WidgetDefinition definition) {
    if (_definitions.containsKey(definition.type)) {
      throw StateError('Widget type already registered: ${definition.type}');
    }
    _definitions[definition.type] = definition;
  }

  bool contains(String type) => _definitions.containsKey(type);

  WidgetDefinition definitionFor(String type) {
    final definition = _definitions[type];
    if (definition == null) {
      throw StateError('Unknown widget type: $type');
    }
    return definition;
  }

  /// The definition built by the constructor [name], as written in code:
  /// `Column` or `Image.network`. Null when there is none.
  WidgetDefinition? byConstructor(String name) {
    for (final definition in _definitions.values) {
      if (definition.constructorName == name ||
          definition.aliases.contains(name)) {
        return definition;
      }
    }
    return null;
  }

  /// All definitions, for building the palette.
  Iterable<WidgetDefinition> get all => _definitions.values;

  /// Why a [childType] node cannot join the children of a [parentType] node
  /// that already has [siblingTypes], or null when it can. [ancestorTypes],
  /// from the root down to the parent, enables the checks on ancestors.
  TreeFailureReason? admit(
    String parentType,
    String childType,
    List<String> siblingTypes, {
    List<String>? ancestorTypes,
  }) {
    final parent = definitionFor(parentType);
    final child = definitionFor(childType);
    if (parent.childPolicy == ChildPolicy.none) {
      return TreeFailureReason.childNotAllowed;
    }
    final allowed = child.allowedParents;
    if ((allowed != null && !allowed.contains(parentType)) ||
        child.forbiddenParents.contains(parentType)) {
      return TreeFailureReason.parentNotAllowed;
    }
    if (parent.childPolicy == ChildPolicy.single && siblingTypes.isNotEmpty) {
      return TreeFailureReason.parentFull;
    }
    final filter = parent.childFilter;
    if (filter != null && !filter(childType, siblingTypes)) {
      return TreeFailureReason.slotTaken;
    }
    return _missingAncestor(child, ancestorTypes);
  }

  /// Like [admit], but a child that only fails because its parent forbids
  /// it counts as accepted when it can be wrapped, see [autoWrapperFor].
  TreeFailureReason? admitOrWrap(
    String parentType,
    String childType,
    List<String> siblingTypes,
  ) {
    final refusal = admit(parentType, childType, siblingTypes);
    if (refusal != TreeFailureReason.parentNotAllowed) return refusal;
    return autoWrapperFor(parentType, childType, siblingTypes) == null
        ? refusal
        : null;
  }

  /// The wrapper type that lets [childType] go in [parentType], or null when
  /// there is none or the wrapper itself would not fit there.
  String? autoWrapperFor(
    String parentType,
    String childType,
    List<String> siblingTypes,
  ) {
    final child = definitionFor(childType);
    if (!child.forbiddenParents.contains(parentType)) return null;
    final wrapper = child.autoWrap[parentType];
    if (wrapper == null || !contains(wrapper)) return null;
    final fitsParent = admit(parentType, wrapper, siblingTypes) == null;
    final holdsChild = admit(wrapper, childType, const []) == null;
    return fitsParent && holdsChild ? wrapper : null;
  }

  /// The first rule the tree under [root] breaks, or null when it follows all
  /// of them: known types, a root that needs no parent, and every node
  /// accepted by its parent and ancestors.
  ///
  /// A [detached] tree is a component, which is built apart and used inside
  /// other widgets: what it needs from its ancestors is whatever it is placed
  /// in, so those rules are not checked here.
  TreeFailureReason? violation(WidgetNode root, {bool detached = false}) {
    if (!contains(root.type)) return TreeFailureReason.unknownType;
    final allowed = definitionFor(root.type).allowedParents;
    if (allowed != null && allowed.isNotEmpty) {
      return TreeFailureReason.rootNotAllowed;
    }
    if (detached) return _violationBelow(root, null);
    // The root has no ancestors, so a widget that needs one cannot be it.
    return _missingAncestor(definitionFor(root.type), const []) ??
        _violationBelow(root, [root.type]);
  }

  TreeFailureReason? _violationBelow(WidgetNode node, List<String>? ancestors) {
    for (final child in node.children) {
      if (!contains(child.type)) return TreeFailureReason.unknownType;
      final siblings = [
        for (final other in node.children)
          if (!identical(other, child)) other.type,
      ];
      final refusal =
          admit(node.type, child.type, siblings, ancestorTypes: ancestors) ??
          _violationBelow(
            child,
            ancestors == null ? null : [...ancestors, child.type],
          );
      if (refusal != null) return refusal;
    }
    return null;
  }

  TreeFailureReason? _missingAncestor(
    WidgetDefinition child,
    List<String>? ancestors,
  ) {
    final required = child.requiredAncestors;
    if (required == null || ancestors == null) return null;
    return ancestors.any(required.contains)
        ? null
        : TreeFailureReason.ancestorRequired;
  }

  /// Libraries needed by the widgets in the subtree of [node].
  Set<String> importsFor(WidgetNode node) {
    final definition = definitionFor(node.type);
    return {
      ...definition.imports,
      ...?definition.importsWhen?.call(definition.resolve(node)),
      for (final child in node.children) ...importsFor(child),
    };
  }

  /// Generates the Dart source for [node] and its subtree.
  String generateCode(WidgetNode node) {
    final definition = definitionFor(node.type);
    final children = [
      for (final child in node.children)
        GeneratedChild(type: child.type, code: generateCode(child)),
    ];
    return definition.generateCode(definition.resolve(node), children);
  }
}
