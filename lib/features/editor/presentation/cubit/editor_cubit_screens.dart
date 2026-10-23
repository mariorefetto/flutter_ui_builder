part of 'editor_cubit.dart';

/// Operations on the screens of the project.
extension EditorScreens on EditorCubit {
  /// Renames the open screen. Widgets that open it follow its new name.
  void renameDocument(String name) => renameScreen(state.document.name, name);

  // A new name changes no widget, so the selection stays.
  void renameScreen(String from, String to) => _useCases
      .renameScreen(ScreenParams(document: state.document, name: from, to: to))
      .fold(
        _reportFailure,
        (document) => _commit(document, selectedId: state.selectedId),
      );

  /// Adds a screen, a blank one or made from a [template], and opens it.
  void addScreen(
    String name, {
    ScreenTemplate template = ScreenTemplate.blank,
  }) => _changeScreens(
    _useCases.addScreen(
      ScreenParams(document: state.document, name: name, template: template),
    ),
  );

  void deleteScreen(String name) => _changeScreens(
    _useCases.deleteScreen(ScreenParams(document: state.document, name: name)),
  );

  void duplicateScreen(String name) => _changeScreens(
    _useCases.duplicateScreen(
      ScreenParams(document: state.document, name: name),
    ),
  );

  /// Makes [name] the screen the app starts on.
  void makeHomeScreen(String name) => _changeScreens(
    _useCases.makeHomeScreen(
      ScreenParams(document: state.document, name: name),
    ),
  );

  /// Opens another screen for editing. It is not an undo step: undo undoes
  /// edits, not where the user was looking.
  void openScreen(String name) {
    if (name == state.document.name) return;
    _useCases
        .openScreen(ScreenParams(document: state.document, name: name))
        .fold(_reportFailure, _showDocument);
  }

  // A change to the screens clears the selection: it may belong to a screen
  // that is no longer open.
  void _changeScreens(Either<Failure, EditorDocument> result) =>
      result.fold(_reportFailure, (d) => _commit(d, selectedId: null));

  /// Adds a component, a widget to be used in several places, and opens it.
  void addComponent(String name) => _changeScreens(
    _useCases.addComponent(
      ComponentParams(document: state.document, name: name),
    ),
  );

  /// Makes a component of the selected widget and what is inside it. The
  /// widget becomes a use of the component, and stays selected.
  void extractSelectedAsComponent(String name) => _withSelection(
    (id) => _useCases
        .extractComponent(
          ComponentParams(document: state.document, name: name, nodeId: id),
        )
        .fold(_reportFailure, (document) => _commit(document, selectedId: id)),
  );

  /// Replaces the selected use of a component with a copy of its content.
  void detachSelectedComponent() => _withSelection(
    (id) => _useCases
        .detachComponent(ComponentParams(document: state.document, nodeId: id))
        .fold(_reportFailure, (document) => _commit(document, selectedId: id)),
  );

  /// Adds the files at [paths] as pictures of the project.
  void addAssets(List<String> paths) {
    if (paths.isEmpty) return;
    _useCases
        .addAssets(MediaParams(document: state.document, paths: paths))
        .fold(
          _reportFailure,
          (document) => _commit(document, selectedId: state.selectedId),
        );
  }

  void removeAsset(String name) => _useCases
      .removeAsset(MediaParams(document: state.document, name: name))
      .fold(
        _reportFailure,
        (document) => _commit(document, selectedId: state.selectedId),
      );
}
