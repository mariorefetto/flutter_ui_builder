import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_node.freezed.dart';

/// A single node of the UI tree edited by the builder.
///
/// This model is the single source of truth: the canvas edits it, the preview
/// interprets it and the code generator turns it into Dart code.
@freezed
abstract class WidgetNode with _$WidgetNode {
  const factory WidgetNode({
    /// Unique identifier of the node inside the document.
    required String id,

    /// Key of the matching WidgetDefinition in the registry (e.g. "Text").
    required String type,

    /// Property values, keyed by PropSchema.name.
    /// Colors are ARGB ints, edge insets are [left, top, right, bottom].
    @Default(<String, Object?>{}) Map<String, Object?> props,

    /// A name the user gave this widget, shown in the outline. Optional, and
    /// not part of the generated code.
    String? label,

    /// Child nodes. The allowed number depends on the definition's ChildPolicy.
    @Default(<WidgetNode>[]) List<WidgetNode> children,
  }) = _WidgetNode;
}
