import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/theme_state.dart';

void main() {
  test('starts by following the system', () {
    expect(ThemeCubit().state.mode, ThemeMode.system);
  });

  blocTest<ThemeCubit, ThemeState>(
    'setMode switches the mode',
    build: ThemeCubit.new,
    act: (cubit) => cubit.setMode(ThemeMode.dark),
    expect: () => [const ThemeState(mode: ThemeMode.dark)],
  );
}
