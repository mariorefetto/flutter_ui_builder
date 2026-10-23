// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_screen_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectScreenModel {

 String get name; WidgetNodeModel get root; bool get component; List<Map<String, dynamic>> get params;
/// Create a copy of ProjectScreenModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectScreenModelCopyWith<ProjectScreenModel> get copyWith => _$ProjectScreenModelCopyWithImpl<ProjectScreenModel>(this as ProjectScreenModel, _$identity);

  /// Serializes this ProjectScreenModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectScreenModel&&(identical(other.name, name) || other.name == name)&&(identical(other.root, root) || other.root == root)&&(identical(other.component, component) || other.component == component)&&const DeepCollectionEquality().equals(other.params, params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,root,component,const DeepCollectionEquality().hash(params));

@override
String toString() {
  return 'ProjectScreenModel(name: $name, root: $root, component: $component, params: $params)';
}


}

/// @nodoc
abstract mixin class $ProjectScreenModelCopyWith<$Res>  {
  factory $ProjectScreenModelCopyWith(ProjectScreenModel value, $Res Function(ProjectScreenModel) _then) = _$ProjectScreenModelCopyWithImpl;
@useResult
$Res call({
 String name, WidgetNodeModel root, bool component, List<Map<String, dynamic>> params
});


$WidgetNodeModelCopyWith<$Res> get root;

}
/// @nodoc
class _$ProjectScreenModelCopyWithImpl<$Res>
    implements $ProjectScreenModelCopyWith<$Res> {
  _$ProjectScreenModelCopyWithImpl(this._self, this._then);

  final ProjectScreenModel _self;
  final $Res Function(ProjectScreenModel) _then;

/// Create a copy of ProjectScreenModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? root = null,Object? component = null,Object? params = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNodeModel,component: null == component ? _self.component : component // ignore: cast_nullable_to_non_nullable
as bool,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}
/// Create a copy of ProjectScreenModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeModelCopyWith<$Res> get root {
  
  return $WidgetNodeModelCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectScreenModel].
extension ProjectScreenModelPatterns on ProjectScreenModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectScreenModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectScreenModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectScreenModel value)  $default,){
final _that = this;
switch (_that) {
case _ProjectScreenModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectScreenModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectScreenModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  WidgetNodeModel root,  bool component,  List<Map<String, dynamic>> params)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectScreenModel() when $default != null:
return $default(_that.name,_that.root,_that.component,_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  WidgetNodeModel root,  bool component,  List<Map<String, dynamic>> params)  $default,) {final _that = this;
switch (_that) {
case _ProjectScreenModel():
return $default(_that.name,_that.root,_that.component,_that.params);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  WidgetNodeModel root,  bool component,  List<Map<String, dynamic>> params)?  $default,) {final _that = this;
switch (_that) {
case _ProjectScreenModel() when $default != null:
return $default(_that.name,_that.root,_that.component,_that.params);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, checked: true)
class _ProjectScreenModel extends ProjectScreenModel {
  const _ProjectScreenModel({required this.name, required this.root, this.component = false, final  List<Map<String, dynamic>> params = const <Map<String, dynamic>>[]}): _params = params,super._();
  factory _ProjectScreenModel.fromJson(Map<String, dynamic> json) => _$ProjectScreenModelFromJson(json);

@override final  String name;
@override final  WidgetNodeModel root;
@override@JsonKey() final  bool component;
 final  List<Map<String, dynamic>> _params;
@override@JsonKey() List<Map<String, dynamic>> get params {
  if (_params is EqualUnmodifiableListView) return _params;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_params);
}


/// Create a copy of ProjectScreenModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectScreenModelCopyWith<_ProjectScreenModel> get copyWith => __$ProjectScreenModelCopyWithImpl<_ProjectScreenModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectScreenModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectScreenModel&&(identical(other.name, name) || other.name == name)&&(identical(other.root, root) || other.root == root)&&(identical(other.component, component) || other.component == component)&&const DeepCollectionEquality().equals(other._params, _params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,root,component,const DeepCollectionEquality().hash(_params));

@override
String toString() {
  return 'ProjectScreenModel(name: $name, root: $root, component: $component, params: $params)';
}


}

/// @nodoc
abstract mixin class _$ProjectScreenModelCopyWith<$Res> implements $ProjectScreenModelCopyWith<$Res> {
  factory _$ProjectScreenModelCopyWith(_ProjectScreenModel value, $Res Function(_ProjectScreenModel) _then) = __$ProjectScreenModelCopyWithImpl;
@override @useResult
$Res call({
 String name, WidgetNodeModel root, bool component, List<Map<String, dynamic>> params
});


@override $WidgetNodeModelCopyWith<$Res> get root;

}
/// @nodoc
class __$ProjectScreenModelCopyWithImpl<$Res>
    implements _$ProjectScreenModelCopyWith<$Res> {
  __$ProjectScreenModelCopyWithImpl(this._self, this._then);

  final _ProjectScreenModel _self;
  final $Res Function(_ProjectScreenModel) _then;

/// Create a copy of ProjectScreenModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? root = null,Object? component = null,Object? params = null,}) {
  return _then(_ProjectScreenModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNodeModel,component: null == component ? _self.component : component // ignore: cast_nullable_to_non_nullable
as bool,params: null == params ? _self._params : params // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}

/// Create a copy of ProjectScreenModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeModelCopyWith<$Res> get root {
  
  return $WidgetNodeModelCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}
}

// dart format on
