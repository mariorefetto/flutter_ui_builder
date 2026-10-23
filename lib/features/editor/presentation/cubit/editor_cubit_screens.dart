part of 'editor_cubit.dart';

/// Operations on the screens of the project.
extension EditorScreens on EditorCubit {
  /// Renames the open screen. Widgets that open it follow its new name.
  /// Replaces the project with what an import made: its first screen and, for
  /// a file with several widget classes, the other screens and components.
  void replaceWithImport(ImportResult imported) => _useCases
      .buildImportedProject(imported)
      .fold(_reportFailure, replaceDocument);

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

  /// Sets a value of the theme of the app; null puts the default back.
  void setThemeValue(
    String part,
    String name,
    Object? value, {
    bool dark = false,
  }) => _useCases
      .setThemeValue(
        ThemeParams(
          document: state.document,
          part: part,
          name: name,
          value: value,
          dark: dark,
        ),
      )
      .fold(
        _reportFailure,
        (document) => _commit(document, selectedId: state.selectedId),
      );

  /// Puts a part of the theme back to the defaults.
  void resetThemePart(String part, {bool dark = false}) => _useCases
      .resetThemePart(
        ThemeParams(document: state.document, part: part, dark: dark),
      )
      .fold(
        _reportFailure,
        (document) => _commit(document, selectedId: state.selectedId),
      );

  /// Binds a property of the open component to the parameter [param], making
  /// the parameter when it is new. Each use of the component can then give it
  /// a value of its own.
  void bindProp(String nodeId, String prop, String param) => _useCases
      .bindProp(
        ComponentParams(
          document: state.document,
          nodeId: nodeId,
          prop: prop,
          name: param,
        ),
      )
      .fold(
        _reportFailure,
        (document) => _commit(document, selectedId: state.selectedId),
      );

  /// Frees a property from its parameter, keeping the parameter's default as
  /// the property's own value.
  void unbindProp(String nodeId, String prop) => _useCases
      .unbindProp(
        ComponentParams(document: state.document, nodeId: nodeId, prop: prop),
      )
      .fold(
        _reportFailure,
        (document) => _commit(document, selectedId: state.selectedId),
      );
}
