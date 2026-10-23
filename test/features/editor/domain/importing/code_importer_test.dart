import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/services/analyzer_code_parser.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_importer.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/import_usecases.dart';

void main() {
  final importer = CodeImporter(
    WidgetRegistry(builtinDefinitions),
    const AnalyzerCodeParser(),
  );

  ImportResult import(String source) => importer
      .import(source)
      .getOrElse(() => throw StateError('expected an import'));

  DocumentFailureReason? failureOf(String source) => importer
      .import(source)
      .fold((f) => f is DocumentFailure ? f.reason : null, (_) => null);

  const screen = '''
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello', style: TextStyle(fontSize: 20, color: Color(0xFF112233))),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () {}, child: Text('Go')),
        ],
      ),
    );
  }
}
''';

  test('a screen becomes a tree of widgets with its properties', () {
    final result = import(screen);
    final root = result.document.root;

    expect(result.document.name, 'Home');
    expect(root.type, 'Scaffold');
    expect(root.children.map((c) => c.type), ['AppBar', 'Column']);
    expect(root.children.first.props, {'title': 'Home', 'centerTitle': true});
    final column = root.children.last;
    expect(column.props, {'mainAxisAlignment': 'center'});
    expect(column.children.map((c) => c.type), [
      'Text',
      'SizedBox',
      'ElevatedButton',
    ]);
    expect(column.children.first.props, {
      'text': 'Hello',
      'fontSize': 20.0,
      'color': 0xFF112233,
    });
    expect(column.children[1].props, {'height': 8.0});
  });

  test('callbacks are not part of the model and are not reported', () {
    expect(import(screen).issues, isEmpty);
  });

  test('ids are fresh and unique', () {
    final ids = <String>[];
    void collect(WidgetNode node) {
      ids.add(node.id);
      node.children.forEach(collect);
    }

    collect(import(screen).document.root);

    expect(ids.first, 'node_0');
    expect(ids.toSet(), hasLength(ids.length));
  });

  test('a single widget expression is enough', () {
    final result = import(
      "Padding(padding: EdgeInsets.all(8), child: Text('x'))",
    );

    expect(result.document.name, 'imported');
    expect(result.document.root.type, 'Padding');
    // 8 is the default padding, so nothing is stored.
    expect(result.document.root.props, isEmpty);
  });

  test('colors, insets and enums are read in their usual spellings', () {
    final root = import('''
Container(
  color: Colors.blue,
  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
  padding: EdgeInsets.fromLTRB(1, 2, 3, 4),
  alignment: Alignment.center,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: Color.fromARGB(255, 0, 255, 0), width: 2),
  ),
)
''').document.root;

    expect(root.props['margin'], [4.0, 2.0, 4.0, 2.0]);
    expect(root.props['padding'], [1.0, 2.0, 3.0, 4.0]);
    expect(root.props['alignment'], 'center');
    expect(root.props['borderRadius'], 6.0);
    expect(root.props['borderColor'], 0xFF00FF00);
    expect(root.props['borderWidth'], 2.0);
    expect(root.props['color'], 0xFF2196F3);
  });

  test('a widget the builder lacks is replaced and reported', () {
    final result = import("Hero(tag: 'a', child: Text('x'))");

    expect(result.document.root.type, 'Text');
    expect(result.issues.single.kind, ImportIssueKind.unknownWidget);
    expect(result.issues.single.widgetType, 'Hero');
  });

  test('an unknown leaf becomes a placeholder, several children a column', () {
    expect(import('CustomPaint()').document.root.type, 'Placeholder');

    final many = import("Foo(children: [Text('a'), Text('b')])").document.root;
    expect(many.type, 'Column');
    expect(many.children, hasLength(2));
  });

  test('arguments and values that cannot be used are reported and dropped', () {
    final result = import(
      "Text('x', semanticsLabel: 'a', style: TextStyle(fontSize: size))",
    );
    final kinds = result.issues.map((i) => i.kind).toSet();

    expect(kinds, contains(ImportIssueKind.unsupportedArgument));
    expect(result.document.root.props, {'text': 'x'});
  });

  test('a Material widget gets the Scaffold it needs', () {
    final result = import(
      "TextField(decoration: InputDecoration(labelText: 'Name'))",
    );

    expect(result.document.root.type, 'Scaffold');
    expect(result.document.root.children.single.type, 'TextField');
    expect(
      result.issues.map((i) => i.kind),
      contains(ImportIssueKind.wrappedInScaffold),
    );
  });

  test('code that breaks a placement rule is refused with the reason', () {
    expect(
      failureOf('Column(children: [AppBar()])'),
      DocumentFailureReason.invalidStructure,
    );
  });

  test('syntax errors and code without a widget are told apart', () {
    expect(failureOf('Column(children: ['), DocumentFailureReason.codeSyntax);
    expect(failureOf('42'), DocumentFailureReason.codeNoWidget);
    expect(failureOf(''), DocumentFailureReason.codeSyntax);
  });

  test('the missing child the generator writes is read as no child', () {
    final root = import('SafeArea(child: SizedBox.shrink())').document.root;

    expect(root.type, 'SafeArea');
    expect(root.children, isEmpty);
  });

  group('navigation', () {
    String button(String callback) =>
        '''
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [TextButton(onPressed: $callback, child: Text('Go'))]);
  }
}
''';

    Object? targetOf(String callback) => import(
      button(callback),
    ).document.root.children.single.props['navigateTo'];

    test('a push of a screen is read as the screen it opens', () {
      expect(
        targetOf(
          '() => Navigator.push(context, MaterialPageRoute<void>('
          'builder: (_) => const SettingsView()))',
        ),
        'Settings',
      );
    });

    test('opening a screen by its route is read as that screen', () {
      expect(
        targetOf("() => Navigator.pushNamed(context, '/my_settings')"),
        'my settings',
      );
    });

    test('a pop is read as going back', () {
      expect(targetOf('() => Navigator.pop(context)'), ':back');
    });

    test('a block with the one call is read the same way', () {
      expect(targetOf('() { Navigator.pop(context); }'), ':back');
    });

    test('any other callback is left empty', () {
      expect(targetOf('() {}'), isNull);
      expect(targetOf('() => print(1)'), isNull);
    });
  });

  group('components', () {
    test('a call to a component class is read as a use of the component', () {
      final result = import('''
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [const ProfileCardWidget(), Text('x')]);
  }
}
''');

      final use = result.document.root.children.first;
      expect(use.type, 'Component');
      expect(use.props['component'], 'ProfileCard');
    });

    test('a class with arguments that happens to end in Widget is not one', () {
      final result = import('''
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [ErrorWidget('x')]);
  }
}
''');

      expect(
        result.document.root.children.where((c) => c.type == 'Component'),
        isEmpty,
      );
    });
  });

  group('a file with several widget classes', () {
    const file = '''
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const BadgeWidget(title: 'New'),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const SettingsView())),
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }
}

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({super.key, this.title = 'Hi'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Badge'));
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Settings'));
  }
}
''';

    test('the first screen leads and the rest come with it', () {
      final result = import(file);

      expect(result.document.name, 'Home');
      expect(result.document.component, isFalse);
      expect(result.extras.map((e) => e.document.name), ['Badge', 'Settings']);
      expect(result.extras.map((e) => e.document.component), [true, false]);
    });

    test(
      'a component class is read as a component, apart from its context',
      () {
        final badge = import(file).extras.first.document;

        expect(badge.component, isTrue);
        expect(badge.root.type, 'Container');
      },
    );

    test('a screen leads even when a component comes first in the file', () {
      final result = import('''
class BadgeWidget extends StatelessWidget {
  const BadgeWidget({super.key});

  @override
  Widget build(BuildContext context) => Container();
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: Text('x'));
}
''');

      expect(result.document.name, 'Home');
      expect(result.extras.single.document.name, 'Badge');
    });

    test('the project joins the screens and points them at each other', () {
      final project = const BuildImportedProject()(
        import(file),
      ).getOrElse(() => throw StateError('build failed'));

      expect(const ScreenEditor().screensOf(project), ['Home', 'Settings']);
      expect(const ScreenEditor().componentsOf(project), ['Badge']);
      expect(project.name, 'Home');
      final use = project.root.find('node_2');
      expect(use?.props['component'], 'Badge');
    });

    test('a file with a single class is as it was', () {
      final result = import(screen);

      expect(result.extras, isEmpty);
    });
  });
}
