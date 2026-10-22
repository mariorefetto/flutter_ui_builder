import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/status_bar_appearance.dart';

void main() {
  EditorDocument screen({
    Map<String, Object?> appBar = const {},
    Map<String, Object?> scaffold = const {},
  }) => EditorDocument(
    name: 'test',
    root: WidgetNode(
      id: 'node_0',
      type: 'Scaffold',
      props: scaffold,
      children: [WidgetNode(id: 'node_1', type: 'AppBar', props: appBar)],
    ),
  );

  StatusBarAppearance auto(EditorDocument document, {bool dark = false}) =>
      statusBarAppearance(document, StatusBarMode.auto, themeIsDark: dark);

  test('the fixed modes ignore the project', () {
    final document = screen(appBar: {'backgroundColor': 0xFF000000});

    expect(
      statusBarAppearance(document, StatusBarMode.dark, themeIsDark: true),
      isA<StatusBarAppearance>()
          .having((a) => a.lightIcons, 'lightIcons', isFalse)
          .having((a) => a.visible, 'visible', isTrue),
    );
    expect(
      statusBarAppearance(
        document,
        StatusBarMode.light,
        themeIsDark: false,
      ).lightIcons,
      isTrue,
    );
    expect(
      statusBarAppearance(
        document,
        StatusBarMode.hidden,
        themeIsDark: false,
      ).visible,
      isFalse,
    );
  });

  test('auto follows the AppBar status bar style first', () {
    expect(
      auto(screen(appBar: {'statusBarStyle': 'light'})).lightIcons,
      isTrue,
    );
    expect(
      auto(
        screen(
          appBar: {'statusBarStyle': 'dark', 'backgroundColor': 0xFF000000},
        ),
      ).lightIcons,
      isFalse,
    );
  });

  test(
    'auto reads the darkness of the AppBar, then the Scaffold, background',
    () {
      expect(
        auto(screen(appBar: {'backgroundColor': 0xFF101820})).lightIcons,
        isTrue,
      );
      expect(
        auto(screen(appBar: {'backgroundColor': 0xFFFFFFFF})).lightIcons,
        isFalse,
      );
      expect(
        auto(screen(scaffold: {'backgroundColor': 0xFF000000})).lightIcons,
        isTrue,
      );
    },
  );

  test('auto falls back to the theme when the project sets nothing', () {
    expect(auto(screen()).lightIcons, isFalse);
    expect(auto(screen(), dark: true).lightIcons, isTrue);
  });
}
