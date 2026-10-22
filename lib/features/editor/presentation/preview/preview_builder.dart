import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';

/// The preview of one child, with the type of the node it came from. Parents
/// such as Scaffold use the type to put it in the right slot.
class PreviewChild {
  const PreviewChild({required this.type, required this.widget});

  final String type;
  final Widget widget;
}

extension PreviewChildren on List<PreviewChild> {
  List<Widget> get widgets => map((child) => child.widget).toList();
}

/// Builds the live preview widget for a node.
/// [children] are the already built previews of the node's children.
typedef PreviewBuilder =
    Widget Function(
      BuildContext context,
      NodeProps props,
      List<PreviewChild> children,
    );
