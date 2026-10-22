import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';

void main() {
  test('starts with the toolbox and the properties open on the designer', () {
    final state = WorkspaceCubit().state;

    expect(state.leftPanel, LeftPanel.toolbox);
    expect(state.propertiesVisible, isTrue);
    expect(state.centerTab, CenterTab.design);
  });

  test('choosing the open left panel again collapses the dock', () {
    final cubit = WorkspaceCubit()..toggleLeftPanel(LeftPanel.toolbox);

    expect(cubit.state.leftPanel, isNull);

    cubit.toggleLeftPanel(LeftPanel.outline);

    expect(cubit.state.leftPanel, LeftPanel.outline);
  });

  test('resizing stays within the allowed width', () {
    final cubit = WorkspaceCubit()
      ..resizeLeft(10000)
      ..resizeRight(-10000);

    expect(cubit.state.leftWidth, maxPanelWidth);
    expect(cubit.state.rightWidth, minPanelWidth);
  });

  test('zoom moves one step at a time and stops at both ends', () {
    final cubit = WorkspaceCubit();

    expect(cubit.state.zoom, 1);
    cubit.zoomIn();
    expect(cubit.state.zoom, 1.25);
    cubit.zoomOut();
    cubit.zoomOut();
    expect(cubit.state.zoom, 0.75);

    for (var i = 0; i < zoomSteps.length; i++) {
      cubit.zoomOut();
    }
    expect(cubit.state.zoom, zoomSteps.first);

    for (var i = 0; i < zoomSteps.length; i++) {
      cubit.zoomIn();
    }
    expect(cubit.state.zoom, zoomSteps.last);

    cubit.resetZoom();
    expect(cubit.state.zoom, 1);
  });

  test('the device and its orientation can be changed', () {
    final cubit = WorkspaceCubit()
      ..setDevice(PreviewDevice.tablet)
      ..toggleOrientation();

    expect(cubit.state.device, PreviewDevice.tablet);
    expect(cubit.state.landscape, isTrue);
  });
}
