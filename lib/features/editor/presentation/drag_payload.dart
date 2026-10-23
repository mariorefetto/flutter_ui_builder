/// What is being dragged: a new widget from the palette or an existing node.
sealed class DragPayload {
  const DragPayload();
}

final class NewWidgetPayload extends DragPayload {
  const NewWidgetPayload(this.type, {this.props = const {}});

  final String type;

  /// Values the new widget starts with, such as the component it shows.
  final Map<String, Object?> props;
}

final class MoveNodePayload extends DragPayload {
  const MoveNodePayload(this.nodeId);

  final String nodeId;
}
