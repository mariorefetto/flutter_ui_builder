import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:path/path.dart' as p;

abstract interface class LocalFileDataSource {
  /// Returns the text of [path], or null when the file does not exist.
  Future<String?> readIfExists(String path);

  /// Writes [content] to [path], creating missing directories.
  Future<void> write(String path, String content);

  /// Returns the bytes of [path], or null when the file does not exist.
  Future<Uint8List?> readBytesIfExists(String path);

  /// Writes [bytes] to [path], creating missing directories.
  Future<void> writeBytes(String path, Uint8List bytes);
}

class LocalFileDataSourceImpl implements LocalFileDataSource {
  const LocalFileDataSourceImpl();

  @override
  Future<String?> readIfExists(String path) async {
    try {
      final file = File(path);
      return await file.exists() ? await file.readAsString() : null;
    } on FileSystemException catch (e) {
      throw FileAccessException(e.message);
    }
  }

  @override
  Future<void> write(String path, String content) async {
    try {
      await Directory(p.dirname(path)).create(recursive: true);
      await File(path).writeAsString(content);
    } on FileSystemException catch (e) {
      throw FileAccessException(e.message);
    }
  }

  @override
  Future<Uint8List?> readBytesIfExists(String path) async {
    try {
      final file = File(path);
      return await file.exists() ? await file.readAsBytes() : null;
    } on FileSystemException catch (e) {
      throw FileAccessException(e.message);
    }
  }

  @override
  Future<void> writeBytes(String path, Uint8List bytes) async {
    try {
      await Directory(p.dirname(path)).create(recursive: true);
      await File(path).writeAsBytes(bytes);
    } on FileSystemException catch (e) {
      throw FileAccessException(e.message);
    }
  }
}
