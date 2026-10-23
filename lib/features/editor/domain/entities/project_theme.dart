import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_theme.freezed.dart';

/// The theme of the designed app: the values chosen for each part of it, by
/// the part's name. A part or a value that is not here is the one Flutter has
/// by default, so a new project has an empty theme.
@freezed
abstract class ProjectTheme with _$ProjectTheme {
  const factory ProjectTheme({
    @Default(<String, Map<String, Object?>>{})
    Map<String, Map<String, Object?>> parts,
  }) = _ProjectTheme;

  const ProjectTheme._();

  /// Whether nothing was changed from the defaults.
  bool get isDefault => parts.values.every((values) => values.isEmpty);

  /// The values of the part [name] with the defaults of [schemas] applied. A
  /// stored value of the wrong type is ignored in favour of the default.
  NodeProps valuesOf(String name, List<PropSchema> schemas) {
    final stored = parts[name] ?? const <String, Object?>{};
    return NodeProps({
      for (final schema in schemas)
        schema.name: schema.accepts(stored[schema.name])
            ? stored[schema.name]
            : schema.defaultValue,
    });
  }
}
