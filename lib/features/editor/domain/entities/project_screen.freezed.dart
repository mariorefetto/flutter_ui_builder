// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_screen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectScreen {

 String get name; WidgetNode get root;
/// Create a copy of ProjectScreen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectScreenCopyWith<ProjectScreen> get copyWith => _$ProjectScreenCopyWithImpl<ProjectScreen>(this as ProjectScreen, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectScreen&&(identical(other.name, name) || other.name == name)&&(identical(other.root, root) || other.root == root));
}


@override
int get hashCode => Object.hash(runtimeType,name,root);

@override
String toString() {
  return 'ProjectScreen(name: $name, root: $root)';
}


}

/// @nodoc
abstract mixin class $ProjectScreenCopyWith<$Res>  {
  factory $ProjectScreenCopyWith(ProjectScreen value, $Res Function(ProjectScreen) _then) = _$ProjectScreenCopyWithImpl;
@useResult
$Res call({
 String name, WidgetNode root
});


$WidgetNodeCopyWith<$Res> get root;

}
/// @nodoc
class _$ProjectScreenCopyWithImpl<$Res>
    implements $ProjectScreenCopyWith<$Res> {
  _$ProjectScreenCopyWithImpl(this._self, this._then);

  final ProjectScreen _self;
  final $Res Function(ProjectScreen) _then;

/// Create a copy of ProjectScreen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? root = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNode,
  ));
}
/// Create a copy of ProjectScreen
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeCopyWith<$Res> get root {
  
  return $WidgetNodeCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectScreen].
extension ProjectScreenPatterns on ProjectScreen {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectScreen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectScreen() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectScreen value)  $default,){
final _that = this;
switch (_that) {
case _ProjectScreen():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectScreen value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectScreen() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  WidgetNode root)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectScreen() when $default != null:
return $default(_that.name,_that.root);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  WidgetNode root)  $default,) {final _that = this;
switch (_that) {
case _ProjectScreen():
return $default(_that.name,_that.root);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  WidgetNode root)?  $default,) {final _that = this;
switch (_that) {
case _ProjectScreen() when $default != null:
return $default(_that.name,_that.root);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectScreen implements ProjectScreen {
  const _ProjectScreen({required this.name, required this.root});
  

@override final  String name;
@override final  WidgetNode root;

/// Create a copy of ProjectScreen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectScreenCopyWith<_ProjectScreen> get copyWith => __$ProjectScreenCopyWithImpl<_ProjectScreen>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectScreen&&(identical(other.name, name) || other.name == name)&&(identical(other.root, root) || other.root == root));
}


@override
int get hashCode => Object.hash(runtimeType,name,root);

@override
String toString() {
  return 'ProjectScreen(name: $name, root: $root)';
}


}

/// @nodoc
abstract mixin class _$ProjectScreenCopyWith<$Res> implements $ProjectScreenCopyWith<$Res> {
  factory _$ProjectScreenCopyWith(_ProjectScreen value, $Res Function(_ProjectScreen) _then) = __$ProjectScreenCopyWithImpl;
@override @useResult
$Res call({
 String name, WidgetNode root
});


@override $WidgetNodeCopyWith<$Res> get root;

}
/// @nodoc
class __$ProjectScreenCopyWithImpl<$Res>
    implements _$ProjectScreenCopyWith<$Res> {
  __$ProjectScreenCopyWithImpl(this._self, this._then);

  final _ProjectScreen _self;
  final $Res Function(_ProjectScreen) _then;

/// Create a copy of ProjectScreen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? root = null,}) {
  return _then(_ProjectScreen(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNode,
  ));
}

/// Create a copy of ProjectScreen
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeCopyWith<$Res> get root {
  
  return $WidgetNodeCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}
}

// dart format on
