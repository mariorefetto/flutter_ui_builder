// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditorState {

 DocumentHistory get history;/// Id of the selected node, or null when nothing is selected.
 String? get selectedId;/// Widgets picked along with [selectedId] by clicking with Cmd, Ctrl or
/// Shift held. They are edited, copied and removed together.
 Set<String> get extraSelected;/// Set for one emission when the last user action was refused.
 Failure? get failure;/// A copied or cut subtree, waiting to be pasted. It is not part of the
/// document and is not undone.
 WidgetNode? get clipboard;
/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorStateCopyWith<EditorState> get copyWith => _$EditorStateCopyWithImpl<EditorState>(this as EditorState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EditorState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorState&&(identical(other.history, _this.history) || other.history == _this.history)&&(identical(other.selectedId, _this.selectedId) || other.selectedId == _this.selectedId)&&const DeepCollectionEquality().equals(other.extraSelected, _this.extraSelected)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.clipboard, _this.clipboard) || other.clipboard == _this.clipboard));
}


@override
int get hashCode {
  final _this = this as EditorState;
  return Object.hash(runtimeType,_this.history,_this.selectedId,const DeepCollectionEquality().hash(_this.extraSelected),_this.failure,_this.clipboard);
}

@override
String toString() {
  final _this = this as EditorState;
  return 'EditorState(history: ${_this.history}, selectedId: ${_this.selectedId}, extraSelected: ${_this.extraSelected}, failure: ${_this.failure}, clipboard: ${_this.clipboard})';
}


}

/// @nodoc
abstract mixin class $EditorStateCopyWith<$Res>  {
  factory $EditorStateCopyWith(EditorState value, $Res Function(EditorState) _then) = _$EditorStateCopyWithImpl;
@useResult
$Res call({
 DocumentHistory history, String? selectedId, Set<String> extraSelected, Failure? failure, WidgetNode? clipboard
});


$DocumentHistoryCopyWith<$Res> get history;$WidgetNodeCopyWith<$Res>? get clipboard;

}
/// @nodoc
class _$EditorStateCopyWithImpl<$Res>
    implements $EditorStateCopyWith<$Res> {
  _$EditorStateCopyWithImpl(this._self, this._then);

  final EditorState _self;
  final $Res Function(EditorState) _then;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? history = null,Object? selectedId = freezed,Object? extraSelected = null,Object? failure = freezed,Object? clipboard = freezed,}) {
  return _then(EditorState(
history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as DocumentHistory,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,extraSelected: null == extraSelected ? _self.extraSelected : extraSelected // ignore: cast_nullable_to_non_nullable
as Set<String>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,clipboard: freezed == clipboard ? _self.clipboard : clipboard // ignore: cast_nullable_to_non_nullable
as WidgetNode?,
  ));
}
/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DocumentHistoryCopyWith<$Res> get history {
  
  return $DocumentHistoryCopyWith<$Res>(_self.history, (value) {
    return _then(_self.copyWith(history: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeCopyWith<$Res>? get clipboard {
    if (_self.clipboard == null) {
    return null;
  }

  return $WidgetNodeCopyWith<$Res>(_self.clipboard!, (value) {
    return _then(_self.copyWith(clipboard: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditorState].
extension EditorStatePatterns on EditorState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorState value)  $default,){
final _that = this;
switch (_that) {
case _EditorState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorState value)?  $default,){
final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DocumentHistory history,  String? selectedId,  Set<String> extraSelected,  Failure? failure,  WidgetNode? clipboard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that.history,_that.selectedId,_that.extraSelected,_that.failure,_that.clipboard);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DocumentHistory history,  String? selectedId,  Set<String> extraSelected,  Failure? failure,  WidgetNode? clipboard)  $default,) {final _that = this;
switch (_that) {
case _EditorState():
return $default(_that.history,_that.selectedId,_that.extraSelected,_that.failure,_that.clipboard);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DocumentHistory history,  String? selectedId,  Set<String> extraSelected,  Failure? failure,  WidgetNode? clipboard)?  $default,) {final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that.history,_that.selectedId,_that.extraSelected,_that.failure,_that.clipboard);case _:
  return null;

}
}

}

/// @nodoc


class _EditorState extends EditorState {
  const _EditorState({required this.history, this.selectedId,  Set<String> extraSelected = const <String>{}, this.failure, this.clipboard}): _extraSelected = extraSelected,super._();
  

@override final  DocumentHistory history;
/// Id of the selected node, or null when nothing is selected.
@override final  String? selectedId;
/// Widgets picked along with [selectedId] by clicking with Cmd, Ctrl or
/// Shift held. They are edited, copied and removed together.
 final  Set<String> _extraSelected;
/// Widgets picked along with [selectedId] by clicking with Cmd, Ctrl or
/// Shift held. They are edited, copied and removed together.
@override@JsonKey() Set<String> get extraSelected {
  if (_extraSelected is EqualUnmodifiableSetView) return _extraSelected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_extraSelected);
}

/// Set for one emission when the last user action was refused.
@override final  Failure? failure;
/// A copied or cut subtree, waiting to be pasted. It is not part of the
/// document and is not undone.
@override final  WidgetNode? clipboard;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorStateCopyWith<_EditorState> get copyWith => __$EditorStateCopyWithImpl<_EditorState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorState&&(identical(other.history, history) || other.history == history)&&(identical(other.selectedId, selectedId) || other.selectedId == selectedId)&&const DeepCollectionEquality().equals(other.extraSelected, _extraSelected)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.clipboard, clipboard) || other.clipboard == clipboard));
}


@override
int get hashCode {
    return Object.hash(runtimeType,history,selectedId,const DeepCollectionEquality().hash(_extraSelected),failure,clipboard);
}

@override
String toString() {
    return 'EditorState(history: $history, selectedId: $selectedId, extraSelected: $extraSelected, failure: $failure, clipboard: $clipboard)';
}


}

/// @nodoc
abstract mixin class _$EditorStateCopyWith<$Res> implements $EditorStateCopyWith<$Res> {
  factory _$EditorStateCopyWith(_EditorState value, $Res Function(_EditorState) _then) = __$EditorStateCopyWithImpl;
@override @useResult
$Res call({
 DocumentHistory history, String? selectedId, Set<String> extraSelected, Failure? failure, WidgetNode? clipboard
});


@override $DocumentHistoryCopyWith<$Res> get history;@override $WidgetNodeCopyWith<$Res>? get clipboard;

}
/// @nodoc
class __$EditorStateCopyWithImpl<$Res>
    implements _$EditorStateCopyWith<$Res> {
  __$EditorStateCopyWithImpl(this._self, this._then);

  final _EditorState _self;
  final $Res Function(_EditorState) _then;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? history = null,Object? selectedId = freezed,Object? extraSelected = null,Object? failure = freezed,Object? clipboard = freezed,}) {
  return _then(_EditorState(
history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as DocumentHistory,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,extraSelected: null == extraSelected ? _self._extraSelected : extraSelected // ignore: cast_nullable_to_non_nullable
as Set<String>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,clipboard: freezed == clipboard ? _self.clipboard : clipboard // ignore: cast_nullable_to_non_nullable
as WidgetNode?,
  ));
}

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DocumentHistoryCopyWith<$Res> get history {
  
  return $DocumentHistoryCopyWith<$Res>(_self.history, (value) {
    return _then(_self.copyWith(history: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeCopyWith<$Res>? get clipboard {
    if (_self.clipboard == null) {
    return null;
  }

  return $WidgetNodeCopyWith<$Res>(_self.clipboard!, (value) {
    return _then(_self.copyWith(clipboard: value));
  });
}
}

// dart format on
