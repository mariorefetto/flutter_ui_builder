import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

abstract interface class FileDialogDataSource {
  Future<String?> pickDirectory();

  /// Lets the user pick one file with [extension], returning its path.
  Future<String?> pickFile(String extension);

  /// Lets the user choose where to save [bytes]; the plugin writes the file.
  /// Returns the chosen path, or null when dismissed.
  Future<String?> saveFile(String fileName, Uint8List bytes);
}

class FileDialogDataSourceImpl implements FileDialogDataSource {
  const FileDialogDataSourceImpl();

  @override
  Future<String?> pickDirectory() => FilePicker.getDirectoryPath();

  @override
  Future<String?> pickFile(String extension) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: [extension],
    );
    return file?.path;
  }

  @override
  Future<String?> saveFile(String fileName, Uint8List bytes) async {
    final uri = await FilePicker.saveFile(fileName: fileName, bytes: bytes);
    return uri?.toFilePath();
  }
}
