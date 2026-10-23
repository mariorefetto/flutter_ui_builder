import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_release.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_version.dart';
import 'package:flutter_ui_builder/features/updates/domain/repositories/external_link_repository.dart';
import 'package:flutter_ui_builder/features/updates/domain/repositories/release_repository.dart';

/// Finds out whether a version newer than [AppVersion] (the one running) has
/// been published. Right(null) means the app is up to date.
class CheckForUpdate implements UseCase<AppRelease?, AppVersion> {
  const CheckForUpdate(this._releases);

  final ReleaseRepository _releases;

  @override
  Future<Either<Failure, AppRelease?>> call(AppVersion params) async {
    final result = await _releases.latest();
    return result.map(
      (release) => release != null && release.version.isNewerThan(params)
          ? release
          : null,
    );
  }
}

/// Opens a page in the browser.
class OpenLink implements UseCase<Unit, String> {
  const OpenLink(this._links);

  final ExternalLinkRepository _links;

  @override
  Future<Either<Failure, Unit>> call(String params) => _links.open(params);
}
