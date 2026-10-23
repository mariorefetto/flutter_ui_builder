import 'package:flutter/widgets.dart';

/// The pictures of the project, so that an Image that names one can be drawn
/// from the file it was taken from: the designer has no asset bundle of the
/// project to read it from.
class MediaScope extends InheritedWidget {
  const MediaScope({required this.files, required super.child, super.key});

  /// The file on this computer behind each picture, by the name the code uses.
  final Map<String, String> files;

  /// The file behind the picture called [name], or null when there is none.
  static String? fileOf(BuildContext context, String name) =>
      context.dependOnInheritedWidgetOfExactType<MediaScope>()?.files[name];

  @override
  bool updateShouldNotify(MediaScope oldWidget) => files != oldWidget.files;
}
