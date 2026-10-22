// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'problems_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProblemsState {

 List<Problem> get problems;
/// Create a copy of ProblemsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProblemsStateCopyWith<ProblemsState> get copyWith => _$ProblemsStateCopyWithImpl<ProblemsState>(this as ProblemsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProblemsState&&const DeepCollectionEquality().equals(other.problems, problems));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(problems));

@override
String toString() {
  return 'ProblemsState(problems: $problems)';
}


}

/// @nodoc
abstract mixin class $ProblemsStateCopyWith<$Res>  {
  factory $ProblemsStateCopyWith(ProblemsState value, $Res Function(ProblemsState) _then) = _$ProblemsStateCopyWithImpl;
@useResult
$Res call({
 List<Problem> problems
});




}
/// @nodoc
class _$ProblemsStateCopyWithImpl<$Res>
    implements $ProblemsStateCopyWith<$Res> {
  _$ProblemsStateCopyWithImpl(this._self, this._then);

  final ProblemsState _self;
  final $Res Function(ProblemsState) _then;

/// Create a copy of ProblemsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? problems = null,}) {
  return _then(_self.copyWith(
problems: null == problems ? _self.problems : problems // ignore: cast_nullable_to_non_nullable
as List<Problem>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProblemsState].
extension ProblemsStatePatterns on ProblemsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProblemsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProblemsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProblemsState value)  $default,){
final _that = this;
switch (_that) {
case _ProblemsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProblemsState value)?  $default,){
final _that = this;
switch (_that) {
case _ProblemsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Problem> problems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProblemsState() when $default != null:
return $default(_that.problems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Problem> problems)  $default,) {final _that = this;
switch (_that) {
case _ProblemsState():
return $default(_that.problems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Problem> problems)?  $default,) {final _that = this;
switch (_that) {
case _ProblemsState() when $default != null:
return $default(_that.problems);case _:
  return null;

}
}

}

/// @nodoc


class _ProblemsState extends ProblemsState {
  const _ProblemsState({final  List<Problem> problems = const <Problem>[]}): _problems = problems,super._();
  

 final  List<Problem> _problems;
@override@JsonKey() List<Problem> get problems {
  if (_problems is EqualUnmodifiableListView) return _problems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_problems);
}


/// Create a copy of ProblemsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProblemsStateCopyWith<_ProblemsState> get copyWith => __$ProblemsStateCopyWithImpl<_ProblemsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProblemsState&&const DeepCollectionEquality().equals(other._problems, _problems));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_problems));

@override
String toString() {
  return 'ProblemsState(problems: $problems)';
}


}

/// @nodoc
abstract mixin class _$ProblemsStateCopyWith<$Res> implements $ProblemsStateCopyWith<$Res> {
  factory _$ProblemsStateCopyWith(_ProblemsState value, $Res Function(_ProblemsState) _then) = __$ProblemsStateCopyWithImpl;
@override @useResult
$Res call({
 List<Problem> problems
});




}
/// @nodoc
class __$ProblemsStateCopyWithImpl<$Res>
    implements _$ProblemsStateCopyWith<$Res> {
  __$ProblemsStateCopyWithImpl(this._self, this._then);

  final _ProblemsState _self;
  final $Res Function(_ProblemsState) _then;

/// Create a copy of ProblemsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? problems = null,}) {
  return _then(_ProblemsState(
problems: null == problems ? _self._problems : problems // ignore: cast_nullable_to_non_nullable
as List<Problem>,
  ));
}


}

// dart format on
