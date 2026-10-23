import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_ui_builder/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_ui_builder/features/settings/domain/usecases/settings_usecases.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements SettingsRepository {}

void main() {
  late _MockRepository repository;

  setUpAll(() => registerFallbackValue(const AppSettings()));

  setUp(() {
    repository = _MockRepository();
    when(
      () => repository.save(any()),
    ).thenAnswer((_) async => const Right(unit));
  });

  SettingsCubit build() => SettingsCubit(
    loadSettings: LoadSettings(repository),
    saveSettings: SaveSettings(repository),
  );

  test('starts with the defaults', () {
    expect(build().state, const AppSettings());
    expect(build().themeMode, ThemeMode.system);
  });

  test('load shows what was saved', () async {
    when(
      () => repository.load(),
    ).thenAnswer((_) async => const AppSettings(languageCode: 'it'));
    final cubit = build();

    await cubit.load();

    expect(cubit.state.languageCode, 'it');
  });

  test('a change is applied and saved', () async {
    final cubit = build();

    await cubit.update((s) => s.copyWith(device: 'tablet'));

    expect(cubit.state.device, 'tablet');
    verify(() => repository.save(cubit.state)).called(1);
  });

  test('a change that changes nothing is not saved', () async {
    final cubit = build();

    await cubit.update((s) => s);

    verifyNever(() => repository.save(any()));
  });

  test('the theme is set and read as a ThemeMode', () async {
    final cubit = build();

    await cubit.setThemeMode(ThemeMode.dark);

    expect(cubit.state.theme, ThemeChoice.dark);
    expect(cubit.themeMode, ThemeMode.dark);
  });
}
