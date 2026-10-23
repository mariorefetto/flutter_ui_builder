// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'release_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReleaseModel {

@JsonKey(name: 'tag_name') String get tagName;@JsonKey(name: 'html_url') String get htmlUrl; bool get draft; bool get prerelease;
/// Create a copy of ReleaseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReleaseModelCopyWith<ReleaseModel> get copyWith => _$ReleaseModelCopyWithImpl<ReleaseModel>(this as ReleaseModel, _$identity);

  /// Serializes this ReleaseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReleaseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReleaseModel&&(identical(other.tagName, _this.tagName) || other.tagName == _this.tagName)&&(identical(other.htmlUrl, _this.htmlUrl) || other.htmlUrl == _this.htmlUrl)&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&(identical(other.prerelease, _this.prerelease) || other.prerelease == _this.prerelease));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReleaseModel;
  return Object.hash(runtimeType,_this.tagName,_this.htmlUrl,_this.draft,_this.prerelease);
}

@override
String toString() {
  final _this = this as ReleaseModel;
  return 'ReleaseModel(tagName: ${_this.tagName}, htmlUrl: ${_this.htmlUrl}, draft: ${_this.draft}, prerelease: ${_this.prerelease})';
}


}

/// @nodoc
abstract mixin class $ReleaseModelCopyWith<$Res>  {
  factory $ReleaseModelCopyWith(ReleaseModel value, $Res Function(ReleaseModel) _then) = _$ReleaseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tag_name') String tagName,@JsonKey(name: 'html_url') String htmlUrl, bool draft, bool prerelease
});




}
/// @nodoc
class _$ReleaseModelCopyWithImpl<$Res>
    implements $ReleaseModelCopyWith<$Res> {
  _$ReleaseModelCopyWithImpl(this._self, this._then);

  final ReleaseModel _self;
  final $Res Function(ReleaseModel) _then;

/// Create a copy of ReleaseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagName = null,Object? htmlUrl = null,Object? draft = null,Object? prerelease = null,}) {
  return _then(ReleaseModel(
tagName: null == tagName ? _self.tagName : tagName // ignore: cast_nullable_to_non_nullable
as String,htmlUrl: null == htmlUrl ? _self.htmlUrl : htmlUrl // ignore: cast_nullable_to_non_nullable
as String,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,prerelease: null == prerelease ? _self.prerelease : prerelease // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReleaseModel].
extension ReleaseModelPatterns on ReleaseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReleaseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReleaseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReleaseModel value)  $default,){
final _that = this;
switch (_that) {
case _ReleaseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReleaseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReleaseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'tag_name')  String tagName, @JsonKey(name: 'html_url')  String htmlUrl,  bool draft,  bool prerelease)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReleaseModel() when $default != null:
return $default(_that.tagName,_that.htmlUrl,_that.draft,_that.prerelease);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'tag_name')  String tagName, @JsonKey(name: 'html_url')  String htmlUrl,  bool draft,  bool prerelease)  $default,) {final _that = this;
switch (_that) {
case _ReleaseModel():
return $default(_that.tagName,_that.htmlUrl,_that.draft,_that.prerelease);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'tag_name')  String tagName, @JsonKey(name: 'html_url')  String htmlUrl,  bool draft,  bool prerelease)?  $default,) {final _that = this;
switch (_that) {
case _ReleaseModel() when $default != null:
return $default(_that.tagName,_that.htmlUrl,_that.draft,_that.prerelease);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReleaseModel extends ReleaseModel {
  const _ReleaseModel({@JsonKey(name: 'tag_name') required this.tagName, @JsonKey(name: 'html_url') required this.htmlUrl, this.draft = false, this.prerelease = false}): super._();
  factory _ReleaseModel.fromJson(Map<String, dynamic> json) => _$ReleaseModelFromJson(json);

@override@JsonKey(name: 'tag_name') final  String tagName;
@override@JsonKey(name: 'html_url') final  String htmlUrl;
@override@JsonKey() final  bool draft;
@override@JsonKey() final  bool prerelease;

/// Create a copy of ReleaseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReleaseModelCopyWith<_ReleaseModel> get copyWith => __$ReleaseModelCopyWithImpl<_ReleaseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReleaseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReleaseModel&&(identical(other.tagName, tagName) || other.tagName == tagName)&&(identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.prerelease, prerelease) || other.prerelease == prerelease));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tagName,htmlUrl,draft,prerelease);
}

@override
String toString() {
    return 'ReleaseModel(tagName: $tagName, htmlUrl: $htmlUrl, draft: $draft, prerelease: $prerelease)';
}


}

/// @nodoc
abstract mixin class _$ReleaseModelCopyWith<$Res> implements $ReleaseModelCopyWith<$Res> {
  factory _$ReleaseModelCopyWith(_ReleaseModel value, $Res Function(_ReleaseModel) _then) = __$ReleaseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tag_name') String tagName,@JsonKey(name: 'html_url') String htmlUrl, bool draft, bool prerelease
});




}
/// @nodoc
class __$ReleaseModelCopyWithImpl<$Res>
    implements _$ReleaseModelCopyWith<$Res> {
  __$ReleaseModelCopyWithImpl(this._self, this._then);

  final _ReleaseModel _self;
  final $Res Function(_ReleaseModel) _then;

/// Create a copy of ReleaseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagName = null,Object? htmlUrl = null,Object? draft = null,Object? prerelease = null,}) {
  return _then(_ReleaseModel(
tagName: null == tagName ? _self.tagName : tagName // ignore: cast_nullable_to_non_nullable
as String,htmlUrl: null == htmlUrl ? _self.htmlUrl : htmlUrl // ignore: cast_nullable_to_non_nullable
as String,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,prerelease: null == prerelease ? _self.prerelease : prerelease // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
