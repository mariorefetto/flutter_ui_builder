// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettingsModel {

 String get theme; String? get languageCode; String get device; bool get showFrame; String get statusBar; bool get showSafeArea; String get codePlacement; bool get paletteGrid; bool get tourSeen; bool get checkForUpdates;
/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsModelCopyWith<AppSettingsModel> get copyWith => _$AppSettingsModelCopyWithImpl<AppSettingsModel>(this as AppSettingsModel, _$identity);

  /// Serializes this AppSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppSettingsModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettingsModel&&(identical(other.theme, _this.theme) || other.theme == _this.theme)&&(identical(other.languageCode, _this.languageCode) || other.languageCode == _this.languageCode)&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.showFrame, _this.showFrame) || other.showFrame == _this.showFrame)&&(identical(other.statusBar, _this.statusBar) || other.statusBar == _this.statusBar)&&(identical(other.showSafeArea, _this.showSafeArea) || other.showSafeArea == _this.showSafeArea)&&(identical(other.codePlacement, _this.codePlacement) || other.codePlacement == _this.codePlacement)&&(identical(other.paletteGrid, _this.paletteGrid) || other.paletteGrid == _this.paletteGrid)&&(identical(other.tourSeen, _this.tourSeen) || other.tourSeen == _this.tourSeen)&&(identical(other.checkForUpdates, _this.checkForUpdates) || other.checkForUpdates == _this.checkForUpdates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppSettingsModel;
  return Object.hash(runtimeType,_this.theme,_this.languageCode,_this.device,_this.showFrame,_this.statusBar,_this.showSafeArea,_this.codePlacement,_this.paletteGrid,_this.tourSeen,_this.checkForUpdates);
}

@override
String toString() {
  final _this = this as AppSettingsModel;
  return 'AppSettingsModel(theme: ${_this.theme}, languageCode: ${_this.languageCode}, device: ${_this.device}, showFrame: ${_this.showFrame}, statusBar: ${_this.statusBar}, showSafeArea: ${_this.showSafeArea}, codePlacement: ${_this.codePlacement}, paletteGrid: ${_this.paletteGrid}, tourSeen: ${_this.tourSeen}, checkForUpdates: ${_this.checkForUpdates})';
}


}

