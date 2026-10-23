import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_ui_builder/features/settings/domain/repositories/settings_repository.dart';

/// Settings kept in memory, so a test never reads or writes the settings
/// file of the person running it.
class MemorySettingsRepository implements SettingsRepository {
  AppSettings _settings = const AppSettings();

  @override
  Future<AppSettings> load() async => _settings;

  @override
  Future<Either<Failure, Unit>> save(AppSettings settings) async {
    _settings = settings;
    return const Right(unit);
  }
}
