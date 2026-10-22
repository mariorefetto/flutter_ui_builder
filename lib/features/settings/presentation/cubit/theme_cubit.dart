import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/theme_state.dart';

/// Which theme the editor uses: the system one, light or dark. The choice
/// lasts for the session; it is not saved to disk.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void setMode(ThemeMode mode) => emit(state.copyWith(mode: mode));
}
