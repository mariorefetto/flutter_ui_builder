import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/new_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_screen.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/identifier_names.dart';

const String _copySuffix = 'copy';

/// Adds, opens, renames, removes and reorders the screens of a project. Every
/// operation returns a new document; the screens that point at one another
/// keep pointing at the right screen as names change.
class ScreenEditor {
  const ScreenEditor();

  /// The names of all screens, in project order.
  List<String> namesOf(EditorDocument document) => [
    for (final screen in _all(document)) screen.name,
  ];

  /// The root of the screen called [name], whether it is open or not.
  WidgetNode? rootOf(EditorDocument document, String name) =>
      _all(document).where((s) => s.name == name).firstOrNull?.root;

  /// A new screen with a Scaffold, opened for editing.
  Either<Failure, EditorDocument> add(EditorDocument document, String name) =>
      _validName(document, name).map((clean) {
        final all = _all(document);
        return _build([
          ...all,
          ProjectScreen(name: clean, root: createEmptyDocument().root),
        ], all.length);
      });

  /// Opens the screen called [name].
  Either<Failure, EditorDocument> open(EditorDocument document, String name) {
    final all = _all(document);
    final index = all.indexWhere((s) => s.name == name);
    return index < 0 ? _unknown() : Right(_build(all, index));
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
          ),
      ];
      return _build(renamed, document.activeIndex);
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
    final remaining = [
      for (final screen in all)
        if (screen.name != name)
          ProjectScreen(
            name: screen.name,
            root: _retarget(screen.root, {name: null}),
          ),
    ];
    final active = document.activeIndex;
    // The open screen stays open unless it is the one removed.
    final next = index < active
        ? active - 1
        : index == active
        ? (active >= remaining.length ? remaining.length - 1 : active)
        : active;
    return Right(_build(remaining, next));
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
      _build([
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
    return Right(_build(moved, moved.indexWhere((s) => s.name == open)));
  }

  // The open screen sits among the others at its place.
  List<ProjectScreen> _all(EditorDocument document) {
    final open = ProjectScreen(name: document.name, root: document.root);
    final at = document.activeIndex.clamp(0, document.screens.length);
    return [...document.screens.take(at), open, ...document.screens.skip(at)];
  }

  EditorDocument _build(List<ProjectScreen> all, int active) {
    final open = all[active];
    return EditorDocument(
      name: open.name,
      root: open.root,
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
    final target = node.props[navigateToProp];
    var props = node.props;
    if (target is String && changes.containsKey(target)) {
      props = {...props};
      final replacement = changes[target];
      if (replacement == null) {
        props.remove(navigateToProp);
      } else {
        props[navigateToProp] = replacement;
      }
    }
    return node.copyWith(
      props: props,
      children: [for (final c in node.children) _retarget(c, changes)],
    );
  }
}
