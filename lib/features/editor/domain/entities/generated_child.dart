/// The Dart source of an already generated child, with the type of the node
/// it came from. Parents such as Scaffold use the type to pick the slot.
class GeneratedChild {
  const GeneratedChild({required this.type, required this.code});

  final String type;
  final String code;
}
