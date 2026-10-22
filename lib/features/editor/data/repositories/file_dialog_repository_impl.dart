import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/file_dialog_data_source.dart';
import 'package:flutter_ui_builder/features/editor/domain/repositories/file_dialog_repository.dart';
import 'package:talker/talker.dart';

class FileDialogRepositoryImpl implements FileDialogRepository {
  const FileDialogRepositoryImpl(this._dialogs, this._talker);

  final FileDialogDataSource _dialogs;
  final Talker _talker;

  @override
  Future<Either<Failure, String?>> pickDirectory() async {
    try {
      return Right(await _dialogs.pickDirectory());
    } on Exception catch (e) {
      // The platform plugin can fail in ways it does not document.
      _talker.warning('Directory dialog failed: $e');
      return const Left(StorageFailure(StorageFailureReason.access));
    }
  }
}
