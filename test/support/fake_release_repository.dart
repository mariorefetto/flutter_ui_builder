import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_release.dart';
import 'package:flutter_ui_builder/features/updates/domain/repositories/external_link_repository.dart';
import 'package:flutter_ui_builder/features/updates/domain/repositories/release_repository.dart';

/// Answers with what it is given, so no test asks GitHub anything.
class FakeReleaseRepository implements ReleaseRepository {
  FakeReleaseRepository(this.result);

  Either<Failure, AppRelease?> result;

  @override
  Future<Either<Failure, AppRelease?>> latest() async => result;
}

/// Remembers what it was asked to open, and opens nothing.
class FakeExternalLinks implements ExternalLinkRepository {
  final List<String> opened = [];

  @override
  Future<Either<Failure, Unit>> open(String url) async {
    opened.add(url);
    return const Right(unit);
  }
}
