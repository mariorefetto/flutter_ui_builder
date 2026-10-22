import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/file_dialog_data_source.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/local_file_data_source.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/source_file_repository.dart';
import 'package:talker/talker.dart';

const String _extension = 'dart';

class SourceFileRepositoryImpl implements SourceFileRepository {
  const SourceFileRepositoryImpl(this._dialogs, this._files, this._talker);

  final FileDialogDataSource _dialogs;
  final LocalFileDataSource _files;
  final Talker _talker;

  @override
  Future<Either<Failure, String?>> pickAndRead() async {
    try {
      final path = await _dialogs.pickFile(_extension);
      if (path == null) return const Right(null);
      final text = await _files.readIfExists(path);
      if (text == null) throw const FileAccessException('File not found');
      return Right(text);
    } on AppException catch (e) {
      _talker.warning('Reading a source file failed: ${e.message}');
      return Left(e.toFailure());
    } on Exception catch (e) {
      // The platform file dialogs can fail in ways they do not document.
      _talker.warning('Source file dialog failed: $e');
      return const Left(StorageFailure(StorageFailureReason.access));
    }
  }
}
