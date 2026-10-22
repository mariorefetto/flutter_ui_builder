import 'package:freezed_annotation/freezed_annotation.dart';

part 'edge_insets_value.freezed.dart';

/// Number of values used to store edge insets in WidgetNode.props.
const int edgeInsetsLength = 4;

const int _leftIndex = 0;
const int _topIndex = 1;
const int _rightIndex = 2;
const int _bottomIndex = 3;

/// Pure Dart edge insets, stored in props as [left, top, right, bottom].
@freezed
abstract class EdgeInsetsValue with _$EdgeInsetsValue {
  const factory EdgeInsetsValue({
    required double left,
    required double top,
    required double right,
    required double bottom,
  }) = _EdgeInsetsValue;

  /// Reads the stored list form, or returns null when [raw] is malformed.
  static EdgeInsetsValue? tryParse(Object? raw) {
    if (raw is! List<Object?> || raw.length != edgeInsetsLength) return null;
    final values = raw.whereType<num>().map((v) => v.toDouble()).toList();
    if (values.length != edgeInsetsLength) return null;
    return EdgeInsetsValue(
      left: values[_leftIndex],
      top: values[_topIndex],
      right: values[_rightIndex],
      bottom: values[_bottomIndex],
    );
  }
}
