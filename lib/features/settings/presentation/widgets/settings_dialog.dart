import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/core/widgets/app_select.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

const double _dialogWidth = 520;
const double _labelWidth = 170;

/// Each language is named in itself, so it can be found whatever the current
/// one is.
const Map<String, String> languageNames = {'en': 'English', 'it': 'Italiano'};

/// The user's settings: the language and theme of the app, and how the
/// designer opens. A change applies at once, to what is open as well, and is
/// kept for the next time.
class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.settingsTitle),
      content: SizedBox(
        width: _dialogWidth,
        child: BlocBuilder<SettingsCubit, AppSettings>(
          builder: (context, settings) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Heading(l10n.settingsGeneral),
                _language(context, settings),
                _theme(context, settings),
                _Heading(l10n.settingsDesigner),
                _device(context, settings),
                _status(context, settings),
                _switch(
                  label: l10n.settingsShowFrame,
                  value: settings.showFrame,
                  onChanged: (value) =>
                      _apply(context, (s) => s.copyWith(showFrame: value), (w) {
                        if (w.state.showFrame != value) w.toggleFrame();
                      }),
                ),
                _switch(
                  label: l10n.settingsShowSafeArea,
                  value: settings.showSafeArea,
                  onChanged: (value) => _apply(
                    context,
                    (s) => s.copyWith(showSafeArea: value),
                    (w) {
                      if (w.state.showSafeArea != value) w.toggleSafeArea();
                    },
                  ),
                ),
                _Heading(l10n.settingsEditor),
                _codePlacement(context, settings),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonClose),
        ),
      ],
    );
  }

  // Saves the setting, and applies it to the layout that is open now.
  void _apply(
    BuildContext context,
    AppSettings Function(AppSettings) change,
    void Function(WorkspaceCubit) now,
  ) {
    context.read<SettingsCubit>().update(change);
    now(context.read<WorkspaceCubit>());
  }

  Widget _language(BuildContext context, AppSettings settings) {
    final l10n = context.l10n;
    return _Row(
      label: l10n.settingsLanguage,
      child: AppSelect<String>(
        value: settings.languageCode ?? '',
        options: [
          AppSelectOption(value: '', label: l10n.settingsLanguageSystem),
          for (final MapEntry(:key, :value) in languageNames.entries)
            AppSelectOption(value: key, label: value),
        ],
        onChanged: (code) => context.read<SettingsCubit>().update(
          (s) => s.copyWith(
            languageCode: code == null || code.isEmpty ? null : code,
          ),
        ),
      ),
    );
  }

  Widget _theme(BuildContext context, AppSettings settings) {
    final l10n = context.l10n;
    return _Row(
      label: l10n.settingsTheme,
      child: AppSelect<ThemeChoice>(
        value: settings.theme,
        options: [
          AppSelectOption(
            value: ThemeChoice.system,
            label: l10n.settingsThemeSystem,
          ),
          AppSelectOption(
            value: ThemeChoice.light,
            label: l10n.settingsThemeLight,
          ),
          AppSelectOption(
            value: ThemeChoice.dark,
            label: l10n.settingsThemeDark,
          ),
        ],
        onChanged: (choice) => context.read<SettingsCubit>().update(
          (s) => s.copyWith(theme: choice ?? ThemeChoice.system),
        ),
      ),
    );
  }

  Widget _device(BuildContext context, AppSettings settings) {
    final l10n = context.l10n;
    return _Row(
      label: l10n.settingsDevice,
      child: AppSelect<String>(
        value: settings.device,
        options: [
          for (final device in PreviewDevice.values)
            AppSelectOption(
              value: device.name,
              label: _deviceLabel(l10n, device),
            ),
        ],
        onChanged: (name) {
          final device = PreviewDevice.values.asNameMap()[name];
          if (device == null) return;
          _apply(
            context,
            (s) => s.copyWith(device: device.name),
            (w) => w.setDevice(device),
          );
        },
      ),
    );
  }

  Widget _status(BuildContext context, AppSettings settings) {
    final l10n = context.l10n;
    return _Row(
      label: l10n.settingsStatusBar,
      child: AppSelect<String>(
        value: settings.statusBar,
        options: [
          for (final mode in StatusBarMode.values)
            AppSelectOption(value: mode.name, label: _statusLabel(l10n, mode)),
        ],
        onChanged: (name) {
          final mode = StatusBarMode.values.asNameMap()[name];
          if (mode == null) return;
          _apply(
            context,
            (s) => s.copyWith(statusBar: mode.name),
            (w) => w.setStatusBar(mode),
          );
        },
      ),
    );
  }

  Widget _codePlacement(BuildContext context, AppSettings settings) {
    final l10n = context.l10n;
    return _Row(
      label: l10n.settingsCodePlacement,
      child: AppSelect<String>(
        value: settings.codePlacement,
        options: [
          AppSelectOption(value: CodePlacement.tab.name, label: l10n.codeAsTab),
          AppSelectOption(
            value: CodePlacement.right.name,
            label: l10n.codeBeside,
          ),
          AppSelectOption(
            value: CodePlacement.bottom.name,
            label: l10n.codeBelow,
          ),
        ],
        onChanged: (name) {
          final placement = CodePlacement.values.asNameMap()[name];
          if (placement == null) return;
          _apply(
            context,
            (s) => s.copyWith(codePlacement: placement.name),
            (w) => w.setCodePlacement(placement),
          );
        },
      ),
    );
  }

  Widget _switch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => _Row(
    label: label,
    child: Align(
      alignment: Alignment.centerLeft,
      child: Switch(value: value, onChanged: onChanged),
    ),
  );

  String _deviceLabel(AppLocalizations l10n, PreviewDevice device) =>
      switch (device) {
        PreviewDevice.phone => l10n.designerDevicePhone,
        PreviewDevice.tablet => l10n.designerDeviceTablet,
        PreviewDevice.desktop => l10n.designerDeviceDesktop,
      };

  String _statusLabel(AppLocalizations l10n, StatusBarMode mode) =>
      switch (mode) {
        StatusBarMode.auto => l10n.statusBarAuto,
        StatusBarMode.light => l10n.statusBarLight,
        StatusBarMode.dark => l10n.statusBarDark,
        StatusBarMode.hidden => l10n.statusBarHidden,
      };
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: AppConstants.spacingMD,
      bottom: AppConstants.spacingSM,
    ),
    child: Text(
      text.toUpperCase(),
      style: context.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: context.colorScheme.onSurfaceVariant,
      ),
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingXS),
    child: Row(
      children: [
        SizedBox(width: _labelWidth, child: Text(label)),
        Expanded(child: child),
      ],
    ),
  );
}
