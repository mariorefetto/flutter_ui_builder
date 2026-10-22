import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';

abstract interface class SourceFileRepository {
  /// Asks the user for a Dart file and returns its text. Returns null when the
  /// dialog is dismissed.
  Future<Either<Failure, String?>> pickAndRead();
}
