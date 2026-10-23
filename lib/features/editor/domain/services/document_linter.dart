import 'package:flutter_ui_builder/features/editor/domain/definitions/component_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/problem.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/color_contrast.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';

typedef _Test = bool Function(NodeProps props, WidgetNode node);

class _Check {
  const _Check(this.code, this.severity, this.test);

  final ProblemCode code;
  final ProblemSeverity severity;
  final _Test test;
}

const int _minDestinations = 2;

bool _hiddenMultiline(NodeProps props, WidgetNode node) =>
    (props.boolean('obscureText') ?? false) &&
    (props.number('maxLines') ?? 1) != 1;

bool _noTooltip(NodeProps props, WidgetNode node) =>
    (props.string('tooltip') ?? '').isEmpty;

bool _emptyRange(NodeProps props, WidgetNode node) =>
    (props.number('max') ?? 1) <= (props.number('min') ?? 0);

const _Check _noTooltipCheck = _Check(
  ProblemCode.missingTooltip,
  ProblemSeverity.info,
  _noTooltip,
);

const _Check _rangeCheck = _Check(
  ProblemCode.sliderRange,
  ProblemSeverity.warning,
  _emptyRange,
);

const _Check _circleCheck = _Check(
  ProblemCode.circleWithRadius,
  ProblemSeverity.warning,
  _circleWithRadius,
);

const _Check _hiddenCheck = _Check(
  ProblemCode.hiddenTextMultiline,
  ProblemSeverity.warning,
  _hiddenMultiline,
);

/// The checks that apply to one widget type each. Adding a check means adding
/// an entry here.
const Map<String, List<_Check>> _checks = {
  'NavigationBar': [
    _Check(
      ProblemCode.navigationBarFewDestinations,
      ProblemSeverity.warning,
      _fewDestinations,
    ),
  ],
  'TextField': [_hiddenCheck],
  'CupertinoTextField': [_hiddenCheck],
  'CircleAvatar': [
    _Check(ProblemCode.avatarRadiusConflict, ProblemSeverity.warning, _radius),
  ],
  'Positioned': [
    _Check(
      ProblemCode.positionedOverconstrained,
      ProblemSeverity.warning,
      _overconstrained,
    ),
  ],
  'Image': [
    _Check(ProblemCode.imageWithoutUrl, ProblemSeverity.warning, _noUrl),
    _Check(ProblemCode.imageWithoutLabel, ProblemSeverity.info, _noLabel),
  ],
  'Slider': [_rangeCheck],
  'CupertinoSlider': [_rangeCheck],
  'ListTile': [
    _Check(
      ProblemCode.threeLineWithoutSubtitle,
      ProblemSeverity.warning,
      _threeLine,
    ),
  ],
  'Container': [_circleCheck],
  'DecoratedBox': [_circleCheck],
  'IconButton': [_noTooltipCheck],
  'FloatingActionButton': [_noTooltipCheck],
};

bool _circleWithRadius(NodeProps props, WidgetNode node) =>
    props.choice('shape') == 'circle' &&
    [
      'borderRadius',
      'radiusTopLeft',
      'radiusTopRight',
      'radiusBottomLeft',
      'radiusBottomRight',
    ].any((name) => props.number(name) != null);

bool _fewDestinations(NodeProps props, WidgetNode node) =>
    node.children.where((c) => c.type == 'NavigationDestination').length <
    _minDestinations;

bool _radius(NodeProps props, WidgetNode node) =>
    props.number('radius') != null &&
    (props.number('minRadius') != null || props.number('maxRadius') != null);

bool _overconstrained(NodeProps props, WidgetNode node) =>
    (props.number('left') != null &&
        props.number('right') != null &&
        props.number('width') != null) ||
    (props.number('top') != null &&
        props.number('bottom') != null &&
        props.number('height') != null);

bool _noUrl(NodeProps props, WidgetNode node) =>
    (props.string('url') ?? '').isEmpty;

bool _noLabel(NodeProps props, WidgetNode node) =>
    (props.string('semanticLabel') ?? '').isEmpty;

bool _threeLine(NodeProps props, WidgetNode node) =>
    (props.boolean('isThreeLine') ?? false) && props.string('subtitle') == null;

/// Finds what is likely to go wrong in a document before it is run: values
/// Flutter rejects, missing required children and accessibility gaps.
/// Widgets that react to a tap, which should be at least this big to hit.
const Set<String> _tappable = {
  'InkWell',
  'GestureDetector',
  'IconButton',
  'ElevatedButton',
  'FilledButton',
  'OutlinedButton',
  'TextButton',
};

