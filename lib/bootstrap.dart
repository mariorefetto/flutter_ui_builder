import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/app.dart';
import 'package:flutter_ui_builder/core/di/injection.dart';
import 'package:flutter_ui_builder/features/settings/presentation/cubit/settings_cubit.dart';

/// Single startup sequence of the app.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  // The saved language and theme apply from the first frame.
  await sl<SettingsCubit>().load();
  runApp(const App());
}
