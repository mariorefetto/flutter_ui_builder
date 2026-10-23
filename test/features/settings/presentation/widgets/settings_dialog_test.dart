import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/widgets/app_select.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_ui_builder/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_ui_builder/features/settings/domain/usecases/settings_usecases.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter_ui_builder/features/settings/presentation/widgets/settings_dialog.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements SettingsRepository {}

void main() {
  late _MockRepository repository;
  late SettingsCubit settings;
  late WorkspaceCubit workspace;

  setUpAll(() => registerFallbackValue(const AppSettings()));

  setUp(() {
    repository = _MockRepository();
    when(
      () => repository.save(any()),
    ).thenAnswer((_) async => const Right(unit));
    settings = SettingsCubit(
      loadSettings: LoadSettings(repository),
      saveSettings: SaveSettings(repository),
    );
    workspace = WorkspaceCubit();
  });

  tearDown(() async {
    await settings.close();
    await workspace.close();
  });

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: settings),
            BlocProvider.value(value: workspace),
          ],
          child: const Scaffold(body: SettingsDialog()),
        ),
      ),
    );
  }

  testWidgets('the device chosen is saved and applied to the designer', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.byType(AppSelect<String>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tablet').last);
    await tester.pumpAndSettle();

    expect(settings.state.device, 'tablet');
    expect(workspace.state.device, PreviewDevice.tablet);
    verify(() => repository.save(any())).called(1);
  });

  testWidgets(
    'the language is offered in its own name and can follow the system',
    (tester) async {
      await pump(tester);

      await tester.tap(find.byType(AppSelect<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Italiano'));
      await tester.pumpAndSettle();
      expect(settings.state.languageCode, 'it');

      await tester.tap(find.byType(AppSelect<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Follow the system').last);
      await tester.pumpAndSettle();
      expect(settings.state.languageCode, isNull);
    },
  );

  testWidgets('a switch is saved and applied', (tester) async {
    await pump(tester);

    await tester.tap(_switchOf('Draw the device frame'));
    await tester.pumpAndSettle();

    expect(settings.state.showFrame, isFalse);
    expect(workspace.state.showFrame, isFalse);
  });

  testWidgets('looking for updates at startup can be turned off', (
    tester,
  ) async {
    await pump(tester);
    expect(settings.state.checkForUpdates, isTrue);

    await tester.tap(
      _switchOf('Check for updates at startup (contacts github.com)'),
    );
    await tester.pumpAndSettle();

    expect(settings.state.checkForUpdates, isFalse);
  });
}

/// The switch in the row with [label].
Finder _switchOf(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Row)).first,
  matching: find.byType(Switch),
);
