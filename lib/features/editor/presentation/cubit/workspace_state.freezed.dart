// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkspaceState {

/// The open left panel, or null when the left dock is collapsed.
 LeftPanel? get leftPanel; bool get propertiesVisible; bool get problemsVisible; CenterTab get centerTab; CodePlacement get codePlacement; double get codeWidth; double get codeHeight;/// The screen the designer previews the project on.
 PreviewDevice get device; bool get landscape;/// Draw the body of the device around the screen, with its status bar.
 bool get showFrame; StatusBarMode get statusBar;/// Tint the areas the system covers, which a SafeArea keeps clear.
 bool get showSafeArea;/// Try the project as it would run: a widget that opens a screen does so
/// when clicked, and nothing is selected or dragged.
 bool get prototype;/// Draw and edit the dark theme of the project rather than the light one.
 bool get darkTheme;/// The screens opened by clicking in prototype mode, oldest first, so a
/// widget that goes back returns to the one before.
 List<String> get screenTrail;/// Designer scale: 1 is actual size.
 double get zoom;/// Widget types added lately, newest first.
 List<String> get recentWidgets; double get leftWidth; double get rightWidth;
/// Create a copy of WorkspaceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceStateCopyWith<WorkspaceState> get copyWith => _$WorkspaceStateCopyWithImpl<WorkspaceState>(this as WorkspaceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceState&&(identical(other.leftPanel, leftPanel) || other.leftPanel == leftPanel)&&(identical(other.propertiesVisible, propertiesVisible) || other.propertiesVisible == propertiesVisible)&&(identical(other.problemsVisible, problemsVisible) || other.problemsVisible == problemsVisible)&&(identical(other.centerTab, centerTab) || other.centerTab == centerTab)&&(identical(other.codePlacement, codePlacement) || other.codePlacement == codePlacement)&&(identical(other.codeWidth, codeWidth) || other.codeWidth == codeWidth)&&(identical(other.codeHeight, codeHeight) || other.codeHeight == codeHeight)&&(identical(other.device, device) || other.device == device)&&(identical(other.landscape, landscape) || other.landscape == landscape)&&(identical(other.showFrame, showFrame) || other.showFrame == showFrame)&&(identical(other.statusBar, statusBar) || other.statusBar == statusBar)&&(identical(other.showSafeArea, showSafeArea) || other.showSafeArea == showSafeArea)&&(identical(other.prototype, prototype) || other.prototype == prototype)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme)&&const DeepCollectionEquality().equals(other.screenTrail, screenTrail)&&(identical(other.zoom, zoom) || other.zoom == zoom)&&const DeepCollectionEquality().equals(other.recentWidgets, recentWidgets)&&(identical(other.leftWidth, leftWidth) || other.leftWidth == leftWidth)&&(identical(other.rightWidth, rightWidth) || other.rightWidth == rightWidth));
}


@override
int get hashCode => Object.hashAll([runtimeType,leftPanel,propertiesVisible,problemsVisible,centerTab,codePlacement,codeWidth,codeHeight,device,landscape,showFrame,statusBar,showSafeArea,prototype,darkTheme,const DeepCollectionEquality().hash(screenTrail),zoom,const DeepCollectionEquality().hash(recentWidgets),leftWidth,rightWidth]);

@override
String toString() {
  return 'WorkspaceState(leftPanel: $leftPanel, propertiesVisible: $propertiesVisible, problemsVisible: $problemsVisible, centerTab: $centerTab, codePlacement: $codePlacement, codeWidth: $codeWidth, codeHeight: $codeHeight, device: $device, landscape: $landscape, showFrame: $showFrame, statusBar: $statusBar, showSafeArea: $showSafeArea, prototype: $prototype, darkTheme: $darkTheme, screenTrail: $screenTrail, zoom: $zoom, recentWidgets: $recentWidgets, leftWidth: $leftWidth, rightWidth: $rightWidth)';
}


}

