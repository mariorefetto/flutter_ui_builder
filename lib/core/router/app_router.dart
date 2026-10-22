import 'package:flutter_ui_builder/features/editor/presentation/pages/editor_page.dart';
import 'package:go_router/go_router.dart';

const String editorPath = '/';

GoRouter createRouter() => GoRouter(
  routes: [
    GoRoute(path: editorPath, builder: (context, state) => const EditorPage()),
  ],
);
