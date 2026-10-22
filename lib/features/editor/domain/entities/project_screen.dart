import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_screen.freezed.dart';

/// A screen of the project that is not the one being edited.
@freezed
abstract class ProjectScreen with _$ProjectScreen {
  const factory ProjectScreen({
    required String name,
    required WidgetNode root,
  }) = _ProjectScreen;
}