/// @nodoc
abstract mixin class $WorkspaceStateCopyWith<$Res>  {
  factory $WorkspaceStateCopyWith(WorkspaceState value, $Res Function(WorkspaceState) _then) = _$WorkspaceStateCopyWithImpl;
@useResult
$Res call({
 LeftPanel? leftPanel, bool propertiesVisible, bool problemsVisible, CenterTab centerTab, CodePlacement codePlacement, double codeWidth, double codeHeight, PreviewDevice device, bool landscape, bool showFrame, StatusBarMode statusBar, bool showSafeArea, bool prototype, bool darkTheme, List<String> screenTrail, double zoom, List<String> recentWidgets, double leftWidth, double rightWidth
});




}
/// @nodoc
class _$WorkspaceStateCopyWithImpl<$Res>
    implements $WorkspaceStateCopyWith<$Res> {
  _$WorkspaceStateCopyWithImpl(this._self, this._then);

  final WorkspaceState _self;
  final $Res Function(WorkspaceState) _then;

/// Create a copy of WorkspaceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leftPanel = freezed,Object? propertiesVisible = null,Object? problemsVisible = null,Object? centerTab = null,Object? codePlacement = null,Object? codeWidth = null,Object? codeHeight = null,Object? device = null,Object? landscape = null,Object? showFrame = null,Object? statusBar = null,Object? showSafeArea = null,Object? prototype = null,Object? darkTheme = null,Object? screenTrail = null,Object? zoom = null,Object? recentWidgets = null,Object? leftWidth = null,Object? rightWidth = null,}) {
  return _then(_self.copyWith(
leftPanel: freezed == leftPanel ? _self.leftPanel : leftPanel // ignore: cast_nullable_to_non_nullable
as LeftPanel?,propertiesVisible: null == propertiesVisible ? _self.propertiesVisible : propertiesVisible // ignore: cast_nullable_to_non_nullable
as bool,problemsVisible: null == problemsVisible ? _self.problemsVisible : problemsVisible // ignore: cast_nullable_to_non_nullable
as bool,centerTab: null == centerTab ? _self.centerTab : centerTab // ignore: cast_nullable_to_non_nullable
as CenterTab,codePlacement: null == codePlacement ? _self.codePlacement : codePlacement // ignore: cast_nullable_to_non_nullable
as CodePlacement,codeWidth: null == codeWidth ? _self.codeWidth : codeWidth // ignore: cast_nullable_to_non_nullable
as double,codeHeight: null == codeHeight ? _self.codeHeight : codeHeight // ignore: cast_nullable_to_non_nullable
as double,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PreviewDevice,landscape: null == landscape ? _self.landscape : landscape // ignore: cast_nullable_to_non_nullable
as bool,showFrame: null == showFrame ? _self.showFrame : showFrame // ignore: cast_nullable_to_non_nullable
as bool,statusBar: null == statusBar ? _self.statusBar : statusBar // ignore: cast_nullable_to_non_nullable
as StatusBarMode,showSafeArea: null == showSafeArea ? _self.showSafeArea : showSafeArea // ignore: cast_nullable_to_non_nullable
as bool,prototype: null == prototype ? _self.prototype : prototype // ignore: cast_nullable_to_non_nullable
as bool,darkTheme: null == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as bool,screenTrail: null == screenTrail ? _self.screenTrail : screenTrail // ignore: cast_nullable_to_non_nullable
as List<String>,zoom: null == zoom ? _self.zoom : zoom // ignore: cast_nullable_to_non_nullable
as double,recentWidgets: null == recentWidgets ? _self.recentWidgets : recentWidgets // ignore: cast_nullable_to_non_nullable
as List<String>,leftWidth: null == leftWidth ? _self.leftWidth : leftWidth // ignore: cast_nullable_to_non_nullable
as double,rightWidth: null == rightWidth ? _self.rightWidth : rightWidth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceState].
extension WorkspaceStatePatterns on WorkspaceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceState value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LeftPanel? leftPanel,  bool propertiesVisible,  bool problemsVisible,  CenterTab centerTab,  CodePlacement codePlacement,  double codeWidth,  double codeHeight,  PreviewDevice device,  bool landscape,  bool showFrame,  StatusBarMode statusBar,  bool showSafeArea,  bool prototype,  bool darkTheme,  List<String> screenTrail,  double zoom,  List<String> recentWidgets,  double leftWidth,  double rightWidth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceState() when $default != null:
return $default(_that.leftPanel,_that.propertiesVisible,_that.problemsVisible,_that.centerTab,_that.codePlacement,_that.codeWidth,_that.codeHeight,_that.device,_that.landscape,_that.showFrame,_that.statusBar,_that.showSafeArea,_that.prototype,_that.darkTheme,_that.screenTrail,_that.zoom,_that.recentWidgets,_that.leftWidth,_that.rightWidth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LeftPanel? leftPanel,  bool propertiesVisible,  bool problemsVisible,  CenterTab centerTab,  CodePlacement codePlacement,  double codeWidth,  double codeHeight,  PreviewDevice device,  bool landscape,  bool showFrame,  StatusBarMode statusBar,  bool showSafeArea,  bool prototype,  bool darkTheme,  List<String> screenTrail,  double zoom,  List<String> recentWidgets,  double leftWidth,  double rightWidth)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceState():
return $default(_that.leftPanel,_that.propertiesVisible,_that.problemsVisible,_that.centerTab,_that.codePlacement,_that.codeWidth,_that.codeHeight,_that.device,_that.landscape,_that.showFrame,_that.statusBar,_that.showSafeArea,_that.prototype,_that.darkTheme,_that.screenTrail,_that.zoom,_that.recentWidgets,_that.leftWidth,_that.rightWidth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LeftPanel? leftPanel,  bool propertiesVisible,  bool problemsVisible,  CenterTab centerTab,  CodePlacement codePlacement,  double codeWidth,  double codeHeight,  PreviewDevice device,  bool landscape,  bool showFrame,  StatusBarMode statusBar,  bool showSafeArea,  bool prototype,  bool darkTheme,  List<String> screenTrail,  double zoom,  List<String> recentWidgets,  double leftWidth,  double rightWidth)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceState() when $default != null:
return $default(_that.leftPanel,_that.propertiesVisible,_that.problemsVisible,_that.centerTab,_that.codePlacement,_that.codeWidth,_that.codeHeight,_that.device,_that.landscape,_that.showFrame,_that.statusBar,_that.showSafeArea,_that.prototype,_that.darkTheme,_that.screenTrail,_that.zoom,_that.recentWidgets,_that.leftWidth,_that.rightWidth);case _:
  return null;

}
}

}

