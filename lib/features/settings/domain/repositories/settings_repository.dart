import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  /// The saved settings. A missing or unreadable file gives the defaults: the
  /// app must start whatever state the file is in.
  Future<AppSettings> load();

  Future<Either<Failure, Unit>> save(AppSettings settings);
}
