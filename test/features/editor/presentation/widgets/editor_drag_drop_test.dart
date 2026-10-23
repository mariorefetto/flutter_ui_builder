import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/drop_planner.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/tree_editor.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/drag_session_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_use_cases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/builtin_previews.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/editor_canvas.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/palette/palette_item.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/palette/widget_palette.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/prop_row.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/properties_panel.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

/// A Column root accepts any number of children, unlike a Scaffold.
EditorDocument columnDocument() => const EditorDocument(
  name: 'untitled',
  root: WidgetNode(id: 'node_0', type: 'Column'),
);

void main() {
  late EditorCubit cubit;
  final registry = WidgetRegistry(builtinDefinitions);

  setUp(() {
    final editor = TreeEditor(registry);
    cubit = EditorCubit(
      initialDocument: columnDocument(),
      useCases: EditorUseCases.from(
        editor: editor,
        planner: DropPlanner(registry),
        registry: registry,
      ),
    );
  });

  tearDown(() => cubit.close());

  Future<void> pumpEditor(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cubit),
          BlocProvider(create: (_) => WorkspaceCubit()),
          BlocProvider(create: (_) => DragSessionCubit()),
        ],
        child: Scaffold(
          body: Row(
            children: [
              SizedBox(width: 200, child: WidgetPalette(registry: registry)),
              SizedBox(width: 300, child: PropertiesPanel(registry: registry)),
              Expanded(
                child: EditorCanvas(
                  previews: PreviewRegistry(
                    registry: registry,
                    previews: builtinPreviews,
                  ),
                  registry: registry,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  testWidgets('dragging a palette entry onto the canvas adds the widget', (
    tester,
  ) async {
    // Tall enough to build every palette entry.
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpEditor(tester);
    await tester.tap(find.text('TEXT'));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(
      tester.getCenter(find.widgetWithText(PaletteItem, 'Text').last),
    );
    await gesture.moveTo(tester.getCenter(find.byType(EditorCanvas)) / 2);
    await tester.pump();
    await gesture.moveTo(
      tester.getTopLeft(find.byType(EditorCanvas)) + const Offset(40, 40),
    );
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(cubit.state.document.root.children.map((c) => c.type), ['Text']);
  });

  testWidgets('tapping a palette entry adds it to the selection', (
    tester,
  ) async {
    await pumpEditor(tester);
    await tester.tap(find.widgetWithText(PaletteItem, 'Row'));
    await tester.pumpAndSettle();

    expect(cubit.state.document.root.children.map((c) => c.type), ['Row']);
  });

  // The text field of the property named [name] in the properties panel.
  Finder fieldOf(String name) => find.descendant(
    of: find.byKey(ValueKey('prop-$name')),
    matching: find.byType(TextField),
  );

  Future<void> tallView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('editing a field updates the model and undo restores it', (
    tester,
  ) async {
    await tallView(tester);
    cubit.addNode(type: 'Text', parentId: 'node_0');
    await pumpEditor(tester);

    await tester.enterText(fieldOf('text'), 'Hello');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(cubit.state.document.root.children.first.props['text'], 'Hello');

    cubit.undo();
    await tester.pumpAndSettle();

    expect(cubit.state.document.root.children.first.props, isEmpty);
    expect(tester.widget<TextField>(fieldOf('text')).controller?.text, 'Text');
  });

  testWidgets('an invalid number is flagged and not stored', (tester) async {
    await tallView(tester);
    cubit.addNode(type: 'Text', parentId: 'node_0');
    await pumpEditor(tester);

    await tester.enterText(fieldOf('fontSize'), 'abc');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(cubit.state.document.root.children.first.props, isEmpty);
    expect(find.text('Invalid value'), findsOneWidget);
  });

  testWidgets('a value set on the node is reset from its row', (tester) async {
    await tallView(tester);
    cubit.addNode(type: 'Text', parentId: 'node_0');
    await pumpEditor(tester);
    await tester.enterText(fieldOf('text'), 'Hello');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('prop-text')),
        matching: find.byIcon(AppIcons.reset),
      ),
    );
    await tester.pumpAndSettle();

    expect(cubit.state.document.root.children.first.props, isEmpty);
  });

  testWidgets('the search field narrows the property list', (tester) async {
    await tallView(tester);
    cubit.addNode(type: 'Text', parentId: 'node_0');
    await pumpEditor(tester);

    await tester.enterText(
      find.widgetWithText(TextField, 'Search properties'),
      'font',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('prop-fontSize')), findsOneWidget);
    expect(find.byKey(const ValueKey('prop-maxLines')), findsNothing);
  });

  testWidgets('the color picker sets a color property', (tester) async {
    await tallView(tester);
    cubit.addNode(type: 'Text', parentId: 'node_0');
    await pumpEditor(tester);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('prop-color')),
        matching: find.byTooltip('Open the color picker'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Choose a color'), findsOneWidget);

    // The picker has a hex field; typing a color there picks it.
    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      '00FF00',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(cubit.state.document.root.children.first.props['color'], 0xFF00FF00);
  });

  testWidgets('cancelling the color picker changes nothing', (tester) async {
    await tallView(tester);
    cubit.addNode(type: 'Text', parentId: 'node_0');
    await pumpEditor(tester);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('prop-color')),
        matching: find.byTooltip('Open the color picker'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(cubit.state.document.root.children.first.props, isEmpty);
  });

  testWidgets('hovering a property name shows what it means', (tester) async {
    await tallView(tester);
    cubit.addNode(type: 'Text', parentId: 'node_0');
    await pumpEditor(tester);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(
      tester.getCenter(
        find.descendant(
          of: find.byKey(const ValueKey('prop-fontSize')),
          matching: find.text('fontSize'),
        ),
      ),
    );
    await tester.pump(propTooltipDelay);
    await tester.pump();

    expect(
      find.textContaining('The size of the letters, in logical pixels.'),
      findsOneWidget,
    );
    expect(find.textContaining('In the code: fontSize'), findsOneWidget);
  });

  testWidgets('a category header closes and opens its widgets', (tester) async {
    await pumpEditor(tester);
    expect(find.widgetWithText(PaletteItem, 'Row'), findsOneWidget);

    await tester.tap(find.text('LAYOUT'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(PaletteItem, 'Row'), findsNothing);

    await tester.tap(find.text('LAYOUT'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(PaletteItem, 'Row'), findsOneWidget);
  });

  testWidgets('a search opens the groups and bolds what it matched', (
    tester,
  ) async {
    await pumpEditor(tester);

    await tester.enterText(find.byType(TextField).first, 'slid');
    await tester.pumpAndSettle();

    expect(find.text('Slider', findRichText: true), findsOneWidget);
    expect(find.text('Row', findRichText: true), findsNothing);
  });

  testWidgets('a widget added is listed under recently added', (tester) async {
    await pumpEditor(tester);
    expect(find.text('RECENTLY ADDED'), findsNothing);

    await tester.tap(find.widgetWithText(PaletteItem, 'Row'));
    await tester.pumpAndSettle();

    expect(find.text('RECENTLY ADDED'), findsOneWidget);
    expect(find.widgetWithText(PaletteItem, 'Row'), findsNWidgets(2));
  });

  testWidgets('the filter lists only what fits where the selection is', (
    tester,
  ) async {
    await pumpEditor(tester);
    cubit
      ..addNode(type: 'Text', parentId: 'node_0')
      ..select('node_1');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Show only what can be added here'));
    await tester.pumpAndSettle();

    // A Text takes no children, so it can only get a sibling: a Scaffold
    // cannot be one.
    expect(find.widgetWithText(PaletteItem, 'Scaffold'), findsNothing);
    expect(find.widgetWithText(PaletteItem, 'Row'), findsOneWidget);
  });
}
