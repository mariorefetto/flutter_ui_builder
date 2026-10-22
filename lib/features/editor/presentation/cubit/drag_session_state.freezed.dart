// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drag_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DragSessionState {

/// Id of the node being moved, or null for a new widget from the toolbox
/// or when nothing is dragged.
 String? get draggedId;/// A drag is in progress, whatever it carries.
 bool get active;/// The node the pointer is over and that would accept the drop.
 String? get targetId;
/// Create a copy of DragSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DragSessionStateCopyWith<DragSessionState> get copyWith => _$DragSessionStateCopyWithImpl<DragSessionState>(this as DragSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DragSessionState&&(identical(other.draggedId, draggedId) || other.draggedId == draggedId)&&(identical(other.active, active) || other.active == active)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}


@override
int get hashCode => Object.hash(runtimeType,draggedId,active,targetId);

@override
String toString() {
  return 'DragSessionState(draggedId: $draggedId, active: $active, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class $DragSessionStateCopyWith<$Res>  {
  factory $DragSessionStateCopyWith(DragSessionState value, $Res Function(DragSessionState) _then) = _$DragSessionStateCopyWithImpl;
@useResult
$Res call({
 String? draggedId, bool active, String? targetId
});




}
/// @nodoc
class _$DragSessionStateCopyWithImpl<$Res>
    implements $DragSessionStateCopyWith<$Res> {
  _$DragSessionStateCopyWithImpl(this._self, this._then);

  final DragSessionState _self;
  final $Res Function(DragSessionState) _then;

/// Create a copy of DragSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? draggedId = freezed,Object? active = null,Object? targetId = freezed,}) {
  return _then(_self.copyWith(
draggedId: freezed == draggedId ? _self.draggedId : draggedId // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DragSessionState].
extension DragSessionStatePatterns on DragSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DragSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DragSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DragSessionState value)  $default,){
final _that = this;
switch (_that) {
case _DragSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DragSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _DragSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? draggedId,  bool active,  String? targetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DragSessionState() when $default != null:
return $default(_that.draggedId,_that.active,_that.targetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? draggedId,  bool active,  String? targetId)  $default,) {final _that = this;
switch (_that) {
case _DragSessionState():
return $default(_that.draggedId,_that.active,_that.targetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? draggedId,  bool active,  String? targetId)?  $default,) {final _that = this;
switch (_that) {
case _DragSessionState() when $default != null:
return $default(_that.draggedId,_that.active,_that.targetId);case _:
  return null;

}
}

}

/// @nodoc


class _DragSessionState implements DragSessionState {
  const _DragSessionState({this.draggedId, this.active = false, this.targetId});
  

/// Id of the node being moved, or null for a new widget from the toolbox
/// or when nothing is dragged.
@override final  String? draggedId;
/// A drag is in progress, whatever it carries.
@override@JsonKey() final  bool active;
/// The node the pointer is over and that would accept the drop.
@override final  String? targetId;

/// Create a copy of DragSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DragSessionStateCopyWith<_DragSessionState> get copyWith => __$DragSessionStateCopyWithImpl<_DragSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DragSessionState&&(identical(other.draggedId, draggedId) || other.draggedId == draggedId)&&(identical(other.active, active) || other.active == active)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}


@override
int get hashCode => Object.hash(runtimeType,draggedId,active,targetId);

@override
String toString() {
  return 'DragSessionState(draggedId: $draggedId, active: $active, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class _$DragSessionStateCopyWith<$Res> implements $DragSessionStateCopyWith<$Res> {
  factory _$DragSessionStateCopyWith(_DragSessionState value, $Res Function(_DragSessionState) _then) = __$DragSessionStateCopyWithImpl;
@override @useResult
$Res call({
 String? draggedId, bool active, String? targetId
});




}
/// @nodoc
class __$DragSessionStateCopyWithImpl<$Res>
    implements _$DragSessionStateCopyWith<$Res> {
  __$DragSessionStateCopyWithImpl(this._self, this._then);

  final _DragSessionState _self;
  final $Res Function(_DragSessionState) _then;

/// Create a copy of DragSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? draggedId = freezed,Object? active = null,Object? targetId = freezed,}) {
  return _then(_DragSessionState(
draggedId: freezed == draggedId ? _self.draggedId : draggedId // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