/// @nodoc


class _WorkspaceState implements WorkspaceState {
  const _WorkspaceState({this.leftPanel = LeftPanel.toolbox, this.propertiesVisible = true, this.problemsVisible = false, this.centerTab = CenterTab.design, this.codePlacement = CodePlacement.tab, this.codeWidth = _defaultCodeWidth, this.codeHeight = _defaultCodeHeight, this.device = PreviewDevice.phone, this.landscape = false, this.showFrame = true, this.statusBar = StatusBarMode.auto, this.showSafeArea = false, this.prototype = false, this.darkTheme = false, final  List<String> screenTrail = const <String>[], this.zoom = 1.0, final  List<String> recentWidgets = const <String>[], this.leftWidth = _defaultLeftWidth, this.rightWidth = _defaultRightWidth}): _screenTrail = screenTrail,_recentWidgets = recentWidgets;
  

/// The open left panel, or null when the left dock is collapsed.
@override@JsonKey() final  LeftPanel? leftPanel;
@override@JsonKey() final  bool propertiesVisible;
@override@JsonKey() final  bool problemsVisible;
@override@JsonKey() final  CenterTab centerTab;
@override@JsonKey() final  CodePlacement codePlacement;
@override@JsonKey() final  double codeWidth;
@override@JsonKey() final  double codeHeight;
/// The screen the designer previews the project on.
@override@JsonKey() final  PreviewDevice device;
@override@JsonKey() final  bool landscape;
/// Draw the body of the device around the screen, with its status bar.
@override@JsonKey() final  bool showFrame;
@override@JsonKey() final  StatusBarMode statusBar;
/// Tint the areas the system covers, which a SafeArea keeps clear.
@override@JsonKey() final  bool showSafeArea;
/// Try the project as it would run: a widget that opens a screen does so
/// when clicked, and nothing is selected or dragged.
@override@JsonKey() final  bool prototype;
/// Draw and edit the dark theme of the project rather than the light one.
@override@JsonKey() final  bool darkTheme;
/// The screens opened by clicking in prototype mode, oldest first, so a
/// widget that goes back returns to the one before.
 final  List<String> _screenTrail;
/// The screens opened by clicking in prototype mode, oldest first, so a
/// widget that goes back returns to the one before.
@override@JsonKey() List<String> get screenTrail {
  if (_screenTrail is EqualUnmodifiableListView) return _screenTrail;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_screenTrail);
}

