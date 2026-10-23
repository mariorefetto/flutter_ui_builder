import 'dart:io';

import 'package:path/path.dart' as p;

const String _folder = '.flutter_ui_builder';
const String _file = 'settings.json';

/// Where the settings file lives: a folder of its own in the user's home (on
/// macOS, the app's container). Falls back to the current folder when the
/// system names no home.
String settingsFilePath() {
  final env = Platform.environment;
  final home = env['HOME'] ?? env['USERPROFILE'] ?? env['APPDATA'] ?? '.';
  return p.join(home, _folder, _file);
}
