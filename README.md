# Flutter UI Builder

A desktop drag and drop builder for Flutter user interfaces. Compose screens
from a catalog of Material and Cupertino widgets, edit their properties, and
get the Dart code. The tree of widgets is the single source of truth: the
canvas, the preview and the code are all read from it.

## Features

- Widget palette, outline and properties panel, with placement rules.
- Screens with navigation (push or named routes), reusable components with
  parameters, project theme (light and dark) and widget themes.
- Live code with syntax highlighting; edit the code or import existing code
  back into the designer.
- Device frames, status bar and safe area, prototype mode with live controls.
- Save and open projects as JSON files; export the code of the whole project.
- English and Italian.

## Run

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d macos
```

Windows and Linux are set up but not yet verified.

## Tests

```
flutter analyze
flutter test
```

## License

Copyright (c) 2026 Mario Refetto.

Flutter UI Builder is free software, licensed under the GNU Affero General
Public License, version 3 (see [LICENSE](LICENSE)). You may use, study, modify
and share it, but anything you distribute or offer as a service that is based
on it must be released under the same license, with its source code.

The code the application generates for your own projects is yours.