/// Designer scale: 1 is actual size.
@override@JsonKey() final  double zoom;
/// Widget types added lately, newest first.
 final  List<String> _recentWidgets;
/// Widget types added lately, newest first.
@override@JsonKey() List<String> get recentWidgets {
  if (_recentWidgets is EqualUnmodifiableListView) return _recentWidgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentWidgets);
}

@override@JsonKey() final  double leftWidth;
@override@JsonKey() final  double rightWidth;

/// Create a copy of WorkspaceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceStateCopyWith<_WorkspaceState> get copyWith => __$WorkspaceStateCopyWithImpl<_WorkspaceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceState&&(identical(other.leftPanel, leftPanel) || other.leftPanel == leftPanel)&&(identical(other.propertiesVisible, propertiesVisible) || other.propertiesVisible == propertiesVisible)&&(identical(other.problemsVisible, problemsVisible) || other.problemsVisible == problemsVisible)&&(identical(other.centerTab, centerTab) || other.centerTab == centerTab)&&(identical(other.codePlacement, codePlacement) || other.codePlacement == codePlacement)&&(identical(other.codeWidth, codeWidth) || other.codeWidth == codeWidth)&&(identical(other.codeHeight, codeHeight) || other.codeHeight == codeHeight)&&(identical(other.device, device) || other.device == device)&&(identical(other.landscape, landscape) || other.landscape == landscape)&&(identical(other.showFrame, showFrame) || other.showFrame == showFrame)&&(identical(other.statusBar, statusBar) || other.statusBar == statusBar)&&(identical(other.showSafeArea, showSafeArea) || other.showSafeArea == showSafeArea)&&(identical(other.prototype, prototype) || other.prototype == prototype)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme)&&const DeepCollectionEquality().equals(other._screenTrail, _screenTrail)&&(identical(other.zoom, zoom) || other.zoom == zoom)&&const DeepCollectionEquality().equals(other._recentWidgets, _recentWidgets)&&(identical(other.leftWidth, leftWidth) || other.leftWidth == leftWidth)&&(identical(other.rightWidth, rightWidth) || other.rightWidth == rightWidth));
}


@override
int get hashCode => Object.hashAll([runtimeType,leftPanel,propertiesVisible,problemsVisible,centerTab,codePlacement,codeWidth,codeHeight,device,landscape,showFrame,statusBar,showSafeArea,prototype,darkTheme,const DeepCollectionEquality().hash(_screenTrail),zoom,const DeepCollectionEquality().hash(_recentWidgets),leftWidth,rightWidth]);

