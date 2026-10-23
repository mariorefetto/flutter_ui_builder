import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/updates/data/datasources/release_data_source.dart';
import 'package:flutter_ui_builder/features/updates/data/models/release_model.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_release.dart';
import 'package:flutter_ui_builder/features/updates/domain/repositories/release_repository.dart';
import 'package:talker/talker.dart';

class ReleaseRepositoryImpl implements ReleaseRepository {
  const ReleaseRepositoryImpl(this._source, this._talker);

  final ReleaseDataSource _source;
  final Talker _talker;

  @override
  Future<Either<Failure, AppRelease?>> latest() async {
    try {
      final decoded = jsonDecode(await _source.fetchReleases());
      if (decoded is! List) {
        throw const NetworkException('The answer is not a list of releases');
      }
      AppRelease? newest;
      for (final item in decoded) {
        if (item is! Map<String, dynamic>) continue;
        final model = ReleaseModel.fromJson(item);
        // A draft is not public, and a tag that is not a version is not ours.
        final release = model.draft ? null : model.toEntity();
        if (release == null) continue;
        if (newest == null || release.version.isNewerThan(newest.version)) {
          newest = release;
        }
      }
      return Right(newest);
    } on AppException catch (e) {
      _talker.warning('Looking for updates failed: ${e.message}');
      return Left(e.toFailure());
    } on FormatException catch (e) {
      _talker.warning('The list of releases is not JSON: ${e.message}');
      return const Left(NetworkFailure('The answer is not JSON'));
    } on TypeError catch (e) {
      _talker.warning('A release has an unexpected shape: $e');
      return const Left(NetworkFailure('A release has an unexpected shape'));
    }
  }
}
