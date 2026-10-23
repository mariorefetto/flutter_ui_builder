import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/features/settings/presentation/widgets/settings_dialog.dart';

/// Opens the settings.
Future<void> openSettings(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const SettingsDialog());
