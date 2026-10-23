/// A version of the app as semver writes it: `1.2.3`, with a pre-release part
/// (`1.2.3-beta.1`) that makes it older than the same number without one.
class AppVersion implements Comparable<AppVersion> {
  const AppVersion(
    this.major,
    this.minor,
    this.patch, [
    this.preRelease = const [],
  ]);

  static final RegExp _pattern = RegExp(
    r'^v?(\d+)\.(\d+)\.(\d+)(?:-([0-9A-Za-z.-]+))?(?:\+[0-9A-Za-z.-]+)?$',
  );

  /// Reads `1.2.3`, `v1.2.3`, `1.2.3-beta.1` or `1.2.3+4`; null for anything
  /// else, such as a tag that is not a version.
  static AppVersion? tryParse(String text) {
    final match = _pattern.firstMatch(text.trim());
    if (match == null) return null;
    return AppVersion(
      int.parse(match[1]!),
      int.parse(match[2]!),
      int.parse(match[3]!),
      match[4]?.split('.') ?? const [],
    );
  }

  final int major;
  final int minor;
  final int patch;

  /// The dot separated parts after the dash, empty for a stable version.
  final List<String> preRelease;

  bool get isPreRelease => preRelease.isNotEmpty;

  bool isNewerThan(AppVersion other) => compareTo(other) > 0;

  @override
  int compareTo(AppVersion other) {
    final core = [
      major.compareTo(other.major),
      minor.compareTo(other.minor),
      patch.compareTo(other.patch),
    ].firstWhere((order) => order != 0, orElse: () => 0);
    if (core != 0) return core;
    // A version without a pre-release part comes after one with it.
    if (preRelease.isEmpty || other.preRelease.isEmpty) {
      return other.preRelease.length.compareTo(preRelease.length);
    }
    for (var i = 0; i < preRelease.length && i < other.preRelease.length; i++) {
      final order = _comparePart(preRelease[i], other.preRelease[i]);
      if (order != 0) return order;
    }
    return preRelease.length.compareTo(other.preRelease.length);
  }

  // Numbers compare as numbers and come before words.
  static int _comparePart(String a, String b) {
    final x = int.tryParse(a);
    final y = int.tryParse(b);
    if (x != null && y != null) return x.compareTo(y);
    if (x != null) return -1;
    if (y != null) return 1;
    return a.compareTo(b);
  }

  @override
  bool operator ==(Object other) =>
      other is AppVersion && compareTo(other) == 0;

  @override
  int get hashCode => Object.hash(major, minor, patch, preRelease.join('.'));

  @override
  String toString() =>
      '$major.$minor.$patch${isPreRelease ? '-${preRelease.join('.')}' : ''}';
}
