import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';

const String _defaultName = 'untitled';

/// A starter screen: a Scaffold with an AppBar and a Column as its body.
EditorDocument createEmptyDocument() => const EditorDocument(
  name: _defaultName,
  root: WidgetNode(
    id: 'node_0',
    type: 'Scaffold',
    children: [
      WidgetNode(id: 'node_1', type: 'AppBar'),
      WidgetNode(id: 'node_2', type: 'Column'),
    ],
  ),
);
