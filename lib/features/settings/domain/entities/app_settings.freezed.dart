// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettings {

 ThemeChoice get theme;/// The language code, or null to follow the system's.
 String? get languageCode;/// The device the designer starts on: phone, tablet or desktop.
 String get device;/// Whether the designer starts with the body of the device drawn.
 bool get showFrame;/// How the status bar starts: auto, light, dark or hidden.
 String get statusBar; bool get showSafeArea;/// Where the code starts: tab, right or bottom.
 String get codePlacement;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.device, device) || other.device == device)&&(identical(other.showFrame, showFrame) || other.showFrame == showFrame)&&(identical(other.statusBar, statusBar) || other.statusBar == statusBar)&&(identical(other.showSafeArea, showSafeArea) || other.showSafeArea == showSafeArea)&&(identical(other.codePlacement, codePlacement) || other.codePlacement == codePlacement));
}


@override
int get hashCode => Object.hash(runtimeType,theme,languageCode,device,showFrame,statusBar,showSafeArea,codePlacement);

@override
String toString() {
  return 'AppSettings(theme: $theme, languageCode: $languageCode, device: $device, showFrame: $showFrame, statusBar: $statusBar, showSafeArea: $showSafeArea, codePlacement: $codePlacement)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 ThemeChoice theme, String? languageCode, String device, bool showFrame, String statusBar, bool showSafeArea, String codePlacement
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? theme = null,Object? languageCode = freezed,Object? device = null,Object? showFrame = null,Object? statusBar = null,Object? showSafeArea = null,Object? codePlacement = null,}) {
  return _then(_self.copyWith(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeChoice,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,showFrame: null == showFrame ? _self.showFrame : showFrame // ignore: cast_nullable_to_non_nullable
as bool,statusBar: null == statusBar ? _self.statusBar : statusBar // ignore: cast_nullable_to_non_nullable
as String,showSafeArea: null == showSafeArea ? _self.showSafeArea : showSafeArea // ignore: cast_nullable_to_non_nullable
as bool,codePlacement: null == codePlacement ? _self.codePlacement : codePlacement // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeChoice theme,  String? languageCode,  String device,  bool showFrame,  String statusBar,  bool showSafeArea,  String codePlacement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.theme,_that.languageCode,_that.device,_that.showFrame,_that.statusBar,_that.showSafeArea,_that.codePlacement);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeChoice theme,  String? languageCode,  String device,  bool showFrame,  String statusBar,  bool showSafeArea,  String codePlacement)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.theme,_that.languageCode,_that.device,_that.showFrame,_that.statusBar,_that.showSafeArea,_that.codePlacement);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeChoice theme,  String? languageCode,  String device,  bool showFrame,  String statusBar,  bool showSafeArea,  String codePlacement)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.theme,_that.languageCode,_that.device,_that.showFrame,_that.statusBar,_that.showSafeArea,_that.codePlacement);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings implements AppSettings {
  const _AppSettings({this.theme = ThemeChoice.system, this.languageCode, this.device = 'phone', this.showFrame = true, this.statusBar = 'auto', this.showSafeArea = false, this.codePlacement = 'tab'});
  

@override@JsonKey() final  ThemeChoice theme;
/// The language code, or null to follow the system's.
@override final  String? languageCode;
/// The device the designer starts on: phone, tablet or desktop.
@override@JsonKey() final  String device;
/// Whether the designer starts with the body of the device drawn.
@override@JsonKey() final  bool showFrame;
/// How the status bar starts: auto, light, dark or hidden.
@override@JsonKey() final  String statusBar;
@override@JsonKey() final  bool showSafeArea;
/// Where the code starts: tab, right or bottom.
@override@JsonKey() final  String codePlacement;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.device, device) || other.device == device)&&(identical(other.showFrame, showFrame) || other.showFrame == showFrame)&&(identical(other.statusBar, statusBar) || other.statusBar == statusBar)&&(identical(other.showSafeArea, showSafeArea) || other.showSafeArea == showSafeArea)&&(identical(other.codePlacement, codePlacement) || other.codePlacement == codePlacement));
}


@override
int get hashCode => Object.hash(runtimeType,theme,languageCode,device,showFrame,statusBar,showSafeArea,codePlacement);

@override
String toString() {
  return 'AppSettings(theme: $theme, languageCode: $languageCode, device: $device, showFrame: $showFrame, statusBar: $statusBar, showSafeArea: $showSafeArea, codePlacement: $codePlacement)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 ThemeChoice theme, String? languageCode, String device, bool showFrame, String statusBar, bool showSafeArea, String codePlacement
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? theme = null,Object? languageCode = freezed,Object? device = null,Object? showFrame = null,Object? statusBar = null,Object? showSafeArea = null,Object? codePlacement = null,}) {
  return _then(_AppSettings(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeChoice,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,showFrame: null == showFrame ? _self.showFrame : showFrame // ignore: cast_nullable_to_non_nullable
as bool,statusBar: null == statusBar ? _self.statusBar : statusBar // ignore: cast_nullable_to_non_nullable
as String,showSafeArea: null == showSafeArea ? _self.showSafeArea : showSafeArea // ignore: cast_nullable_to_non_nullable
as bool,codePlacement: null == codePlacement ? _self.codePlacement : codePlacement // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
