import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';

abstract interface class ExternalLinkRepository {
  /// Opens [url] in the browser of the system.
  Future<Either<Failure, Unit>> open(String url);
}
