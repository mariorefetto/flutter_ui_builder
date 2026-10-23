import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/media_asset.dart';
import 'package:path/path.dart' as p;

const String _folder = 'assets';

/// Adds and removes the pictures of a project.
class MediaEditor {
  const MediaEditor();

  /// The project with the files at [paths] as pictures. Each is called
  /// `assets/<file name>`, with a number added when the name is taken.
  /// A file that is already a picture, by its path, is not added twice.
  EditorDocument add(EditorDocument document, List<String> paths) {
    final assets = [...document.assets];
    for (final path in paths) {
      if (assets.any((a) => a.sourcePath == path)) continue;
      assets.add(MediaAsset(name: _uniqueName(assets, path), sourcePath: path));
    }
    return document.copyWith(assets: assets);
  }

  /// The project without the picture called [name]. Widgets that refer to it
  /// keep the name, which the code still writes.
  EditorDocument remove(EditorDocument document, String name) =>
      document.copyWith(
        assets: [
          for (final asset in document.assets)
            if (asset.name != name) asset,
        ],
      );

  String _uniqueName(List<MediaAsset> assets, String path) {
    final stem = p.basenameWithoutExtension(path);
    final extension = p.extension(path);
    var name = '$_folder/$stem$extension';
    for (var n = 2; assets.any((a) => a.name == name); n++) {
      name = '$_folder/${stem}_$n$extension';
    }
    return name;
  }
}

/// The lines to put under `flutter:` in `pubspec.yaml` so the pictures of the
/// project can be loaded, or an empty text when there are none.
String pubspecAssets(EditorDocument document) {
  if (document.assets.isEmpty) return '';
  final names = {for (final asset in document.assets) asset.name}.toList()
    ..sort();
  return [
    'flutter:',
    '  assets:',
    for (final name in names) '    - $name',
  ].join('\n');
}
