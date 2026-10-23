import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_ui_builder/features/settings/domain/usecases/settings_usecases.dart';

/// Holds the user's settings and keeps them on disk. A change is applied at
/// once and saved after it; a save that fails does not undo the change, which
/// still holds for the session.
class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit({
    required LoadSettings loadSettings,
    required SaveSettings saveSettings,
    AppSettings initial = const AppSettings(),
  }) : _load = loadSettings,
       _save = saveSettings,
       super(initial);

  final LoadSettings _load;
  final SaveSettings _save;

  /// Reads the saved settings, at startup.
  Future<void> load() async {
    final result = await _load(const NoParams());
    if (isClosed) return;
    result.fold((_) {}, emit);
  }

  /// Replaces the settings with what [change] makes of them.
  Future<void> update(AppSettings Function(AppSettings current) change) async {
    final next = change(state);
    if (next == state) return;
    emit(next);
    await _save(next);
  }

  /// The theme as Flutter names it.
  ThemeMode get themeMode => switch (state.theme) {
    ThemeChoice.system => ThemeMode.system,
    ThemeChoice.light => ThemeMode.light,
    ThemeChoice.dark => ThemeMode.dark,
  };

  Future<void> setThemeMode(ThemeMode mode) => update(
    (s) => s.copyWith(
      theme: switch (mode) {
        ThemeMode.system => ThemeChoice.system,
        ThemeMode.light => ThemeChoice.light,
        ThemeMode.dark => ThemeChoice.dark,
      },
    ),
  );
}
