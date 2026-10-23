// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'component_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComponentParam {

 String get name;/// What kind of value it is: a string, a number or a colour.
 PropType get type; Object get defaultValue;
/// Create a copy of ComponentParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComponentParamCopyWith<ComponentParam> get copyWith => _$ComponentParamCopyWithImpl<ComponentParam>(this as ComponentParam, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComponentParam&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue));
}


@override
int get hashCode => Object.hash(runtimeType,name,type,const DeepCollectionEquality().hash(defaultValue));

@override
String toString() {
  return 'ComponentParam(name: $name, type: $type, defaultValue: $defaultValue)';
}


}

/// @nodoc
abstract mixin class $ComponentParamCopyWith<$Res>  {
  factory $ComponentParamCopyWith(ComponentParam value, $Res Function(ComponentParam) _then) = _$ComponentParamCopyWithImpl;
@useResult
$Res call({
 String name, PropType type, Object defaultValue
});




}
/// @nodoc
class _$ComponentParamCopyWithImpl<$Res>
    implements $ComponentParamCopyWith<$Res> {
  _$ComponentParamCopyWithImpl(this._self, this._then);

  final ComponentParam _self;
  final $Res Function(ComponentParam) _then;

/// Create a copy of ComponentParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? defaultValue = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PropType,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue ,
  ));
}

}


/// Adds pattern-matching-related methods to [ComponentParam].
extension ComponentParamPatterns on ComponentParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComponentParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComponentParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComponentParam value)  $default,){
final _that = this;
switch (_that) {
case _ComponentParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComponentParam value)?  $default,){
final _that = this;
switch (_that) {
case _ComponentParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  PropType type,  Object defaultValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComponentParam() when $default != null:
return $default(_that.name,_that.type,_that.defaultValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  PropType type,  Object defaultValue)  $default,) {final _that = this;
switch (_that) {
case _ComponentParam():
return $default(_that.name,_that.type,_that.defaultValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  PropType type,  Object defaultValue)?  $default,) {final _that = this;
switch (_that) {
case _ComponentParam() when $default != null:
return $default(_that.name,_that.type,_that.defaultValue);case _:
  return null;

}
}

}

/// @nodoc


class _ComponentParam implements ComponentParam {
  const _ComponentParam({required this.name, required this.type, required this.defaultValue});
  

@override final  String name;
/// What kind of value it is: a string, a number or a colour.
@override final  PropType type;
@override final  Object defaultValue;

/// Create a copy of ComponentParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComponentParamCopyWith<_ComponentParam> get copyWith => __$ComponentParamCopyWithImpl<_ComponentParam>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComponentParam&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue));
}


@override
int get hashCode => Object.hash(runtimeType,name,type,const DeepCollectionEquality().hash(defaultValue));

@override
String toString() {
  return 'ComponentParam(name: $name, type: $type, defaultValue: $defaultValue)';
}


}

/// @nodoc
abstract mixin class _$ComponentParamCopyWith<$Res> implements $ComponentParamCopyWith<$Res> {
  factory _$ComponentParamCopyWith(_ComponentParam value, $Res Function(_ComponentParam) _then) = __$ComponentParamCopyWithImpl;
@override @useResult
$Res call({
 String name, PropType type, Object defaultValue
});




}
/// @nodoc
class __$ComponentParamCopyWithImpl<$Res>
    implements _$ComponentParamCopyWith<$Res> {
  __$ComponentParamCopyWithImpl(this._self, this._then);

  final _ComponentParam _self;
  final $Res Function(_ComponentParam) _then;

/// Create a copy of ComponentParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? defaultValue = null,}) {
  return _then(_ComponentParam(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PropType,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue ,
  ));
}


}

// dart format on
