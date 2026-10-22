import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/app.dart';
import 'package:flutter_ui_builder/core/di/injection.dart';

/// Single startup sequence of the app.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}
