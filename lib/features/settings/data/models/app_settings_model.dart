import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings_model.freezed.dart';
part 'app_settings_model.g.dart';

/// JSON representation of AppSettings. Every field has a default, so a file
/// written by an older version, or one that lacks a field, still reads.
@freezed
abstract class AppSettingsModel with _$AppSettingsModel {
  @JsonSerializable(includeIfNull: false)
  const factory AppSettingsModel({
    @Default('system') String theme,
    String? languageCode,
    @Default('phone') String device,
    @Default(true) bool showFrame,
    @Default('auto') String statusBar,
    @Default(false) bool showSafeArea,
    @Default('tab') String codePlacement,
    @Default(false) bool paletteGrid,
    @Default(false) bool tourSeen,
    @Default(true) bool checkForUpdates,
  }) = _AppSettingsModel;

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  factory AppSettingsModel.fromEntity(AppSettings settings) => AppSettingsModel(
    theme: settings.theme.name,
    languageCode: settings.languageCode,
    device: settings.device,
    showFrame: settings.showFrame,
    statusBar: settings.statusBar,
    showSafeArea: settings.showSafeArea,
    codePlacement: settings.codePlacement,
    paletteGrid: settings.paletteGrid,
    tourSeen: settings.tourSeen,
    checkForUpdates: settings.checkForUpdates,
  );

  const AppSettingsModel._();

  AppSettings toEntity() => AppSettings(
    theme: ThemeChoice.values.asNameMap()[theme] ?? ThemeChoice.system,
    languageCode: languageCode,
    device: device,
    showFrame: showFrame,
    statusBar: statusBar,
    showSafeArea: showSafeArea,
    codePlacement: codePlacement,
    paletteGrid: paletteGrid,
    tourSeen: tourSeen,
    checkForUpdates: checkForUpdates,
  );
}