/// Widgets whose color or backgroundColor is what text on them is read against.
const Set<String> _surfaces = {
  'Container',
  'DecoratedBox',
  'ColoredBox',
  'Card',
  'AppBar',
  'Scaffold',
  'CircleAvatar',
  'Chip',
};

const double _smallestTarget = 48;

/// What the project holds, for the checks that point at its screens and
/// components.
class _Names {
  const _Names({
    required this.screens,
    required this.components,
    required this.cyclic,
  });

  final Set<String> screens;
  final Set<String> components;

  /// Components that contain themselves, or the open component.
  final Set<String> cyclic;
}

class DocumentLinter {
  const DocumentLinter(this._registry);

  final WidgetRegistry _registry;

  /// The problems of [document], in document order.
  List<Problem> lint(EditorDocument document) {
    const editor = ScreenEditor();
    final names = _Names(
      screens: editor.screensOf(document).toSet(),
      components: editor.componentsOf(document).toSet(),
      // A component that contains itself, or the open component.
      cyclic: {
        for (final name in editor.componentsOf(document))
          if (editor.usesComponent(document, name, name) ||
              (document.component &&
                  (name == document.name ||
                      editor.usesComponent(document, name, document.name))))
            name,
      },
    );
    return _lintNode(document.root, const [], names).toList();
  }

  Iterable<Problem> _lintNode(
    WidgetNode node,
    List<WidgetNode> above,
    _Names names,
  ) sync* {
    if (_registry.contains(node.type)) yield* _lintOwn(node, above, names);
    for (final child in node.children) {
      yield* _lintNode(child, [...above, node], names);
    }
  }

  Iterable<Problem> _lintOwn(
    WidgetNode node,
    List<WidgetNode> above,
    _Names names,
  ) sync* {
    final target = node.props[navigateToProp];
    if (target is String &&
        target != navigateBack &&
        !names.screens.contains(target)) {
      yield _problem(node, ProblemCode.unknownScreen, ProblemSeverity.warning);
    }
    final component = node.props[componentProp];
    if (node.type == componentType && component is String) {
      if (!names.components.contains(component)) {
        yield _problem(
          node,
          ProblemCode.unknownComponent,
          ProblemSeverity.warning,
        );
      } else if (names.cyclic.contains(component)) {
        yield _problem(
          node,
          ProblemCode.componentCycle,
          ProblemSeverity.warning,
        );
      }
    }
    final definition = _registry.definitionFor(node.type);
    final props = definition.resolve(node);
    if (definition.requiresChild && node.children.isEmpty) {
      yield _problem(
        node,
        ProblemCode.requiredChildMissing,
        ProblemSeverity.warning,
      );
    }
    for (final check in _checks[node.type] ?? const <_Check>[]) {
      if (check.test(props, node)) {
        yield _problem(node, check.code, check.severity);
      }
    }
    if (node.type == 'Text' && _lowContrast(props, above)) {
      yield _problem(node, ProblemCode.lowContrast, ProblemSeverity.warning);
    }
    if (_smallTapTarget(node)) {
      yield _problem(node, ProblemCode.smallTapTarget, ProblemSeverity.info);
    }
  }

  // Text with its own color, on the nearest surface that has one, when the two
  // are too alike to read. Without both colors there is nothing to compare.
  bool _lowContrast(NodeProps props, List<WidgetNode> above) {
    final text = props.color('color');
    if (text == null) return false;
    for (final ancestor in above.reversed) {
      final background = _backgroundOf(ancestor);
      if (background != null) {
        return contrastRatio(text, background) < minimumTextContrast;
      }
    }
    return false;
  }

  int? _backgroundOf(WidgetNode node) {
    if (!_surfaces.contains(node.type)) return null;
    final value = node.props['color'] ?? node.props['backgroundColor'];
    return value is int ? value : null;
  }

  // A box with a size under the smallest comfortable target around something
  // that can be tapped.
  bool _smallTapTarget(WidgetNode node) {
    if (node.type != 'SizedBox' && node.type != 'Container') return false;
    if (node.children.length != 1 ||
        !_tappable.contains(node.children.single.type)) {
      return false;
    }
    bool small(Object? side) => side is num && side < _smallestTarget;
    return small(node.props['width']) || small(node.props['height']);
  }

  Problem _problem(
    WidgetNode node,
    ProblemCode code,
    ProblemSeverity severity,
  ) => Problem(
    nodeId: node.id,
    nodeType: node.type,
    code: code,
    severity: severity,
  );
}
