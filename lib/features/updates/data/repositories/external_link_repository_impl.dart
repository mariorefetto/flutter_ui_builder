import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/updates/data/datasources/external_link_data_source.dart';
import 'package:flutter_ui_builder/features/updates/domain/repositories/external_link_repository.dart';
import 'package:talker/talker.dart';

class ExternalLinkRepositoryImpl implements ExternalLinkRepository {
  const ExternalLinkRepositoryImpl(this._source, this._talker);

  final ExternalLinkDataSource _source;
  final Talker _talker;

  @override
  Future<Either<Failure, Unit>> open(String url) async {
    final uri = Uri.tryParse(url);
    // Only a web page is opened, never a file or another kind of link.
    if (uri == null || !(uri.isScheme('https') || uri.isScheme('http'))) {
      return const Left(LaunchFailure('Not a web address'));
    }
    try {
      await _source.open(uri);
      return const Right(unit);
    } on AppException catch (e) {
      _talker.warning('Opening $url failed: ${e.message}');
      return Left(e.toFailure());
    }
  }
}
