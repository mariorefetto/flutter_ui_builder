import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_ui_builder/features/settings/domain/repositories/settings_repository.dart';

class LoadSettings implements UseCase<AppSettings, NoParams> {
  const LoadSettings(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) async =>
      Right(await _repository.load());
}

class SaveSettings implements UseCase<Unit, AppSettings> {
  const SaveSettings(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(AppSettings params) =>
      _repository.save(params);
}
