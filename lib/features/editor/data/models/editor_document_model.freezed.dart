// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_document_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditorDocumentModel {

 String get name; WidgetNodeModel get root; List<ProjectScreenModel> get screens; int get activeIndex; bool get component; List<Map<String, dynamic>> get params; List<MediaAssetModel> get assets; Map<String, dynamic> get theme; int get schemaVersion;
/// Create a copy of EditorDocumentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorDocumentModelCopyWith<EditorDocumentModel> get copyWith => _$EditorDocumentModelCopyWithImpl<EditorDocumentModel>(this as EditorDocumentModel, _$identity);

  /// Serializes this EditorDocumentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorDocumentModel&&(identical(other.name, name) || other.name == name)&&(identical(other.root, root) || other.root == root)&&const DeepCollectionEquality().equals(other.screens, screens)&&(identical(other.activeIndex, activeIndex) || other.activeIndex == activeIndex)&&(identical(other.component, component) || other.component == component)&&const DeepCollectionEquality().equals(other.params, params)&&const DeepCollectionEquality().equals(other.assets, assets)&&const DeepCollectionEquality().equals(other.theme, theme)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,root,const DeepCollectionEquality().hash(screens),activeIndex,component,const DeepCollectionEquality().hash(params),const DeepCollectionEquality().hash(assets),const DeepCollectionEquality().hash(theme),schemaVersion);