@override
String toString() {
  return 'WorkspaceState(leftPanel: $leftPanel, propertiesVisible: $propertiesVisible, problemsVisible: $problemsVisible, centerTab: $centerTab, codePlacement: $codePlacement, codeWidth: $codeWidth, codeHeight: $codeHeight, device: $device, landscape: $landscape, showFrame: $showFrame, statusBar: $statusBar, showSafeArea: $showSafeArea, prototype: $prototype, darkTheme: $darkTheme, screenTrail: $screenTrail, zoom: $zoom, recentWidgets: $recentWidgets, leftWidth: $leftWidth, rightWidth: $rightWidth)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceStateCopyWith<$Res> implements $WorkspaceStateCopyWith<$Res> {
  factory _$WorkspaceStateCopyWith(_WorkspaceState value, $Res Function(_WorkspaceState) _then) = __$WorkspaceStateCopyWithImpl;
@override @useResult
$Res call({
 LeftPanel? leftPanel, bool propertiesVisible, bool problemsVisible, CenterTab centerTab, CodePlacement codePlacement, double codeWidth, double codeHeight, PreviewDevice device, bool landscape, bool showFrame, StatusBarMode statusBar, bool showSafeArea, bool prototype, bool darkTheme, List<String> screenTrail, double zoom, List<String> recentWidgets, double leftWidth, double rightWidth
});




}
/// @nodoc
class __$WorkspaceStateCopyWithImpl<$Res>
    implements _$WorkspaceStateCopyWith<$Res> {
  __$WorkspaceStateCopyWithImpl(this._self, this._then);

  final _WorkspaceState _self;
  final $Res Function(_WorkspaceState) _then;

/// Create a copy of WorkspaceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leftPanel = freezed,Object? propertiesVisible = null,Object? problemsVisible = null,Object? centerTab = null,Object? codePlacement = null,Object? codeWidth = null,Object? codeHeight = null,Object? device = null,Object? landscape = null,Object? showFrame = null,Object? statusBar = null,Object? showSafeArea = null,Object? prototype = null,Object? darkTheme = null,Object? screenTrail = null,Object? zoom = null,Object? recentWidgets = null,Object? leftWidth = null,Object? rightWidth = null,}) {
  return _then(_WorkspaceState(
leftPanel: freezed == leftPanel ? _self.leftPanel : leftPanel // ignore: cast_nullable_to_non_nullable
as LeftPanel?,propertiesVisible: null == propertiesVisible ? _self.propertiesVisible : propertiesVisible // ignore: cast_nullable_to_non_nullable
as bool,problemsVisible: null == problemsVisible ? _self.problemsVisible : problemsVisible // ignore: cast_nullable_to_non_nullable
as bool,centerTab: null == centerTab ? _self.centerTab : centerTab // ignore: cast_nullable_to_non_nullable
as CenterTab,codePlacement: null == codePlacement ? _self.codePlacement : codePlacement // ignore: cast_nullable_to_non_nullable
as CodePlacement,codeWidth: null == codeWidth ? _self.codeWidth : codeWidth // ignore: cast_nullable_to_non_nullable
as double,codeHeight: null == codeHeight ? _self.codeHeight : codeHeight // ignore: cast_nullable_to_non_nullable
as double,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PreviewDevice,landscape: null == landscape ? _self.landscape : landscape // ignore: cast_nullable_to_non_nullable
as bool,showFrame: null == showFrame ? _self.showFrame : showFrame // ignore: cast_nullable_to_non_nullable
as bool,statusBar: null == statusBar ? _self.statusBar : statusBar // ignore: cast_nullable_to_non_nullable
as StatusBarMode,showSafeArea: null == showSafeArea ? _self.showSafeArea : showSafeArea // ignore: cast_nullable_to_non_nullable
as bool,prototype: null == prototype ? _self.prototype : prototype // ignore: cast_nullable_to_non_nullable
as bool,darkTheme: null == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as bool,screenTrail: null == screenTrail ? _self._screenTrail : screenTrail // ignore: cast_nullable_to_non_nullable
as List<String>,zoom: null == zoom ? _self.zoom : zoom // ignore: cast_nullable_to_non_nullable
as double,recentWidgets: null == recentWidgets ? _self._recentWidgets : recentWidgets // ignore: cast_nullable_to_non_nullable
as List<String>,leftWidth: null == leftWidth ? _self.leftWidth : leftWidth // ignore: cast_nullable_to_non_nullable
as double,rightWidth: null == rightWidth ? _self.rightWidth : rightWidth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
