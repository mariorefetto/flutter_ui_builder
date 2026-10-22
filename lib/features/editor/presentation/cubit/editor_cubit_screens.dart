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

  /// Adds a screen with a Scaffold and opens it.
  void addScreen(String name) => _changeScreens(
    _useCases.addScreen(ScreenParams(document: state.document, name: name)),
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
}
