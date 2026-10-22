import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/edge_insets_value.dart';

/// Alignment constants addressable by the names in alignmentOptions.
const Map<String, Alignment> alignmentsByName = {
  'topLeft': Alignment.topLeft,
  'topCenter': Alignment.topCenter,
  'topRight': Alignment.topRight,
  'centerLeft': Alignment.centerLeft,
  'center': Alignment.center,
  'centerRight': Alignment.centerRight,
  'bottomLeft': Alignment.bottomLeft,
  'bottomCenter': Alignment.bottomCenter,
  'bottomRight': Alignment.bottomRight,
};

extension EdgeInsetsValueX on EdgeInsetsValue {
  EdgeInsets toEdgeInsets() => EdgeInsets.fromLTRB(left, top, right, bottom);
}
