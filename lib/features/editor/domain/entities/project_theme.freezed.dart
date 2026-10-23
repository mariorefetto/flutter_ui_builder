// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectTheme {

 Map<String, Map<String, Object?>> get parts;
/// Create a copy of ProjectTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectThemeCopyWith<ProjectTheme> get copyWith => _$ProjectThemeCopyWithImpl<ProjectTheme>(this as ProjectTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTheme&&const DeepCollectionEquality().equals(other.parts, parts));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(parts));

@override
String toString() {
  return 'ProjectTheme(parts: $parts)';
}


}

/// @nodoc
abstract mixin class $ProjectThemeCopyWith<$Res>  {
  factory $ProjectThemeCopyWith(ProjectTheme value, $Res Function(ProjectTheme) _then) = _$ProjectThemeCopyWithImpl;
@useResult
$Res call({
 Map<String, Map<String, Object?>> parts
});




}
/// @nodoc
class _$ProjectThemeCopyWithImpl<$Res>
    implements $ProjectThemeCopyWith<$Res> {
  _$ProjectThemeCopyWithImpl(this._self, this._then);

  final ProjectTheme _self;
  final $Res Function(ProjectTheme) _then;

/// Create a copy of ProjectTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parts = null,}) {
  return _then(_self.copyWith(
parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, Object?>>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTheme].
extension ProjectThemePatterns on ProjectTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTheme value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTheme value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, Map<String, Object?>> parts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTheme() when $default != null:
return $default(_that.parts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, Map<String, Object?>> parts)  $default,) {final _that = this;
switch (_that) {
case _ProjectTheme():
return $default(_that.parts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, Map<String, Object?>> parts)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTheme() when $default != null:
return $default(_that.parts);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectTheme extends ProjectTheme {
  const _ProjectTheme({final  Map<String, Map<String, Object?>> parts = const <String, Map<String, Object?>>{}}): _parts = parts,super._();
  

 final  Map<String, Map<String, Object?>> _parts;
@override@JsonKey() Map<String, Map<String, Object?>> get parts {
  if (_parts is EqualUnmodifiableMapView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parts);
}


/// Create a copy of ProjectTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectThemeCopyWith<_ProjectTheme> get copyWith => __$ProjectThemeCopyWithImpl<_ProjectTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTheme&&const DeepCollectionEquality().equals(other._parts, _parts));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_parts));

@override
String toString() {
  return 'ProjectTheme(parts: $parts)';
}


}

/// @nodoc
abstract mixin class _$ProjectThemeCopyWith<$Res> implements $ProjectThemeCopyWith<$Res> {
  factory _$ProjectThemeCopyWith(_ProjectTheme value, $Res Function(_ProjectTheme) _then) = __$ProjectThemeCopyWithImpl;
@override @useResult
$Res call({
 Map<String, Map<String, Object?>> parts
});




}
/// @nodoc
class __$ProjectThemeCopyWithImpl<$Res>
    implements _$ProjectThemeCopyWith<$Res> {
  __$ProjectThemeCopyWithImpl(this._self, this._then);

  final _ProjectTheme _self;
  final $Res Function(_ProjectTheme) _then;

/// Create a copy of ProjectTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parts = null,}) {
  return _then(_ProjectTheme(
parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, Object?>>,
  ));
}


}

// dart format on
