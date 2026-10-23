import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/app.dart';
import 'package:flutter_ui_builder/core/di/injection.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/widgets/app_select.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_edit_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/canvas_node.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/editor_canvas.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/scaled_box.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/code/code_view.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/drag/dashed_outline.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/palette/palette_item.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/editor_shortcuts.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/tree/tree_row.dart';

void main() {
  setUp(() async {
    await sl.reset();
    await configureDependencies();
  });

  tearDown(sl.reset);

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
  }

  testWidgets('the app starts with menus, toolbox, designer and status', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('File'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('View'), findsOneWidget);
    expect(find.text('Toolbox'), findsOneWidget);
    expect(find.text('Properties'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
  });

  testWidgets('choosing Dark in the View menu switches the theme', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('View'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(MenuBar));
    expect(Theme.of(context).brightness, Brightness.dark);
  });

  testWidgets('the Code tab shows the generated code of the project', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Code'));
    await tester.pumpAndSettle();

    expect(find.textContaining('class UntitledView'), findsOneWidget);
  });

  testWidgets('selecting in the outline shows the path and the properties', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.text('No selection'), findsWidgets);

    await tester.tap(find.byTooltip('Document outline'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TreeRow, 'Column'));
    await tester.pumpAndSettle();

    expect(find.text('Scaffold > Column'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('prop-mainAxisAlignment')),
      findsOneWidget,
    );
  });

  testWidgets('the Toolbox can be closed from the View menu', (tester) async {
    await pumpApp(tester);
    expect(find.text('Search widgets'), findsOneWidget);

    await tester.tap(find.text('View'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(MenuItemButton, 'Toolbox'));
    await tester.pumpAndSettle();

    expect(find.text('Search widgets'), findsNothing);
  });

  EditorCubit editorOf(WidgetTester tester) =>
      tester.element(find.byType(MenuBar)).read<EditorCubit>();

  Future<void> pressWithControl(
    WidgetTester tester,
    LogicalKeyboardKey key,
  ) async {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(key);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
  }

  Finder nodeFinder(String id) =>
      find.byWidgetPredicate((w) => w is CanvasNode && w.node.id == id);

  testWidgets('right click on a leaf offers only what fits next to it', (
    tester,
  ) async {
    await pumpApp(tester);

    // The AppBar title: the menu is about the AppBar, a leaf.
    await tester.tap(find.text('Title'), buttons: kSecondaryButton);
    await tester.pumpAndSettle();
    expect(find.text('AppBar  (node_1)'), findsOneWidget);

    // Nothing can go inside an AppBar, so that entry is disabled.
    final inside = tester.widget<MenuItemButton>(
      find.widgetWithText(MenuItemButton, 'Add inside'),
    );
    expect(inside.onPressed, isNull);

    await tester.tap(find.text('Add next to'));
    await tester.pumpAndSettle();
    // The toolbox has a Screen group too; the menu is on top, so it is last.
    await tester.tap(find.text('Screen').last);
    await tester.pumpAndSettle();

    // The AppBar and the body slots are taken; the others are offered.
    expect(
      find.widgetWithText(MenuItemButton, 'FloatingActionButton'),
      findsOneWidget,
    );
    expect(find.widgetWithText(MenuItemButton, 'BottomAppBar'), findsOneWidget);
    expect(find.widgetWithText(MenuItemButton, 'AppBar'), findsNothing);
    expect(find.widgetWithText(MenuItemButton, 'Column'), findsNothing);

    await tester.tap(
      find.widgetWithText(MenuItemButton, 'FloatingActionButton'),
    );
    await tester.pumpAndSettle();

    final types = editorOf(
      tester,
    ).state.document.root.children.map((c) => c.type);
    expect(types, contains('FloatingActionButton'));
  });

  testWidgets('right click on the body offers what can go inside it', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester);

    await tester.tap(nodeFinder('node_2'), buttons: kSecondaryButton);
    await tester.pumpAndSettle();
    expect(cubit.state.selectedId, 'node_2');
    expect(find.text('Column  (node_2)'), findsOneWidget);

    // A Column takes widgets, but not a screen part such as an AppBar.
    expect(cubit.canAddInside('Text'), isTrue);
    expect(cubit.canAddInside('AppBar'), isFalse);
    // A ListView does fit: it is wrapped in an Expanded.
    expect(cubit.canAddInside('ListView'), isTrue);

    await tester.tap(find.text('Add inside'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scrolling').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(MenuItemButton, 'ListView'));
    await tester.pumpAndSettle();

    final column = cubit.state.document.root.find('node_2');
    expect(column?.children.single.type, 'Expanded');
    expect(column?.children.single.children.single.type, 'ListView');
  });

  testWidgets('keyboard shortcuts undo, copy, paste and duplicate', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester)..addNode(type: 'Text', parentId: 'node_2');
    await tester.pumpAndSettle();
    List<Object> columnChildren() =>
        cubit.state.document.root.children.last.children;

    await pressWithControl(tester, LogicalKeyboardKey.keyD);
    expect(columnChildren(), hasLength(2));

    await pressWithControl(tester, LogicalKeyboardKey.keyZ);
    expect(columnChildren(), hasLength(1));

    // Undo removed the copy that was selected, so select the original again.
    cubit.select('node_3');
    await pressWithControl(tester, LogicalKeyboardKey.keyC);
    await pressWithControl(tester, LogicalKeyboardKey.keyV);
    expect(columnChildren(), hasLength(2));
  });

  testWidgets('the problems panel lists problems and selects the widget', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester)..addNode(type: 'Image', parentId: 'node_2');
    final imageId = cubit.state.selectedId;
    cubit.select(null);
    await tester.pumpAndSettle();

    await tester.tap(find.text('View'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(MenuItemButton, 'Problems'));
    await tester.pumpAndSettle();

    expect(find.text('Problems (2)'), findsOneWidget);
    expect(
      find.text('The image has no URL, so it will fail to load'),
      findsOneWidget,
    );

    await tester.tap(
      find.text('The image has no URL, so it will fail to load'),
    );
    await tester.pumpAndSettle();

    expect(cubit.state.selectedId, imageId);
  });

  testWidgets('the screen size and the zoom change the designer', (
    tester,
  ) async {
    await pumpApp(tester);
    Size designer() => tester.getSize(find.byType(ScaledBox));

    // A phone is 390 wide with a 12 thick body on each side.
    expect(designer().width, 390 + 2 * 12);

    await tester.tap(find.byType(AppSelect<PreviewDevice>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tablet').last);
    await tester.pumpAndSettle();
    expect(designer().width, 820 + 2 * 16);

    await tester.tap(find.byTooltip('Zoom out'));
    await tester.pumpAndSettle();
    expect(designer().width, (820 + 2 * 16) * 0.75);

    await tester.tap(find.byTooltip('Rotate the screen'));
    await tester.pumpAndSettle();
    expect(designer().width, (1180 + 2 * 16) * 0.75);
  });

  testWidgets('the device frame shows a status bar that can be changed', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('9:41'), findsOneWidget);

    await tester.tap(find.byTooltip('Status bar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hidden'));
    await tester.pumpAndSettle();
    expect(find.text('9:41'), findsNothing);

    await tester.tap(find.byTooltip('Device frame'));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(ScaledBox)).width, 390);
  });

  testWidgets('the app bar and a safe area keep clear of the status bar', (
    tester,
  ) async {
    await pumpApp(tester);
    editorOf(tester).addNode(type: 'SafeArea', parentId: 'node_2');
    await tester.pumpAndSettle();

    final bar = tester.getRect(find.byType(AppBar));
    final statusBar = tester.getRect(find.text('9:41')).bottom;

    expect(
      tester
          .getRect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.byType(NavigationToolbar),
            ),
          )
          .top,
      greaterThanOrEqualTo(statusBar - 1),
      reason: 'app bar $bar, status bar bottom $statusBar',
    );
  });

  testWidgets('the code can sit beside the designer or below it', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.byType(CodeView).hitTestable(), findsNothing);

    await tester.tap(find.byTooltip('Code beside the designer'));
    await tester.pumpAndSettle();
    final design = tester.getRect(find.byType(EditorCanvas));
    final code = tester.getRect(find.byType(CodeView));
    expect(code.left, greaterThanOrEqualTo(design.right));
    expect(code.top, lessThan(design.bottom));

    await tester.tap(find.byTooltip('Code below the designer'));
    await tester.pumpAndSettle();
    final below = tester.getRect(find.byType(CodeView));
    expect(
      below.top,
      greaterThanOrEqualTo(tester.getRect(find.byType(EditorCanvas)).bottom),
    );

    await tester.tap(find.byTooltip('Code as a tab'));
    await tester.pumpAndSettle();
    expect(find.byType(CodeView).hitTestable(), findsNothing);
  });

  testWidgets('the safe area can be shown over the screen', (tester) async {
    await pumpApp(tester);
    expect(find.byKey(const ValueKey('safe-area-tint')), findsNothing);

    await tester.tap(find.byTooltip('Show the safe area'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('safe-area-tint')), findsOneWidget);
  });

  testWidgets('Delete and Backspace remove the widget picked in the outline', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester)
      ..addNode(type: 'Text', parentId: 'node_2')
      ..addNode(type: 'Image', parentId: 'node_2')
      ..select(null);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Document outline'));
    await tester.pumpAndSettle();
    List<String> bodyTypes() => cubit.state.document.root
        .find('node_2')!
        .children
        .map((c) => c.type)
        .toList();
    expect(bodyTypes(), ['Text', 'Image']);

    await tester.tap(find.widgetWithText(TreeRow, 'Text'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.pumpAndSettle();
    expect(bodyTypes(), ['Image']);

    // The key a Mac labels Delete is Backspace.
    await tester.tap(find.widgetWithText(TreeRow, 'Image'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pumpAndSettle();
    expect(bodyTypes(), isEmpty);
  });

  testWidgets('Backspace in a property field edits the text, not the tree', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester)..addNode(type: 'Text', parentId: 'node_2');
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('prop-text')),
        matching: find.byType(TextField),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pumpAndSettle();

    expect(cubit.state.document.root.find('node_2')!.children, hasLength(1));
  });

  testWidgets('pasted code is rendered and opened in the designer', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester);

    await tester.tap(find.text('File'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Import code...'));
    await tester.pumpAndSettle();
    expect(find.text('Import code'), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      '''
Scaffold(
  appBar: AppBar(title: Text('Imported')),
  body: Center(child: Hero(tag: 'a', child: Text('Hello'))),
)''',
    );
    await tester.tap(find.text('Render'));
    await tester.pumpAndSettle();

    expect(find.text('4 widgets found'), findsOneWidget);
    expect(find.text('Hero is not available and was replaced'), findsOneWidget);

    await tester.tap(find.text('Open in the designer'));
    await tester.pumpAndSettle();

    final root = cubit.state.document.root;
    expect(root.type, 'Scaffold');
    expect(find.text('Imported'), findsWidgets);
    // The project is unsaved, since it came from pasted code.
    expect(find.text('Modified'), findsOneWidget);
  });

  testWidgets('code with errors shows why and cannot be opened', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Import code...'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      'Column(children: [',
    );
    await tester.tap(find.text('Render'));
    await tester.pumpAndSettle();

    expect(find.text('The code has syntax errors'), findsOneWidget);
    final apply = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Open in the designer'),
    );
    expect(apply.onPressed, isNull);
  });

  // The text field of the code editor, which sits in the Code tab.
  Finder codeField() => find.descendant(
    of: find.byType(CodeView),
    matching: find.byType(TextField),
  );

  const editedCode = '''
class UntitledView extends StatelessWidget {
  const UntitledView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edited')),
      body: Column(children: [Text('hi')]),
    );
  }
}
''';

  Future<void> openCode(WidgetTester tester) async {
    await tester.tap(find.text('Code').last);
    await tester.pumpAndSettle();
  }

  Future<void> typeCode(WidgetTester tester, String code) async {
    await tester.enterText(codeField(), code);
    await tester.pump(codeCheckDelay);
    await tester.pumpAndSettle();
  }

  testWidgets('edited code is applied to the project in one undo step', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester);
    await openCode(tester);
    expect(find.text('In sync'), findsOneWidget);

    await typeCode(tester, editedCode);
    expect(find.text('Edited'), findsWidgets);

    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    final root = cubit.state.document.root;
    expect(root.children.first.props['title'], 'Edited');
    // The widgets that did not move kept their ids; the new one got a new id.
    expect(root.children.map((c) => c.id), ['node_1', 'node_2']);
    expect(root.children.last.children.single.type, 'Text');
    expect(cubit.state.document.name, 'untitled');
    expect(find.text('In sync'), findsOneWidget);

    cubit.undo();
    await tester.pumpAndSettle();

    expect(cubit.state.document.root.children.first.props, isEmpty);
    expect(cubit.state.document.root.children.last.children, isEmpty);
  });

  testWidgets('code with errors cannot be applied and says why', (
    tester,
  ) async {
    await pumpApp(tester);
    await openCode(tester);

    await typeCode(tester, 'Column(children: [');

    expect(find.text('The code has syntax errors'), findsOneWidget);
    final apply = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Apply'),
    );
    expect(apply.onPressed, isNull);
  });

  testWidgets('revert drops the edits and shows the generated code', (
    tester,
  ) async {
    await pumpApp(tester);
    await openCode(tester);
    await typeCode(tester, editedCode);

    await tester.tap(find.byTooltip('Revert'));
    await tester.pumpAndSettle();

    expect(find.text('In sync'), findsOneWidget);
    expect(find.textContaining('Edited'), findsNothing);
  });

  testWidgets('a change in the designer does not overwrite edited code', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester);
    await openCode(tester);
    await typeCode(tester, editedCode);

    cubit.addNode(type: 'Text', parentId: 'node_2');
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(codeField()).controller?.text, editedCode);
    expect(find.text('Edited'), findsWidgets);
  });

  testWidgets('Export waits until the edits are applied or reverted', (
    tester,
  ) async {
    await pumpApp(tester);
    await openCode(tester);
    await typeCode(tester, editedCode);

    final export = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, AppIcons.export),
    );

    expect(export.onPressed, isNull);
  });

  testWidgets('the outline search narrows the rows to matches and their way', (
    tester,
  ) async {
    await pumpApp(tester);
    editorOf(tester)
      ..addNode(type: 'Text', parentId: 'node_2')
      ..addNode(type: 'Image', parentId: 'node_2');
    await tester.tap(find.byTooltip('Document outline'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TreeRow, 'Image'), findsOneWidget);
    expect(find.widgetWithText(TreeRow, 'AppBar'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Search the outline'),
      'imag',
    );
    await tester.pumpAndSettle();

    // The Image, and the Column and Scaffold above it; nothing else.
    expect(find.widgetWithText(TreeRow, 'Image'), findsOneWidget);
    expect(find.widgetWithText(TreeRow, 'Column'), findsOneWidget);
    expect(find.widgetWithText(TreeRow, 'Scaffold'), findsOneWidget);
    expect(find.widgetWithText(TreeRow, 'Text'), findsNothing);
    expect(find.widgetWithText(TreeRow, 'AppBar'), findsNothing);
  });

  testWidgets(
    'F2 names the selected widget and the name shows in the outline',
    (tester) async {
      await pumpApp(tester);
      final cubit = editorOf(tester)..addNode(type: 'Text', parentId: 'node_2');
      await tester.tap(find.byTooltip('Document outline'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TreeRow, 'Text'));
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.f2);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Headline');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(cubit.state.document.root.find('node_3')?.label, 'Headline');
      expect(find.text('Headline  Text', findRichText: true), findsOneWidget);
    },
  );

  testWidgets('arrow keys move the selection and Cmd/Ctrl+arrows reorder', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester)
      ..addNode(type: 'Text', parentId: 'node_2')
      ..addNode(type: 'Image', parentId: 'node_2')
      ..select('node_3');
    await tester.pumpAndSettle();
    EditorShortcuts.reclaimFocus(tester.element(find.byType(MenuBar)));
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(cubit.state.selectedId, 'node_4');

    await pressWithControl(tester, LogicalKeyboardKey.arrowUp);
    expect(
      cubit.state.document.root.find('node_2')!.children.map((c) => c.id),
      ['node_4', 'node_3'],
    );
  });

  testWidgets('dragging a row in the outline reorders the widgets', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    final cubit = editorOf(tester)
      ..addNode(type: 'Text', parentId: 'node_2')
      ..addNode(type: 'Image', parentId: 'node_2');
    await tester.tap(find.byTooltip('Document outline'));
    await tester.pumpAndSettle();

    final from = tester.getCenter(find.widgetWithText(TreeRow, 'Image'));
    final text = tester.getRect(find.widgetWithText(TreeRow, 'Text'));
    final gesture = await tester.startGesture(from);
    await gesture.moveTo(from + const Offset(0, -10));
    // The top quarter of a row puts the widget before it.
    await gesture.moveTo(Offset(text.center.dx, text.top + 2));
    await tester.pump();
    // While it is dragged, the widget's own row is outlined.
    expect(find.byType(DashedOutline), findsWidgets);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(
      cubit.state.document.root.find('node_2')!.children.map((c) => c.type),
      ['Image', 'Text'],
    );
    expect(find.byType(DashedOutline), findsNothing);
  });

  testWidgets('the outline closes a widget and counts what it hides', (
    tester,
  ) async {
    await pumpApp(tester);
    editorOf(tester)
      ..addNode(type: 'Text', parentId: 'node_2')
      ..addNode(type: 'Image', parentId: 'node_2')
      ..select('node_0');
    await tester.tap(find.byTooltip('Document outline'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TreeRow, 'Image'), findsOneWidget);

    await tester.tap(find.byTooltip('Collapse all'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TreeRow, 'Image'), findsNothing);
    expect(find.widgetWithText(TreeRow, 'Scaffold'), findsOneWidget);

    await tester.tap(find.byTooltip('Expand all'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TreeRow, 'Image'), findsOneWidget);
  });

  testWidgets('selecting a hidden widget opens the way to it', (tester) async {
    await pumpApp(tester);
    final cubit = editorOf(tester)..addNode(type: 'Image', parentId: 'node_2');
    await tester.tap(find.byTooltip('Document outline'));
    await tester.pumpAndSettle();
    // The widget just added is selected, which keeps its way open.
    cubit.select(null);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Collapse all'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TreeRow, 'Image'), findsNothing);

    cubit.select(cubit.state.document.root.children.last.children.last.id);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TreeRow, 'Image'), findsOneWidget);
  });

  testWidgets('a row offers to duplicate and delete under the pointer', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester)..addNode(type: 'Image', parentId: 'node_2');
    await tester.tap(find.byTooltip('Document outline'));
    await tester.pumpAndSettle();

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.widgetWithText(TreeRow, 'Image')));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Duplicate'));
    await tester.pumpAndSettle();

    expect(
      cubit.state.document.root.find('node_2')?.children.map((c) => c.type),
      ['Image', 'Image'],
    );
  });

  testWidgets('screens have tabs, and a button can open another one', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester);

    await tester.tap(find.byTooltip('New screen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New screen').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Settings');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(cubit.state.document.name, 'Settings');
    expect(find.text('Settings'), findsWidgets);

    await tester.tap(find.byTooltip('Open untitled'));
    await tester.pumpAndSettle();
    expect(cubit.state.document.name, 'untitled');

    cubit
      ..addNode(type: 'ElevatedButton', parentId: 'node_2')
      ..updateProp('node_3', 'navigateTo', 'Settings');
    await tester.pumpAndSettle();
    expect(
      cubit.state.document.root.find('node_3')?.props['navigateTo'],
      'Settings',
    );

    await tester.tap(find.byTooltip('Open the target screen'));
    await tester.pumpAndSettle();
    expect(cubit.state.document.name, 'Settings');
  });

  testWidgets('in prototype mode a click follows the navigation', (
    tester,
  ) async {
    await pumpApp(tester);
    final cubit = editorOf(tester)
      ..addScreen('Details')
      ..addNode(type: 'TextButton', parentId: 'node_2')
      ..updateProp('node_3', 'navigateTo', ':back')
      ..openScreen('untitled')
      ..addNode(type: 'ElevatedButton', parentId: 'node_2')
      ..updateProp('node_3', 'navigateTo', 'Details');
    await tester.pumpAndSettle();

    await tester.tap(
      find.byTooltip('Try the navigation: clicking a widget opens its screen'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(cubit.state.document.name, 'Details');
    expect(cubit.state.selectedId, isNull);

    // The editor has text buttons of its own; this one is on the screen.
    await tester.tap(
      find.descendant(
        of: find.byType(EditorCanvas),
        matching: find.byType(TextButton),
      ),
    );
    await tester.pumpAndSettle();
    expect(cubit.state.document.name, 'untitled');
  });

  group('selection outline', () {
    Finder outline() => find.byWidgetPredicate((widget) {
      if (widget is! DecoratedBox) return false;
      final decoration = widget.decoration;
      return decoration is BoxDecoration &&
          decoration.border != null &&
          decoration.border!.isUniform &&
          decoration.border!.top.width == 2;
    });

    testWidgets('an app bar is outlined below the status bar', (tester) async {
      await pumpApp(tester);
      editorOf(tester).select('node_1');
      await tester.pumpAndSettle();

      final statusBottom = tester.getRect(find.text('9:41')).bottom;

      expect(
        tester.getRect(outline().first).top,
        greaterThanOrEqualTo(statusBottom),
      );
    });

    testWidgets('the screen is outlined with the corners of the device', (
      tester,
    ) async {
      await pumpApp(tester);
      editorOf(tester).select('node_0');
      await tester.pumpAndSettle();

      final decoration =
          tester.widget<DecoratedBox>(outline().first).decoration
              as BoxDecoration;

      expect(decoration.borderRadius, isNotNull);

      await tester.tap(find.byTooltip('Device frame'));
      await tester.pumpAndSettle();
      final bare =
          tester.widget<DecoratedBox>(outline().first).decoration
              as BoxDecoration;
      expect(bare.borderRadius, isNull);
    });
  });

  group('components', () {
    testWidgets('a widget made a component shows in the palette and draws', (
      tester,
    ) async {
      await pumpApp(tester);
      final cubit = editorOf(tester)
        ..addNode(type: 'Text', parentId: 'node_2')
        ..updateProp('node_3', 'text', 'Shared words')
        ..select('node_3')
        ..extractSelectedAsComponent('Greeting');
      await tester.pumpAndSettle();

      // The text is drawn where the use is, through the component.
      expect(find.text('Shared words'), findsWidgets);
      expect(cubit.state.document.root.find('node_3')?.type, 'Component');
      expect(find.text('COMPONENTS'), findsOneWidget);
      expect(find.widgetWithText(PaletteItem, 'Greeting'), findsOneWidget);
    });

    testWidgets('adding a component from the palette makes a use of it', (
      tester,
    ) async {
      await pumpApp(tester);
      final cubit = editorOf(tester)
        ..addNode(type: 'Text', parentId: 'node_2')
        ..select('node_3')
        ..extractSelectedAsComponent('Greeting')
        ..select('node_2');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(PaletteItem, 'Greeting'));
      await tester.pumpAndSettle();

      final column = cubit.state.document.root.find('node_2');
      expect(
        column?.children.where((c) => c.props['component'] == 'Greeting'),
        hasLength(2),
      );
    });

    testWidgets('a component opens in its own tab and edits reach its uses', (
      tester,
    ) async {
      await pumpApp(tester);
      final cubit = editorOf(tester)
        ..addNode(type: 'Text', parentId: 'node_2')
        ..updateProp('node_3', 'text', 'Before')
        ..select('node_3')
        ..extractSelectedAsComponent('Greeting');
      await tester.pumpAndSettle();

      cubit.openScreen('Greeting');
      await tester.pumpAndSettle();
      expect(cubit.state.document.component, isTrue);
      cubit.updateProp('node_0', 'text', 'After');
      await tester.pumpAndSettle();
      cubit.openScreen('untitled');
      await tester.pumpAndSettle();

      expect(find.text('After'), findsWidgets);
      expect(find.text('Before'), findsNothing);
    });
  });
}
