import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';

/// The text in a repeated widget that stands for the number of the copy:
/// "Item {n}" is "Item 1", "Item 2"... In code it is `${index + 1}`.
const String sampleNumberToken = '{n}';

/// The property of a list or grid that makes it repeat its first widget.
const String sampleCountProp = 'sampleCount';

/// The most copies the designer draws, so a count typed with a zero too many
/// does not freeze it.
const int maxSampleCopies = 50;

/// A copy of [node] for the item numbered [number], with the token replaced
/// in every text it holds.
WidgetNode withSampleNumber(WidgetNode node, int number) => node.copyWith(
  props: {
    for (final entry in node.props.entries)
      entry.key: entry.value is String
          ? (entry.value as String).replaceAll(sampleNumberToken, '$number')
          : entry.value,
  },
  children: [
    for (final child in node.children) withSampleNumber(child, number),
  ],
);

/// How many copies [node] asks for: its sample count, or null when it has
/// none or nothing to repeat.
int? sampleCountOf(WidgetNode node) {
  final value = node.props[sampleCountProp];
  if (value is! num || node.children.isEmpty || value < 1) return null;
  return value.round().clamp(1, maxSampleCopies);
}