/// @nodoc
abstract mixin class $AppSettingsModelCopyWith<$Res>  {
  factory $AppSettingsModelCopyWith(AppSettingsModel value, $Res Function(AppSettingsModel) _then) = _$AppSettingsModelCopyWithImpl;
@useResult
$Res call({
 String theme, String? languageCode, String device, bool showFrame, String statusBar, bool showSafeArea, String codePlacement, bool paletteGrid, bool tourSeen, bool checkForUpdates
});




}
/// @nodoc
class _$AppSettingsModelCopyWithImpl<$Res>
    implements $AppSettingsModelCopyWith<$Res> {
  _$AppSettingsModelCopyWithImpl(this._self, this._then);

  final AppSettingsModel _self;
  final $Res Function(AppSettingsModel) _then;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? theme = null,Object? languageCode = freezed,Object? device = null,Object? showFrame = null,Object? statusBar = null,Object? showSafeArea = null,Object? codePlacement = null,Object? paletteGrid = null,Object? tourSeen = null,Object? checkForUpdates = null,}) {
  return _then(AppSettingsModel(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,showFrame: null == showFrame ? _self.showFrame : showFrame // ignore: cast_nullable_to_non_nullable
as bool,statusBar: null == statusBar ? _self.statusBar : statusBar // ignore: cast_nullable_to_non_nullable
as String,showSafeArea: null == showSafeArea ? _self.showSafeArea : showSafeArea // ignore: cast_nullable_to_non_nullable
as bool,codePlacement: null == codePlacement ? _self.codePlacement : codePlacement // ignore: cast_nullable_to_non_nullable
as String,paletteGrid: null == paletteGrid ? _self.paletteGrid : paletteGrid // ignore: cast_nullable_to_non_nullable
as bool,tourSeen: null == tourSeen ? _self.tourSeen : tourSeen // ignore: cast_nullable_to_non_nullable
as bool,checkForUpdates: null == checkForUpdates ? _self.checkForUpdates : checkForUpdates // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettingsModel].
extension AppSettingsModelPatterns on AppSettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _AppSettingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String theme,  String? languageCode,  String device,  bool showFrame,  String statusBar,  bool showSafeArea,  String codePlacement,  bool paletteGrid,  bool tourSeen,  bool checkForUpdates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
return $default(_that.theme,_that.languageCode,_that.device,_that.showFrame,_that.statusBar,_that.showSafeArea,_that.codePlacement,_that.paletteGrid,_that.tourSeen,_that.checkForUpdates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String theme,  String? languageCode,  String device,  bool showFrame,  String statusBar,  bool showSafeArea,  String codePlacement,  bool paletteGrid,  bool tourSeen,  bool checkForUpdates)  $default,) {final _that = this;
switch (_that) {
case _AppSettingsModel():
return $default(_that.theme,_that.languageCode,_that.device,_that.showFrame,_that.statusBar,_that.showSafeArea,_that.codePlacement,_that.paletteGrid,_that.tourSeen,_that.checkForUpdates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String theme,  String? languageCode,  String device,  bool showFrame,  String statusBar,  bool showSafeArea,  String codePlacement,  bool paletteGrid,  bool tourSeen,  bool checkForUpdates)?  $default,) {final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
return $default(_that.theme,_that.languageCode,_that.device,_that.showFrame,_that.statusBar,_that.showSafeArea,_that.codePlacement,_that.paletteGrid,_that.tourSeen,_that.checkForUpdates);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _AppSettingsModel extends AppSettingsModel {
  const _AppSettingsModel({this.theme = 'system', this.languageCode, this.device = 'phone', this.showFrame = true, this.statusBar = 'auto', this.showSafeArea = false, this.codePlacement = 'tab', this.paletteGrid = false, this.tourSeen = false, this.checkForUpdates = true}): super._();
  factory _AppSettingsModel.fromJson(Map<String, dynamic> json) => _$AppSettingsModelFromJson(json);

@override@JsonKey() final  String theme;
@override final  String? languageCode;
@override@JsonKey() final  String device;
@override@JsonKey() final  bool showFrame;
@override@JsonKey() final  String statusBar;
@override@JsonKey() final  bool showSafeArea;
@override@JsonKey() final  String codePlacement;
@override@JsonKey() final  bool paletteGrid;
@override@JsonKey() final  bool tourSeen;
@override@JsonKey() final  bool checkForUpdates;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsModelCopyWith<_AppSettingsModel> get copyWith => __$AppSettingsModelCopyWithImpl<_AppSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettingsModel&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.device, device) || other.device == device)&&(identical(other.showFrame, showFrame) || other.showFrame == showFrame)&&(identical(other.statusBar, statusBar) || other.statusBar == statusBar)&&(identical(other.showSafeArea, showSafeArea) || other.showSafeArea == showSafeArea)&&(identical(other.codePlacement, codePlacement) || other.codePlacement == codePlacement)&&(identical(other.paletteGrid, paletteGrid) || other.paletteGrid == paletteGrid)&&(identical(other.tourSeen, tourSeen) || other.tourSeen == tourSeen)&&(identical(other.checkForUpdates, checkForUpdates) || other.checkForUpdates == checkForUpdates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,theme,languageCode,device,showFrame,statusBar,showSafeArea,codePlacement,paletteGrid,tourSeen,checkForUpdates);
}

@override
String toString() {
    return 'AppSettingsModel(theme: $theme, languageCode: $languageCode, device: $device, showFrame: $showFrame, statusBar: $statusBar, showSafeArea: $showSafeArea, codePlacement: $codePlacement, paletteGrid: $paletteGrid, tourSeen: $tourSeen, checkForUpdates: $checkForUpdates)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsModelCopyWith<$Res> implements $AppSettingsModelCopyWith<$Res> {
  factory _$AppSettingsModelCopyWith(_AppSettingsModel value, $Res Function(_AppSettingsModel) _then) = __$AppSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 String theme, String? languageCode, String device, bool showFrame, String statusBar, bool showSafeArea, String codePlacement, bool paletteGrid, bool tourSeen, bool checkForUpdates
});




}
/// @nodoc
class __$AppSettingsModelCopyWithImpl<$Res>
    implements _$AppSettingsModelCopyWith<$Res> {
  __$AppSettingsModelCopyWithImpl(this._self, this._then);

  final _AppSettingsModel _self;
  final $Res Function(_AppSettingsModel) _then;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? theme = null,Object? languageCode = freezed,Object? device = null,Object? showFrame = null,Object? statusBar = null,Object? showSafeArea = null,Object? codePlacement = null,Object? paletteGrid = null,Object? tourSeen = null,Object? checkForUpdates = null,}) {
  return _then(_AppSettingsModel(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,showFrame: null == showFrame ? _self.showFrame : showFrame // ignore: cast_nullable_to_non_nullable
as bool,statusBar: null == statusBar ? _self.statusBar : statusBar // ignore: cast_nullable_to_non_nullable
as String,showSafeArea: null == showSafeArea ? _self.showSafeArea : showSafeArea // ignore: cast_nullable_to_non_nullable
as bool,codePlacement: null == codePlacement ? _self.codePlacement : codePlacement // ignore: cast_nullable_to_non_nullable
as String,paletteGrid: null == paletteGrid ? _self.paletteGrid : paletteGrid // ignore: cast_nullable_to_non_nullable
as bool,tourSeen: null == tourSeen ? _self.tourSeen : tourSeen // ignore: cast_nullable_to_non_nullable
as bool,checkForUpdates: null == checkForUpdates ? _self.checkForUpdates : checkForUpdates // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
