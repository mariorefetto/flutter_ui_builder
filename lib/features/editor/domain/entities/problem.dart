/// How serious a problem is.
enum ProblemSeverity { warning, info }

/// The kind of problem, so the interface can word it in the user's language.
enum ProblemCode {
  navigationBarFewDestinations,
  hiddenTextMultiline,
  avatarRadiusConflict,
  positionedOverconstrained,
  imageWithoutLabel,
  imageWithoutUrl,
  requiredChildMissing,
  sliderRange,
  threeLineWithoutSubtitle,
  missingTooltip,
  circleWithRadius,
  lowContrast,
  smallTapTarget,
}

/// Something in the document that will misbehave or be hard to use, found
/// without running it.
class Problem {
  const Problem({
    required this.nodeId,
    required this.nodeType,
    required this.code,
    required this.severity,
  });

  final String nodeId;
  final String nodeType;
  final ProblemCode code;
  final ProblemSeverity severity;

  @override
  bool operator ==(Object other) =>
      other is Problem &&
      other.nodeId == nodeId &&
      other.nodeType == nodeType &&
      other.code == code &&
      other.severity == severity;

  @override
  int get hashCode => Object.hash(nodeId, nodeType, code, severity);
}
