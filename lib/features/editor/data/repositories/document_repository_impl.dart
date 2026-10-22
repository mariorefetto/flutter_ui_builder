import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/file_dialog_data_source.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/local_file_data_source.dart';
import 'package:flutter_ui_builder/features/editor/data/services/document_json_codec.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/opened_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/document_repository.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/identifier_names.dart';
import 'package:talker/talker.dart';

const String _extension = 'json';

class DocumentRepositoryImpl implements DocumentRepository {
  const DocumentRepositoryImpl(
    this._files,
    this._dialogs,
    this._codec,
    this._talker,
  );

  final LocalFileDataSource _files;
  final FileDialogDataSource _dialogs;
  final DocumentJsonCodec _codec;
  final Talker _talker;

  @override
  Future<Either<Failure, Unit>> save(String path, EditorDocument document) =>
      _guard(() async {
        await _files.write(path, _codec.encode(document));
        return unit;
      }, 'save');

  @override
  Future<Either<Failure, String?>> saveAs(EditorDocument document) =>
      _guard(() {
        final bytes = utf8.encode(_codec.encode(document));
        final fileName = '${snakeCase(document.name)}.$_extension';
        return _dialogs.saveFile(fileName, bytes);
      }, 'save as');

  @override
  Future<Either<Failure, OpenedDocument?>> open() => _guard(() async {
    final path = await _dialogs.pickFile(_extension);
    if (path == null) return null;
    final text = await _files.readIfExists(path);
    if (text == null) throw const FileAccessException('File not found');
    return OpenedDocument(document: _codec.decode(text), path: path);
  }, 'open');

  Future<Either<Failure, T>> _guard<T>(
    Future<T> Function() action,
    String operation,
  ) async {
    try {
      return Right(await action());
    } on AppException catch (e) {
      _talker.warning('Document $operation failed: ${e.message}');
      return Left(e.toFailure());
    } on Exception catch (e) {
      // The platform file dialogs can fail in ways they do not document.
      _talker.warning('Document $operation failed: $e');
      return const Left(StorageFailure(StorageFailureReason.access));
    }
  }
}
