/// What is being dragged: a new widget from the palette or an existing node.
sealed class DragPayload {
  const DragPayload();
}

final class NewWidgetPayload extends DragPayload {
  const NewWidgetPayload(this.type);

  final String type;
}

final class MoveNodePayload extends DragPayload {
  const MoveNodePayload(this.nodeId);

  final String nodeId;
}
