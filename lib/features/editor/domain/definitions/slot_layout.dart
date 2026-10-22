/// How a widget with named slots, such as Scaffold, places its children.
///
/// A child whose type is in [slots] fills the constructor argument it maps to,
/// once per argument. Any other child is the single body.
class SlotLayout {
  const SlotLayout({required this.slots, required this.bodyArgument});

  /// Child widget type to the constructor argument it is passed to.
  final Map<String, String> slots;

  /// Argument that receives the child which is not a slot widget.
  final String bodyArgument;

  /// Whether a [childType] child fits next to [siblingTypes].
  bool accepts(String childType, List<String> siblingTypes) {
    final argument = slots[childType];
    if (argument == null) return siblingTypes.every(slots.containsKey);
    return !siblingTypes.any((sibling) => slots[sibling] == argument);
  }
}
