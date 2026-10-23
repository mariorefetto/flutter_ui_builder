import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/component_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/new_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_screen.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/identifier_names.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';

const String _copySuffix = 'copy';

/// Adds, opens, renames, removes and reorders the screens and components of a
/// project. Every operation returns a new document; the screens that point at
/// one another, and the widgets that use a component, keep pointing at the
/// right one as names change.
///
/// Screens and components share one list and one set of names, because both
/// become classes in files of their own.
class ScreenEditor {
  const ScreenEditor();

  /// The names of all screens, in project order.
  List<String> namesOf(EditorDocument document) => [
    for (final screen in _all(document)) screen.name,
  ];

  /// Everything in the project, screens and components, in project order.
  List<ProjectScreen> entriesOf(EditorDocument document) => _all(document);

  /// The names of the screens only, in project order.
  List<String> screensOf(EditorDocument document) => [
    for (final entry in _all(document))
      if (!entry.component) entry.name,
  ];

  /// The names of the components only, in project order.
  List<String> componentsOf(EditorDocument document) => [
    for (final entry in _all(document))
      if (entry.component) entry.name,
  ];

  /// The root of the screen or component called [name], open or not.
  WidgetNode? rootOf(EditorDocument document, String name) =>
      _all(document).where((s) => s.name == name).firstOrNull?.root;

  /// Whether the widgets of the component or screen called [from] use the
  /// component [target], directly or through other components. Used to refuse
  /// a component that would contain itself.
  bool usesComponent(EditorDocument document, String from, String target) {
    final seen = <String>{};
    bool visit(String name) {
      if (!seen.add(name)) return false;
      final root = rootOf(document, name);
      if (root == null) return false;
      final used = root.componentTargets();
      return used.contains(target) || used.any(visit);
    }

    return visit(from);
  }

  /// Whether [a] and [b] hold the same screens in the same order, whichever
  /// of them is open. Opening another screen changes nothing in the project.
  bool sameContent(EditorDocument a, EditorDocument b) {
    final first = _all(a);
    final second = _all(b);
    if (first.length != second.length) return false;
    for (var i = 0; i < first.length; i++) {
      if (first[i] != second[i]) return false;
    }
    return true;
  }

  /// A new screen with a Scaffold, opened for editing.
  Either<Failure, EditorDocument> add(EditorDocument document, String name) =>
      _validName(document, name).map((clean) {
        final all = _all(document);
        return _build(document, [
          ...all,
          ProjectScreen(name: clean, root: createEmptyDocument().root),
        ], all.length);
      });

  /// A new component, a Container with a Text, opened for editing.
  Either<Failure, EditorDocument> addComponent(
    EditorDocument document,
    String name,
  ) => _validName(document, name).map((clean) {
    final all = _all(document);
    return _build(document, [
      ...all,
      ProjectScreen(
        name: clean,
        component: true,
        root: const WidgetNode(
          id: 'node_0',
          type: 'Container',
          children: [WidgetNode(id: 'node_1', type: 'Text')],
        ),
      ),
    ], all.length);
  });

  /// Makes a component of the widget [nodeId] and what is inside it, and puts
  /// a use of the component where the widget was. The component is not
  /// opened. [canBeRoot] says whether a widget type can stand on its own.
  Either<Failure, EditorDocument> extract(
    EditorDocument document,
    String nodeId,
    String name, {
    required bool Function(String type) canBeRoot,
  }) {
    final node = document.root.find(nodeId);
    if (node == null) return _unknown();
    if (!canBeRoot(node.type)) {
      return const Left(
        DocumentFailure(DocumentFailureReason.invalidStructure),
      );
    }
    return _validName(document, name).map((clean) {
      final instance = WidgetNode(
        id: node.id,
        type: componentType,
        props: {componentProp: clean},
      );
      final replaced = _replaceNode(document.root, nodeId, instance);
      final all = _all(document);
      final active = document.activeIndex.clamp(0, all.length - 1);
      return _build(document, [
        for (var i = 0; i < all.length; i++)
          i == active
              ? ProjectScreen(
                  name: all[i].name,
                  root: replaced,
                  component: all[i].component,
                )
              : all[i],
        ProjectScreen(name: clean, component: true, root: node.renumbered(0)),
      ], active);
    });
  }

  /// Replaces the use of a component [nodeId] with a copy of what the
  /// component holds, so it can be changed on its own.
  Either<Failure, EditorDocument> detach(
    EditorDocument document,
    String nodeId,
  ) {
    final node = document.root.find(nodeId);
    final name = node?.props[componentProp];
    if (node == null || node.type != componentType || name is! String) {
      return _unknown();
    }
    final source = rootOf(document, name);
    if (source == null) return _unknown();
    final root = _inline(document.root, name, source, only: nodeId);
    return Right(document.copyWith(root: root));
  }

  /// Opens the screen called [name].
  Either<Failure, EditorDocument> open(EditorDocument document, String name) {
    final all = _all(document);
    final index = all.indexWhere((s) => s.name == name);
    return index < 0 ? _unknown() : Right(_build(document, all, index));
  }

  Either<Failure, EditorDocument> rename(
    EditorDocument document,
    String from,
    String to,
  ) {
    final all = _all(document);
    final index = all.indexWhere((s) => s.name == from);
    if (index < 0) return _unknown();
    return _validName(document, to, except: from).map((clean) {
      final renamed = [
        for (final screen in all)
          ProjectScreen(
            name: screen.name == from ? clean : screen.name,
            root: _retarget(screen.root, {from: clean}),
            component: screen.component,
          ),
      ];
      return _build(document, renamed, document.activeIndex);
    });
  }

