import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_release.dart';

abstract interface class ReleaseRepository {
  /// The newest published version, or null when nothing is published yet.
  Future<Either<Failure, AppRelease?>> latest();
}
