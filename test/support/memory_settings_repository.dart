import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_ui_builder/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_ui_builder/features/settings/domain/usecases/settings_usecases.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/settings_cubit.dart';

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

/// A settings cubit over [MemorySettingsRepository], for widgets that read the
/// settings in a test.
SettingsCubit memorySettingsCubit() {
  final repository = MemorySettingsRepository();
  return SettingsCubit(
    loadSettings: LoadSettings(repository),
    saveSettings: SaveSettings(repository),
  );
}