  /// Removes the screen called [name]. Widgets that opened it stop doing so.
  Either<Failure, EditorDocument> delete(EditorDocument document, String name) {
    final all = _all(document);
    final index = all.indexWhere((s) => s.name == name);
    if (index < 0) return _unknown();
    if (all.length == 1) {
      return const Left(DocumentFailure(DocumentFailureReason.lastScreen));
    }
    // A component that goes leaves its content behind where it was used.
    final gone = all[index];
    final remaining = [
      for (final screen in all)
        if (screen.name != name)
          ProjectScreen(
            name: screen.name,
            component: screen.component,
            root: _retarget(
              gone.component
                  ? _inline(screen.root, name, gone.root)
                  : screen.root,
              {name: null},
            ),
          ),
    ];
    final active = document.activeIndex;
    // The open screen stays open unless it is the one removed.
    final next = index < active
        ? active - 1
        : index == active
        ? (active >= remaining.length ? remaining.length - 1 : active)
        : active;
    return Right(_build(document, remaining, next));
  }

  /// A copy of the screen called [name], opened for editing.
  Either<Failure, EditorDocument> duplicate(
    EditorDocument document,
    String name,
  ) {
    final all = _all(document);
    final index = all.indexWhere((s) => s.name == name);
    if (index < 0) return _unknown();
    final taken = namesOf(document).map(pascalCase).toSet();
    var copy = '$name $_copySuffix';
    for (var n = 2; taken.contains(pascalCase(copy)); n++) {
      copy = '$name $_copySuffix $n';
    }
    return Right(
      _build(document, [
        ...all,
        ProjectScreen(name: copy, root: all[index].root),
      ], all.length),
    );
  }

  /// Makes the screen called [name] the first, the one the app starts on.
  Either<Failure, EditorDocument> makeHome(
    EditorDocument document,
    String name,
  ) {
    final all = _all(document);
    final index = all.indexWhere((s) => s.name == name);
    if (index < 0) return _unknown();
    final open = all[document.activeIndex].name;
    final moved = [all[index], ...all.where((s) => s.name != name)];
    return Right(
      _build(document, moved, moved.indexWhere((s) => s.name == open)),
    );
  }

  // The open screen sits among the others at its place.
  List<ProjectScreen> _all(EditorDocument document) {
    final open = ProjectScreen(
      name: document.name,
      root: document.root,
      component: document.component,
    );
    final at = document.activeIndex.clamp(0, document.screens.length);
    return [...document.screens.take(at), open, ...document.screens.skip(at)];
  }

  // The project with [all] as its screens and components and the one at
  // [active] open. Everything else about [base], such as its pictures, stays.
  EditorDocument _build(
    EditorDocument base,
    List<ProjectScreen> all,
    int active,
  ) {
    final open = all[active];
    return base.copyWith(
      name: open.name,
      root: open.root,
      component: open.component,
      screens: [
        for (var i = 0; i < all.length; i++)
          if (i != active) all[i],
      ],
      activeIndex: active,
    );
  }

  Either<Failure, String> _validName(
    EditorDocument document,
    String name, {
    String? except,
  }) {
    final clean = name.trim();
    if (clean.isEmpty) {
      return const Left(DocumentFailure(DocumentFailureReason.emptyName));
    }
    // Two names that write the same class would clash in the code.
    final taken = [
      for (final other in namesOf(document))
        if (other != except) pascalCase(other),
    ];
    return taken.contains(pascalCase(clean))
        ? const Left(DocumentFailure(DocumentFailureReason.duplicateScreenName))
        : Right(clean);
  }

  Either<Failure, EditorDocument> _unknown() =>
      const Left(DocumentFailure(DocumentFailureReason.unknownScreen));

  // Points the widgets that open a screen at its new name, or at nothing.
  WidgetNode _retarget(WidgetNode node, Map<String, String?> changes) {
    var props = node.props;
    for (final key in const [navigateToProp, componentProp]) {
      final target = props[key];
      if (target is String && changes.containsKey(target)) {
        props = {...props};
        final replacement = changes[target];
        if (replacement == null) {
          props.remove(key);
        } else {
          props[key] = replacement;
        }
      }
    }
    return node.copyWith(
      props: props,
      children: [for (final c in node.children) _retarget(c, changes)],
    );
  }

  WidgetNode _replaceNode(WidgetNode node, String id, WidgetNode other) =>
      node.id == id
      ? other
      : node.copyWith(
          children: [for (final c in node.children) _replaceNode(c, id, other)],
        );

  // Every use of the component [name] below [root] (or just [only]) becomes a
  // copy of [source], with ids that do not clash with the rest of the tree.
  WidgetNode _inline(
    WidgetNode root,
    String name,
    WidgetNode source, {
    String? only,
  }) {
    var result = root;
    while (true) {
      final use = _firstUse(result, name, only);
      if (use == null) return result;
      final copy = source.renumbered(result.highestSuffix() + 1);
      result = _replaceNode(result, use.id, copy);
      if (only != null) return result;
    }
  }

  WidgetNode? _firstUse(WidgetNode node, String name, String? only) {
    if (node.type == componentType &&
        node.props[componentProp] == name &&
        (only == null || node.id == only)) {
      return node;
    }
    for (final child in node.children) {
      final found = _firstUse(child, name, only);
      if (found != null) return found;
    }
    return null;
  }
}
