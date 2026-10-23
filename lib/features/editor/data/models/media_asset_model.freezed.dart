// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_asset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaAssetModel {

 String get name; String? get sourcePath;
/// Create a copy of MediaAssetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaAssetModelCopyWith<MediaAssetModel> get copyWith => _$MediaAssetModelCopyWithImpl<MediaAssetModel>(this as MediaAssetModel, _$identity);

  /// Serializes this MediaAssetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MediaAssetModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaAssetModel&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sourcePath, _this.sourcePath) || other.sourcePath == _this.sourcePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MediaAssetModel;
  return Object.hash(runtimeType,_this.name,_this.sourcePath);
}

@override
String toString() {
  final _this = this as MediaAssetModel;
  return 'MediaAssetModel(name: ${_this.name}, sourcePath: ${_this.sourcePath})';
}


}

/// @nodoc
abstract mixin class $MediaAssetModelCopyWith<$Res>  {
  factory $MediaAssetModelCopyWith(MediaAssetModel value, $Res Function(MediaAssetModel) _then) = _$MediaAssetModelCopyWithImpl;
@useResult
$Res call({
 String name, String? sourcePath
});




}
/// @nodoc
class _$MediaAssetModelCopyWithImpl<$Res>
    implements $MediaAssetModelCopyWith<$Res> {
  _$MediaAssetModelCopyWithImpl(this._self, this._then);

  final MediaAssetModel _self;
  final $Res Function(MediaAssetModel) _then;

/// Create a copy of MediaAssetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? sourcePath = freezed,}) {
  return _then(MediaAssetModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sourcePath: freezed == sourcePath ? _self.sourcePath : sourcePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaAssetModel].
extension MediaAssetModelPatterns on MediaAssetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaAssetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaAssetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaAssetModel value)  $default,){
final _that = this;
switch (_that) {
case _MediaAssetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaAssetModel value)?  $default,){
final _that = this;
switch (_that) {
case _MediaAssetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? sourcePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaAssetModel() when $default != null:
return $default(_that.name,_that.sourcePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? sourcePath)  $default,) {final _that = this;
switch (_that) {
case _MediaAssetModel():
return $default(_that.name,_that.sourcePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? sourcePath)?  $default,) {final _that = this;
switch (_that) {
case _MediaAssetModel() when $default != null:
return $default(_that.name,_that.sourcePath);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false, checked: true)
class _MediaAssetModel extends MediaAssetModel {
  const _MediaAssetModel({required this.name, this.sourcePath}): super._();
  factory _MediaAssetModel.fromJson(Map<String, dynamic> json) => _$MediaAssetModelFromJson(json);

@override final  String name;
@override final  String? sourcePath;

/// Create a copy of MediaAssetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaAssetModelCopyWith<_MediaAssetModel> get copyWith => __$MediaAssetModelCopyWithImpl<_MediaAssetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaAssetModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaAssetModel&&(identical(other.name, name) || other.name == name)&&(identical(other.sourcePath, sourcePath) || other.sourcePath == sourcePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,sourcePath);
}

@override
String toString() {
    return 'MediaAssetModel(name: $name, sourcePath: $sourcePath)';
}


}

/// @nodoc
abstract mixin class _$MediaAssetModelCopyWith<$Res> implements $MediaAssetModelCopyWith<$Res> {
  factory _$MediaAssetModelCopyWith(_MediaAssetModel value, $Res Function(_MediaAssetModel) _then) = __$MediaAssetModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String? sourcePath
});




}
/// @nodoc
class __$MediaAssetModelCopyWithImpl<$Res>
    implements _$MediaAssetModelCopyWith<$Res> {
  __$MediaAssetModelCopyWithImpl(this._self, this._then);

  final _MediaAssetModel _self;
  final $Res Function(_MediaAssetModel) _then;

/// Create a copy of MediaAssetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? sourcePath = freezed,}) {
  return _then(_MediaAssetModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sourcePath: freezed == sourcePath ? _self.sourcePath : sourcePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
