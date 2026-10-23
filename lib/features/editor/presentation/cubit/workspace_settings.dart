import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';

/// The layout the editor opens with, from the user's settings. A name that no
/// longer means anything, from an older or edited file, is the default.
WorkspaceState workspaceFromSettings(AppSettings settings) => WorkspaceState(
  device:
      PreviewDevice.values.asNameMap()[settings.device] ?? PreviewDevice.phone,
  showFrame: settings.showFrame,
  statusBar:
      StatusBarMode.values.asNameMap()[settings.statusBar] ??
      StatusBarMode.auto,
  showSafeArea: settings.showSafeArea,
  codePlacement:
      CodePlacement.values.asNameMap()[settings.codePlacement] ??
      CodePlacement.tab,
);
