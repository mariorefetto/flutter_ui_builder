import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';

abstract interface class FileDialogRepository {
  /// Asks the user for a directory. Returns null when the dialog is dismissed.
  Future<Either<Failure, String?>> pickDirectory();

  /// Asks the user for pictures. Returns their paths, none when the dialog is
  /// dismissed.
  Future<Either<Failure, List<String>>> pickImages();
}
