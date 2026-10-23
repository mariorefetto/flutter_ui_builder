// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) =>
    _AppSettingsModel(
      theme: json['theme'] as String? ?? 'system',
      languageCode: json['languageCode'] as String?,
      device: json['device'] as String? ?? 'phone',
      showFrame: json['showFrame'] as bool? ?? true,
      statusBar: json['statusBar'] as String? ?? 'auto',
      showSafeArea: json['showSafeArea'] as bool? ?? false,
      codePlacement: json['codePlacement'] as String? ?? 'tab',
      paletteGrid: json['paletteGrid'] as bool? ?? false,
      tourSeen: json['tourSeen'] as bool? ?? false,
      checkForUpdates: json['checkForUpdates'] as bool? ?? true,
    );

Map<String, dynamic> _$AppSettingsModelToJson(_AppSettingsModel instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'languageCode': ?instance.languageCode,
      'device': instance.device,
      'showFrame': instance.showFrame,
      'statusBar': instance.statusBar,
      'showSafeArea': instance.showSafeArea,
      'codePlacement': instance.codePlacement,
      'paletteGrid': instance.paletteGrid,
      'tourSeen': instance.tourSeen,
      'checkForUpdates': instance.checkForUpdates,
    };
