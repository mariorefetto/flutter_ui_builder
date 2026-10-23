# Flutter UI Builder

[![Dev](https://github.com/mariorefetto/flutter_ui_builder/actions/workflows/dev.yml/badge.svg)](https://github.com/mariorefetto/flutter_ui_builder/actions/workflows/dev.yml)
[![Release](https://img.shields.io/github/v/release/mariorefetto/flutter_ui_builder?include_prereleases)](https://github.com/mariorefetto/flutter_ui_builder/releases)
[![License](https://img.shields.io/badge/license-PolyForm%20Noncommercial-blue)](LICENSE)

A desktop drag and drop builder for Flutter user interfaces. Compose screens
from a catalog of Material and Cupertino widgets, edit their properties, and
get the Dart code. You can also import existing code and see it rendered.

The tree of widgets is the single source of truth. The canvas, the preview and
the generated code only read it or ask it to change, so what you see is always
what you get in the code.

## Download

Get the latest build for macOS, Windows or Linux from the
[releases page](https://github.com/mariorefetto/flutter_ui_builder/releases).
Check the download against `SHA256SUMS.txt`.

The builds are not signed:

- **macOS:** unzip, then right click the app and choose Open the first time.
- **Windows:** SmartScreen may ask for confirmation.
- **Linux:** extract the archive and run `flutter_ui_builder`. The file dialogs
  need `zenity` or `kdialog`.

Only macOS is tested by hand. Windows and Linux build in CI but have not been
checked yet.

## Features

**Designing**
- A palette of about 90 Material and Cupertino widgets in categories, with a
  search, a filter down to what fits the selection, and a list or grid view.
- An outline of the widget tree, drag and drop on the canvas and in the
  outline, copy, paste, duplicate, wrap and unwrap, and multi-selection.
- Placement rules, with automatic wrapping where a widget needs a parent, and a
  Problems panel for what cannot be written as valid code.
- A properties panel with a tooltip for each property, color and icon pickers,
  and a guide for each widget.
- Guidelines that draw the box of every widget, and the margin, padding and
  size of the selected one.
- Device frames with status bar and safe area, and zoom.

**Building an app**
- Several screens that open each other, by pushing the screen or by route name,
  with a generated file listing the routes.
- Reusable components with parameters, extracted from a selection or built from
  scratch.
- A project theme with a light and a dark variant, and themes for the widgets.
- A media library, with images copied next to the code on export.
- Sample data for lists and grids, and a prototype mode where switches, sliders
  and fields respond.
- Screen templates to start from.

**Code**
- The code is generated live, with syntax highlighting, beside the designer, in
  a tab or below it.
- Edit the code and apply it back to the designer, or import a file, including
  one with several widget classes, which become screens and components.
- Export the whole project as Dart files.
- Projects are saved and opened as JSON files.

**Application**
- English and Italian, following the system language.
- Light and dark theme for the editor, a settings panel, a shortcuts reference,
  a welcome tour and an FAQ.

## Build from source

You need the [Flutter SDK](https://docs.flutter.dev/get-started/install) with
desktop support enabled for your platform. The project requires Dart 3.8 or
newer, and CI builds with Flutter 3.47.7.

```
git clone https://github.com/mariorefetto/flutter_ui_builder.git
cd flutter_ui_builder
flutter pub get
flutter run -d macos   # or windows, linux
```

The generated files (`*.freezed.dart`, `*.g.dart`, the translations) are in the
repository. After changing a model or a translation, regenerate them:

```
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Tests and checks

```
dart format .
flutter analyze
flutter test
```

The same checks run on every push and pull request, together with a debug
build for each platform.

## Architecture

The code is organised by feature, in three layers that depend in one
direction: presentation depends on domain, and data depends on domain.

```
lib/
  core/              shared code: theme, dependency injection, errors, widgets
  features/
    editor/
      domain/        pure Dart: entities, widget definitions, services, use cases
      data/          JSON models, repositories, file access, the code parser
      presentation/  cubits and the widgets of the editor
    settings/        application settings and their persistence
  l10n/              translations (English is the template)
```

- The domain layer has no Flutter and no JSON. Widgets are described by
  declarative definitions, so adding one to the palette is adding a definition.
- State is held in Cubits (`flutter_bloc`), errors travel as `Either` (`dartz`),
  models are immutable (`freezed`), and dependencies are registered with
  `get_it`.
- Code is parsed with the Dart `analyzer` and formatted with `dart_style`.

## Releases

Pushing a tag such as `v0.0.2` runs the release workflow. It checks that the
tag matches the version in `pubspec.yaml`, runs the analysis and the tests,
builds the three desktop versions and publishes them in a GitHub release.

## License

Copyright (c) 2026 Mario Refetto.

Flutter UI Builder is source-available under the
[PolyForm Noncommercial License 1.0.0](LICENSE). You may use, study, modify and
share it for any noncommercial purpose, including personal use, research,
education and hobby projects. You may not sell it, or use it for commercial
purposes, without the permission of the author. This is not an open source
license in the sense of the Open Source Initiative, because it limits
commercial use.

The code the application generates for your own projects is yours.

### Third-party software

The application uses packages published on pub.dev, under the MIT, BSD-3 and
Apache-2.0 licenses, and `dbus` (through `file_picker_linux`, on Linux only)
under the MPL-2.0. The icons come from the `lucide_icons_flutter` package
(MIT). Each keeps its own license.
