import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_settings.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:flutter_ui_builder/features/settings/domain/entities/app_settings.dart';

void main() {
  test('the designer opens as the settings say', () {
    final state = workspaceFromSettings(
      const AppSettings(
        device: 'tablet',
        showFrame: false,
        statusBar: 'hidden',
        showSafeArea: true,
        codePlacement: 'bottom',
      ),
    );

    expect(state.device, PreviewDevice.tablet);
    expect(state.showFrame, isFalse);
    expect(state.statusBar, StatusBarMode.hidden);
    expect(state.showSafeArea, isTrue);
    expect(state.codePlacement, CodePlacement.bottom);
  });

  test('names that mean nothing fall back to the defaults', () {
    final state = workspaceFromSettings(
      const AppSettings(device: 'watch', statusBar: '?', codePlacement: '?'),
    );

    expect(state.device, PreviewDevice.phone);
    expect(state.statusBar, StatusBarMode.auto);
    expect(state.codePlacement, CodePlacement.tab);
  });
}
