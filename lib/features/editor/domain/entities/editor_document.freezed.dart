// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditorDocument {

 String get name; WidgetNode get root;/// The screens that are not open, in project order.
 List<ProjectScreen> get screens;/// Where the open screen sits among all of them.
 int get activeIndex;/// Whether the open one is a component rather than a screen.
 bool get component;/// The pictures of the project, shared by all its screens.
 List<MediaAsset> get assets;/// The theme of the designed app, shared by all its screens.
 ProjectTheme get theme; int get schemaVersion;
/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorDocumentCopyWith<EditorDocument> get copyWith => _$EditorDocumentCopyWithImpl<EditorDocument>(this as EditorDocument, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorDocument&&(identical(other.name, name) || other.name == name)&&(identical(other.root, root) || other.root == root)&&const DeepCollectionEquality().equals(other.screens, screens)&&(identical(other.activeIndex, activeIndex) || other.activeIndex == activeIndex)&&(identical(other.component, component) || other.component == component)&&const DeepCollectionEquality().equals(other.assets, assets)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}


@override
int get hashCode => Object.hash(runtimeType,name,root,const DeepCollectionEquality().hash(screens),activeIndex,component,const DeepCollectionEquality().hash(assets),theme,schemaVersion);

@override
String toString() {
  return 'EditorDocument(name: $name, root: $root, screens: $screens, activeIndex: $activeIndex, component: $component, assets: $assets, theme: $theme, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $EditorDocumentCopyWith<$Res>  {
  factory $EditorDocumentCopyWith(EditorDocument value, $Res Function(EditorDocument) _then) = _$EditorDocumentCopyWithImpl;
@useResult
$Res call({
 String name, WidgetNode root, List<ProjectScreen> screens, int activeIndex, bool component, List<MediaAsset> assets, ProjectTheme theme, int schemaVersion
});


$WidgetNodeCopyWith<$Res> get root;$ProjectThemeCopyWith<$Res> get theme;

}
/// @nodoc
class _$EditorDocumentCopyWithImpl<$Res>
    implements $EditorDocumentCopyWith<$Res> {
  _$EditorDocumentCopyWithImpl(this._self, this._then);

  final EditorDocument _self;
  final $Res Function(EditorDocument) _then;

/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? root = null,Object? screens = null,Object? activeIndex = null,Object? component = null,Object? assets = null,Object? theme = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNode,screens: null == screens ? _self.screens : screens // ignore: cast_nullable_to_non_nullable
as List<ProjectScreen>,activeIndex: null == activeIndex ? _self.activeIndex : activeIndex // ignore: cast_nullable_to_non_nullable
as int,component: null == component ? _self.component : component // ignore: cast_nullable_to_non_nullable
as bool,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as List<MediaAsset>,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ProjectTheme,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeCopyWith<$Res> get root {
  
  return $WidgetNodeCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectThemeCopyWith<$Res> get theme {
  
  return $ProjectThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditorDocument].
extension EditorDocumentPatterns on EditorDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorDocument value)  $default,){
final _that = this;
switch (_that) {
case _EditorDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorDocument value)?  $default,){
final _that = this;
switch (_that) {
case _EditorDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  WidgetNode root,  List<ProjectScreen> screens,  int activeIndex,  bool component,  List<MediaAsset> assets,  ProjectTheme theme,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorDocument() when $default != null:
return $default(_that.name,_that.root,_that.screens,_that.activeIndex,_that.component,_that.assets,_that.theme,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  WidgetNode root,  List<ProjectScreen> screens,  int activeIndex,  bool component,  List<MediaAsset> assets,  ProjectTheme theme,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _EditorDocument():
return $default(_that.name,_that.root,_that.screens,_that.activeIndex,_that.component,_that.assets,_that.theme,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  WidgetNode root,  List<ProjectScreen> screens,  int activeIndex,  bool component,  List<MediaAsset> assets,  ProjectTheme theme,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _EditorDocument() when $default != null:
return $default(_that.name,_that.root,_that.screens,_that.activeIndex,_that.component,_that.assets,_that.theme,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc


class _EditorDocument implements EditorDocument {
  const _EditorDocument({required this.name, required this.root, final  List<ProjectScreen> screens = const <ProjectScreen>[], this.activeIndex = 0, this.component = false, final  List<MediaAsset> assets = const <MediaAsset>[], this.theme = const ProjectTheme(), this.schemaVersion = currentSchemaVersion}): _screens = screens,_assets = assets;
  

@override final  String name;
@override final  WidgetNode root;
/// The screens that are not open, in project order.
 final  List<ProjectScreen> _screens;
/// The screens that are not open, in project order.
@override@JsonKey() List<ProjectScreen> get screens {
  if (_screens is EqualUnmodifiableListView) return _screens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_screens);
}

/// Where the open screen sits among all of them.
@override@JsonKey() final  int activeIndex;
/// Whether the open one is a component rather than a screen.
@override@JsonKey() final  bool component;
/// The pictures of the project, shared by all its screens.
 final  List<MediaAsset> _assets;
/// The pictures of the project, shared by all its screens.
@override@JsonKey() List<MediaAsset> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

/// The theme of the designed app, shared by all its screens.
@override@JsonKey() final  ProjectTheme theme;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorDocumentCopyWith<_EditorDocument> get copyWith => __$EditorDocumentCopyWithImpl<_EditorDocument>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorDocument&&(identical(other.name, name) || other.name == name)&&(identical(other.root, root) || other.root == root)&&const DeepCollectionEquality().equals(other._screens, _screens)&&(identical(other.activeIndex, activeIndex) || other.activeIndex == activeIndex)&&(identical(other.component, component) || other.component == component)&&const DeepCollectionEquality().equals(other._assets, _assets)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}


@override
int get hashCode => Object.hash(runtimeType,name,root,const DeepCollectionEquality().hash(_screens),activeIndex,component,const DeepCollectionEquality().hash(_assets),theme,schemaVersion);

@override
String toString() {
  return 'EditorDocument(name: $name, root: $root, screens: $screens, activeIndex: $activeIndex, component: $component, assets: $assets, theme: $theme, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$EditorDocumentCopyWith<$Res> implements $EditorDocumentCopyWith<$Res> {
  factory _$EditorDocumentCopyWith(_EditorDocument value, $Res Function(_EditorDocument) _then) = __$EditorDocumentCopyWithImpl;
@override @useResult
$Res call({
 String name, WidgetNode root, List<ProjectScreen> screens, int activeIndex, bool component, List<MediaAsset> assets, ProjectTheme theme, int schemaVersion
});


@override $WidgetNodeCopyWith<$Res> get root;@override $ProjectThemeCopyWith<$Res> get theme;

}
/// @nodoc
class __$EditorDocumentCopyWithImpl<$Res>
    implements _$EditorDocumentCopyWith<$Res> {
  __$EditorDocumentCopyWithImpl(this._self, this._then);

  final _EditorDocument _self;
  final $Res Function(_EditorDocument) _then;

/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? root = null,Object? screens = null,Object? activeIndex = null,Object? component = null,Object? assets = null,Object? theme = null,Object? schemaVersion = null,}) {
  return _then(_EditorDocument(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNode,screens: null == screens ? _self._screens : screens // ignore: cast_nullable_to_non_nullable
as List<ProjectScreen>,activeIndex: null == activeIndex ? _self.activeIndex : activeIndex // ignore: cast_nullable_to_non_nullable
as int,component: null == component ? _self.component : component // ignore: cast_nullable_to_non_nullable
as bool,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<MediaAsset>,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ProjectTheme,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeCopyWith<$Res> get root {
  
  return $WidgetNodeCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}/// Create a copy of EditorDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectThemeCopyWith<$Res> get theme {
  
  return $ProjectThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}
}

// dart format on
