import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/local_file_data_source.dart';
import 'package:flutter_ui_builder/features/settings/data/models/app_settings_model.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_ui_builder/features/settings/domain/repositories/settings_repository.dart';

const String _indent = '  ';

/// Keeps the settings in one small JSON file.
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._files, this._path);

  final LocalFileDataSource _files;
  final String _path;

  @override
  Future<AppSettings> load() async {
    try {
      final text = await _files.readIfExists(_path);
      if (text == null) return const AppSettings();
      final json = jsonDecode(text);
      if (json is! Map<String, dynamic>) return const AppSettings();
      return AppSettingsModel.fromJson(json).toEntity();
    } on Object {
      // A file that cannot be read or understood must not stop the app.
      return const AppSettings();
    }
  }

  @override
  Future<Either<Failure, Unit>> save(AppSettings settings) async {
    final model = AppSettingsModel.fromEntity(settings);
    try {
      await _files.write(
        _path,
        '${const JsonEncoder.withIndent(_indent).convert(model.toJson())}\n',
      );
      return const Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    }
  }
}
