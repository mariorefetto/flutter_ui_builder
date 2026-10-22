import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/builtin_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/new_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/problem.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/document_linter.dart';

void main() {
  final linter = DocumentLinter(WidgetRegistry(builtinDefinitions));

  EditorDocument documentWith(WidgetNode child) => EditorDocument(
    name: 'test',
    root: WidgetNode(id: 'node_0', type: 'Column', children: [child]),
  );

  List<ProblemCode> codesOf(WidgetNode child) =>
      linter.lint(documentWith(child)).map((p) => p.code).toList();

  test('the starter screen has no problems', () {
    expect(linter.lint(createEmptyDocument()), isEmpty);
  });

  test('a NavigationBar needs two destinations', () {
    expect(
      codesOf(
        const WidgetNode(
          id: 'node_1',
          type: 'NavigationBar',
          children: [WidgetNode(id: 'node_2', type: 'NavigationDestination')],
        ),
      ),
      contains(ProblemCode.navigationBarFewDestinations),
    );
  });

  test('a hidden text field with several lines is reported', () {
    expect(
      codesOf(
        const WidgetNode(
          id: 'node_1',
          type: 'TextField',
          props: {'obscureText': true, 'maxLines': 3},
        ),
      ),
      [ProblemCode.hiddenTextMultiline],
    );
  });

  test('values Flutter rejects are reported', () {
    expect(
      codesOf(
        const WidgetNode(
          id: 'node_1',
          type: 'Positioned',
          props: {'left': 1, 'right': 2, 'width': 3},
        ),
      ),
      contains(ProblemCode.positionedOverconstrained),
    );
    expect(
      codesOf(
        const WidgetNode(
          id: 'node_1',
          type: 'CircleAvatar',
          props: {'radius': 10, 'maxRadius': 20},
        ),
      ),
      [ProblemCode.avatarRadiusConflict],
    );
    expect(
      codesOf(
        const WidgetNode(
          id: 'node_1',
          type: 'Slider',
          props: {'min': 5, 'max': 2},
        ),
      ),
      [ProblemCode.sliderRange],
    );
  });

  test('an image without a URL or a label is reported twice', () {
    expect(codesOf(const WidgetNode(id: 'node_1', type: 'Image')), [
      ProblemCode.imageWithoutUrl,
      ProblemCode.imageWithoutLabel,
    ]);
    expect(
      codesOf(
        const WidgetNode(
          id: 'node_1',
          type: 'Image',
          props: {'url': 'a.png', 'semanticLabel': 'A picture'},
        ),
      ),
      isEmpty,
    );
  });

  test('a widget that requires a child but has none is reported', () {
    final problems = linter.lint(
      documentWith(const WidgetNode(id: 'node_1', type: 'SafeArea')),
    );

    expect(problems.single.code, ProblemCode.requiredChildMissing);
    expect(problems.single.nodeType, 'SafeArea');
    expect(problems.single.nodeId, 'node_1');
  });

  test('accessibility gaps are notes, not warnings', () {
    final problems = linter.lint(
      documentWith(const WidgetNode(id: 'node_1', type: 'IconButton')),
    );

    expect(problems.single.severity, ProblemSeverity.info);
  });

  test('a circle with a radius is reported', () {
    expect(
      codesOf(
        const WidgetNode(
          id: 'node_1',
          type: 'Container',
          props: {'shape': 'circle', 'borderRadius': 4},
        ),
      ),
      [ProblemCode.circleWithRadius],
    );
    expect(
      codesOf(
        const WidgetNode(
          id: 'node_1',
          type: 'DecoratedBox',
          props: {'shape': 'circle'},
        ),
      ),
      isEmpty,
    );
  });

  test('text too close to the color behind it is reported', () {
    WidgetNode text(int color) =>
        WidgetNode(id: 'node_2', type: 'Text', props: {'color': color});

    expect(
      codesOf(
        WidgetNode(
          id: 'node_1',
          type: 'Container',
          props: const {'color': 0xFFFFFFFF},
          children: [text(0xFF999999)],
        ),
      ),
      [ProblemCode.lowContrast],
    );
    expect(
      codesOf(
        WidgetNode(
          id: 'node_1',
          type: 'Container',
          props: const {'color': 0xFFFFFFFF},
          children: [text(0xFF000000)],
        ),
      ),
      isEmpty,
    );
  });

  test('the nearest surface with a color decides the contrast', () {
    const nested = WidgetNode(
      id: 'node_1',
      type: 'Container',
      props: {'color': 0xFFFFFFFF},
      children: [
        WidgetNode(
          id: 'node_2',
          type: 'Container',
          props: {'color': 0xFF000000},
          children: [
            WidgetNode(
              id: 'node_3',
              type: 'Text',
              props: {'color': 0xFFFFFFFF},
            ),
          ],
        ),
      ],
    );

    expect(codesOf(nested), isEmpty);
  });

  test(
    'text with no color of its own, or on no known surface, is not judged',
    () {
      expect(
        codesOf(
          const WidgetNode(
            id: 'node_1',
            type: 'Text',
            props: {'color': 0xFF999999},
          ),
        ),
        isEmpty,
      );
    },
  );

  test('a small box around something tappable is a note', () {
    expect(
      codesOf(
        const WidgetNode(
          id: 'node_1',
          type: 'SizedBox',
          props: {'width': 24, 'height': 24},
          children: [WidgetNode(id: 'node_2', type: 'InkWell')],
        ),
      ),
      contains(ProblemCode.smallTapTarget),
    );
    expect(
      codesOf(
        const WidgetNode(
          id: 'node_1',
          type: 'SizedBox',
          props: {'width': 48, 'height': 48},
          children: [WidgetNode(id: 'node_2', type: 'InkWell')],
        ),
      ),
      isNot(contains(ProblemCode.smallTapTarget)),
    );
  });
}
