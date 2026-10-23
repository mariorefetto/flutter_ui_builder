/// Expected outcome of an operation that did not succeed. Travels as the left
/// side of an Either; the UI turns it into text through messageFor.
sealed class Failure {
  const Failure(this.message);

  /// Developer facing detail, used for logs only.
  final String message;

  @override
  bool operator ==(Object other) =>
      other is Failure &&
      other.runtimeType == runtimeType &&
      other.message == message;

  @override
  int get hashCode => Object.hash(runtimeType, message);
}

/// Why an operation on the widget tree or on the history was refused.
enum TreeFailureReason {
  unknownNode,
  unknownParent,
  unknownType,
  unknownProp,
  invalidValue,
  childNotAllowed,
  parentFull,
  parentNotAllowed,
  slotTaken,
  ancestorRequired,
  rootNotAllowed,
  noChildren,
  invalidIndex,
  rootProtected,
  cyclicMove,
  notSiblings,
  nothingToUndo,
  nothingToRedo,
}

final class TreeFailure extends Failure {
  const TreeFailure(this.reason, [super.message = 'Tree operation refused']);

  final TreeFailureReason reason;

  @override
  bool operator ==(Object other) =>
      super == other && other is TreeFailure && other.reason == reason;

  @override
  int get hashCode => Object.hash(super.hashCode, reason);
}

enum StorageFailureReason {
  /// The file system refused the read or write.
  access,

  /// The target file exists but was not produced by the code generator.
  notGenerated,

  /// A picture to copy would replace a different file of the same name.
  assetConflict,

  /// A picture to copy is no longer where it was taken from.
  assetMissing,
}

final class StorageFailure extends Failure {
  const StorageFailure(
    this.reason, [
    super.message = 'Storage operation failed',
  ]);

  final StorageFailureReason reason;

  @override
  bool operator ==(Object other) =>
      super == other && other is StorageFailure && other.reason == reason;

  @override
  int get hashCode => Object.hash(super.hashCode, reason);
}

/// The generated source could not be formatted, which means it is not valid
/// Dart. This points at a widget definition that writes wrong code.
final class CodeGenerationFailure extends Failure {
  const CodeGenerationFailure([super.message = 'Code generation failed']);
}

/// A request to another computer did not go through: no connection, no answer
/// in time, or an answer that cannot be understood.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network request failed']);
}

/// The system could not open a link in the browser.
final class LaunchFailure extends Failure {
  const LaunchFailure([super.message = 'Could not open the link']);
}

enum DocumentFailureReason {
  /// The file is not a document written by this app.
  invalidFormat,

  /// The file was written by a newer version of the app.
  unsupportedVersion,

  /// The document uses a widget type that is not registered.
  unknownWidget,

  /// The tree breaks a rule, such as a duplicate id or too many children.
  invalidStructure,

  emptyName,

  /// Another screen already has the name, or one that writes the same class.
  duplicateScreenName,

  /// A project needs at least one screen.
  lastScreen,

  /// No screen has the name.
  unknownScreen,

  /// A property cannot be bound to a parameter, or the name is not one.
  invalidParameter,

  /// Pasted code that is not valid Dart.
  codeSyntax,

  /// Pasted code with no widget in it.
  codeNoWidget,
}

final class DocumentFailure extends Failure {
  const DocumentFailure(this.reason, [super.message = 'Invalid document']);

  final DocumentFailureReason reason;

  @override
  bool operator ==(Object other) =>
      super == other && other is DocumentFailure && other.reason == reason;

  @override
  int get hashCode => Object.hash(super.hashCode, reason);
}