@override
String toString() {
  return 'EditorDocumentModel(name: $name, root: $root, screens: $screens, activeIndex: $activeIndex, component: $component, params: $params, assets: $assets, theme: $theme, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $EditorDocumentModelCopyWith<$Res>  {
  factory $EditorDocumentModelCopyWith(EditorDocumentModel value, $Res Function(EditorDocumentModel) _then) = _$EditorDocumentModelCopyWithImpl;
@useResult
$Res call({
 String name, WidgetNodeModel root, List<ProjectScreenModel> screens, int activeIndex, bool component, List<Map<String, dynamic>> params, List<MediaAssetModel> assets, Map<String, dynamic> theme, int schemaVersion
});


$WidgetNodeModelCopyWith<$Res> get root;

}
/// @nodoc
class _$EditorDocumentModelCopyWithImpl<$Res>
    implements $EditorDocumentModelCopyWith<$Res> {
  _$EditorDocumentModelCopyWithImpl(this._self, this._then);

  final EditorDocumentModel _self;
  final $Res Function(EditorDocumentModel) _then;

/// Create a copy of EditorDocumentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? root = null,Object? screens = null,Object? activeIndex = null,Object? component = null,Object? params = null,Object? assets = null,Object? theme = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNodeModel,screens: null == screens ? _self.screens : screens // ignore: cast_nullable_to_non_nullable
as List<ProjectScreenModel>,activeIndex: null == activeIndex ? _self.activeIndex : activeIndex // ignore: cast_nullable_to_non_nullable
as int,component: null == component ? _self.component : component // ignore: cast_nullable_to_non_nullable
as bool,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as List<MediaAssetModel>,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of EditorDocumentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeModelCopyWith<$Res> get root {
  
  return $WidgetNodeModelCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditorDocumentModel].
extension EditorDocumentModelPatterns on EditorDocumentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorDocumentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorDocumentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorDocumentModel value)  $default,){
final _that = this;
switch (_that) {
case _EditorDocumentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorDocumentModel value)?  $default,){
final _that = this;
switch (_that) {
case _EditorDocumentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  WidgetNodeModel root,  List<ProjectScreenModel> screens,  int activeIndex,  bool component,  List<Map<String, dynamic>> params,  List<MediaAssetModel> assets,  Map<String, dynamic> theme,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorDocumentModel() when $default != null:
return $default(_that.name,_that.root,_that.screens,_that.activeIndex,_that.component,_that.params,_that.assets,_that.theme,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  WidgetNodeModel root,  List<ProjectScreenModel> screens,  int activeIndex,  bool component,  List<Map<String, dynamic>> params,  List<MediaAssetModel> assets,  Map<String, dynamic> theme,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _EditorDocumentModel():
return $default(_that.name,_that.root,_that.screens,_that.activeIndex,_that.component,_that.params,_that.assets,_that.theme,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  WidgetNodeModel root,  List<ProjectScreenModel> screens,  int activeIndex,  bool component,  List<Map<String, dynamic>> params,  List<MediaAssetModel> assets,  Map<String, dynamic> theme,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _EditorDocumentModel() when $default != null:
return $default(_that.name,_that.root,_that.screens,_that.activeIndex,_that.component,_that.params,_that.assets,_that.theme,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, checked: true)
class _EditorDocumentModel extends EditorDocumentModel {
  const _EditorDocumentModel({required this.name, required this.root, final  List<ProjectScreenModel> screens = const <ProjectScreenModel>[], this.activeIndex = 0, this.component = false, final  List<Map<String, dynamic>> params = const <Map<String, dynamic>>[], final  List<MediaAssetModel> assets = const <MediaAssetModel>[], final  Map<String, dynamic> theme = const <String, dynamic>{}, this.schemaVersion = currentSchemaVersion}): _screens = screens,_params = params,_assets = assets,_theme = theme,super._();
  factory _EditorDocumentModel.fromJson(Map<String, dynamic> json) => _$EditorDocumentModelFromJson(json);

@override final  String name;
@override final  WidgetNodeModel root;
 final  List<ProjectScreenModel> _screens;
@override@JsonKey() List<ProjectScreenModel> get screens {
  if (_screens is EqualUnmodifiableListView) return _screens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_screens);
}

@override@JsonKey() final  int activeIndex;
@override@JsonKey() final  bool component;
 final  List<Map<String, dynamic>> _params;
@override@JsonKey() List<Map<String, dynamic>> get params {
  if (_params is EqualUnmodifiableListView) return _params;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_params);
}

 final  List<MediaAssetModel> _assets;
@override@JsonKey() List<MediaAssetModel> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

 final  Map<String, dynamic> _theme;
@override@JsonKey() Map<String, dynamic> get theme {
  if (_theme is EqualUnmodifiableMapView) return _theme;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_theme);
}

@override@JsonKey() final  int schemaVersion;

/// Create a copy of EditorDocumentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorDocumentModelCopyWith<_EditorDocumentModel> get copyWith => __$EditorDocumentModelCopyWithImpl<_EditorDocumentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditorDocumentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorDocumentModel&&(identical(other.name, name) || other.name == name)&&(identical(other.root, root) || other.root == root)&&const DeepCollectionEquality().equals(other._screens, _screens)&&(identical(other.activeIndex, activeIndex) || other.activeIndex == activeIndex)&&(identical(other.component, component) || other.component == component)&&const DeepCollectionEquality().equals(other._params, _params)&&const DeepCollectionEquality().equals(other._assets, _assets)&&const DeepCollectionEquality().equals(other._theme, _theme)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,root,const DeepCollectionEquality().hash(_screens),activeIndex,component,const DeepCollectionEquality().hash(_params),const DeepCollectionEquality().hash(_assets),const DeepCollectionEquality().hash(_theme),schemaVersion);

@override
String toString() {
  return 'EditorDocumentModel(name: $name, root: $root, screens: $screens, activeIndex: $activeIndex, component: $component, params: $params, assets: $assets, theme: $theme, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$EditorDocumentModelCopyWith<$Res> implements $EditorDocumentModelCopyWith<$Res> {
  factory _$EditorDocumentModelCopyWith(_EditorDocumentModel value, $Res Function(_EditorDocumentModel) _then) = __$EditorDocumentModelCopyWithImpl;
@override @useResult
$Res call({
 String name, WidgetNodeModel root, List<ProjectScreenModel> screens, int activeIndex, bool component, List<Map<String, dynamic>> params, List<MediaAssetModel> assets, Map<String, dynamic> theme, int schemaVersion
});


@override $WidgetNodeModelCopyWith<$Res> get root;

}
/// @nodoc
class __$EditorDocumentModelCopyWithImpl<$Res>
    implements _$EditorDocumentModelCopyWith<$Res> {
  __$EditorDocumentModelCopyWithImpl(this._self, this._then);

  final _EditorDocumentModel _self;
  final $Res Function(_EditorDocumentModel) _then;

/// Create a copy of EditorDocumentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? root = null,Object? screens = null,Object? activeIndex = null,Object? component = null,Object? params = null,Object? assets = null,Object? theme = null,Object? schemaVersion = null,}) {
  return _then(_EditorDocumentModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNodeModel,screens: null == screens ? _self._screens : screens // ignore: cast_nullable_to_non_nullable
as List<ProjectScreenModel>,activeIndex: null == activeIndex ? _self.activeIndex : activeIndex // ignore: cast_nullable_to_non_nullable
as int,component: null == component ? _self.component : component // ignore: cast_nullable_to_non_nullable
as bool,params: null == params ? _self._params : params // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<MediaAssetModel>,theme: null == theme ? _self._theme : theme // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of EditorDocumentModel
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
