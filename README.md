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

## Third-party software

The application uses packages published on pub.dev, under the MIT, BSD-3 and
Apache-2.0 licenses, and `dbus` (through `file_picker_linux`, on Linux only)
under the MPL-2.0. The icons come from the `lucide_icons_flutter` package
(MIT). Each keeps its own license.

## Tests

```
flutter analyze
flutter test
```

## License

Copyright (c) 2026 Mario Refetto.

Flutter UI Builder is source-available under the PolyForm Noncommercial
License 1.0.0 (see [LICENSE](LICENSE)). You may use, study, modify and share
it for any noncommercial purpose, including personal use, research, education
and hobby projects. You may not sell it, or use it for commercial purposes,
without the permission of the author.

This is not an open source license in the sense of the Open Source Initiative,
because it limits commercial use.

The code the application generates for your own projects is yours.
