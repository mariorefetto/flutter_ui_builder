import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ui_builder/core/di/injection.dart';
import 'package:flutter_ui_builder/core/router/app_router.dart';
import 'package:flutter_ui_builder/core/theme/app_theme.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The cubit lives for the whole app, so it is provided, not created here.
    return BlocProvider.value(
      value: sl<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) => _app(
          context.read<SettingsCubit>().themeMode,
          // No saved language follows the system's, and a system language the
          // app does not have falls back to English, the first one listed.
          settings.languageCode == null ? null : Locale(settings.languageCode!),
        ),
      ),
    );
  }

  Widget _app(ThemeMode mode, Locale? locale) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: mode,
      locale: locale,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      routerConfig: _router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
