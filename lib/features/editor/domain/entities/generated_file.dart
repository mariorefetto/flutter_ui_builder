/// A source file produced by the code generator.
class GeneratedFile {
  const GeneratedFile({required this.fileName, required this.content});

  final String fileName;
  final String content;

  @override
  bool operator ==(Object other) =>
      other is GeneratedFile &&
      other.fileName == fileName &&
      other.content == content;

  @override
  int get hashCode => Object.hash(fileName, content);
}
