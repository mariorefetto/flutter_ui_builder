import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/datasources/local_file_data_source.dart';
import 'package:flutter_ui_builder/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';
import 'package:mocktail/mocktail.dart';

class _MockFiles extends Mock implements LocalFileDataSource {}

void main() {
  late _MockFiles files;
  late SettingsRepositoryImpl repository;

  setUp(() {
    files = _MockFiles();
    repository = SettingsRepositoryImpl(files, 'settings.json');
  });

  test('a missing file gives the defaults', () async {
    when(() => files.readIfExists(any())).thenAnswer((_) async => null);

    expect(await repository.load(), const AppSettings());
  });

  test(
    'a file that is not JSON, or not an object, gives the defaults',
    () async {
      when(() => files.readIfExists(any())).thenAnswer((_) async => 'oops');
      expect(await repository.load(), const AppSettings());

      when(() => files.readIfExists(any())).thenAnswer((_) async => '[1]');
      expect(await repository.load(), const AppSettings());
    },
  );

  test('a file that cannot be read gives the defaults', () async {
    when(
      () => files.readIfExists(any()),
    ).thenThrow(const FileAccessException('denied'));

    expect(await repository.load(), const AppSettings());
  });

  test(
    'a file with only some fields keeps the rest at their defaults',
    () async {
      when(
        () => files.readIfExists(any()),
      ).thenAnswer((_) async => '{"languageCode":"it","theme":"dark"}');

      final settings = await repository.load();

      expect(settings.languageCode, 'it');
      expect(settings.theme, ThemeChoice.dark);
      expect(settings.device, 'phone');
    },
  );

  test('an unknown theme name is the system theme', () async {
    when(
      () => files.readIfExists(any()),
    ).thenAnswer((_) async => '{"theme":"neon"}');

    expect((await repository.load()).theme, ThemeChoice.system);
  });

  test('settings written can be read back', () async {
    String? written;
    when(() => files.write(any(), any())).thenAnswer((invocation) async {
      written = invocation.positionalArguments[1] as String;
    });
    const settings = AppSettings(
      theme: ThemeChoice.light,
      languageCode: 'it',
      device: 'tablet',
      showFrame: false,
      statusBar: 'dark',
      showSafeArea: true,
      codePlacement: 'right',
    );

    final saved = await repository.save(settings);
    when(() => files.readIfExists(any())).thenAnswer((_) async => written);

    expect(saved, const Right<Failure, Unit>(unit));
    expect(await repository.load(), settings);
  });

  test('a write that fails is reported', () async {
    when(
      () => files.write(any(), any()),
    ).thenThrow(const FileAccessException('full'));

    final result = await repository.save(const AppSettings());

    expect(result.isLeft(), isTrue);
  });
}
