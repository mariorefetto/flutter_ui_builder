import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'component_param.freezed.dart';

/// A value a component takes from where it is used, such as the text of a
/// card. Inside the component some property is bound to it; each use gives
/// its own value, or leaves the [defaultValue].
@freezed
abstract class ComponentParam with _$ComponentParam {
  const factory ComponentParam({
    required String name,

    /// What kind of value it is: a string, a number or a colour.
    required PropType type,
    required Object defaultValue,
  }) = _ComponentParam;
}
