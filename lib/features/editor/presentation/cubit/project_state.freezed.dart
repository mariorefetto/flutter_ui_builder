// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectState {

/// The document as last saved or opened. A fresh project counts as saved.
 EditorDocument get savedDocument;/// File the project is bound to, or null before the first save.
 String? get filePath; ProjectEvent? get event;
/// Create a copy of ProjectState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectStateCopyWith<ProjectState> get copyWith => _$ProjectStateCopyWithImpl<ProjectState>(this as ProjectState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectState&&(identical(other.savedDocument, savedDocument) || other.savedDocument == savedDocument)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.event, event) || other.event == event));
}


@override
int get hashCode => Object.hash(runtimeType,savedDocument,filePath,event);

@override
String toString() {
  return 'ProjectState(savedDocument: $savedDocument, filePath: $filePath, event: $event)';
}


}

/// @nodoc
abstract mixin class $ProjectStateCopyWith<$Res>  {
  factory $ProjectStateCopyWith(ProjectState value, $Res Function(ProjectState) _then) = _$ProjectStateCopyWithImpl;
@useResult
$Res call({
 EditorDocument savedDocument, String? filePath, ProjectEvent? event
});


$EditorDocumentCopyWith<$Res> get savedDocument;

}
/// @nodoc
class _$ProjectStateCopyWithImpl<$Res>
    implements $ProjectStateCopyWith<$Res> {
  _$ProjectStateCopyWithImpl(this._self, this._then);

  final ProjectState _self;
  final $Res Function(ProjectState) _then;

/// Create a copy of ProjectState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? savedDocument = null,Object? filePath = freezed,Object? event = freezed,}) {
  return _then(_self.copyWith(
savedDocument: null == savedDocument ? _self.savedDocument : savedDocument // ignore: cast_nullable_to_non_nullable
as EditorDocument,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as ProjectEvent?,
  ));
}
/// Create a copy of ProjectState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditorDocumentCopyWith<$Res> get savedDocument {
  
  return $EditorDocumentCopyWith<$Res>(_self.savedDocument, (value) {
    return _then(_self.copyWith(savedDocument: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectState].
extension ProjectStatePatterns on ProjectState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectState value)  $default,){
final _that = this;
switch (_that) {
case _ProjectState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectState value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EditorDocument savedDocument,  String? filePath,  ProjectEvent? event)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectState() when $default != null:
return $default(_that.savedDocument,_that.filePath,_that.event);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EditorDocument savedDocument,  String? filePath,  ProjectEvent? event)  $default,) {final _that = this;
switch (_that) {
case _ProjectState():
return $default(_that.savedDocument,_that.filePath,_that.event);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EditorDocument savedDocument,  String? filePath,  ProjectEvent? event)?  $default,) {final _that = this;
switch (_that) {
case _ProjectState() when $default != null:
return $default(_that.savedDocument,_that.filePath,_that.event);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectState implements ProjectState {
  const _ProjectState({required this.savedDocument, this.filePath, this.event});
  

/// The document as last saved or opened. A fresh project counts as saved.
@override final  EditorDocument savedDocument;
/// File the project is bound to, or null before the first save.
@override final  String? filePath;
@override final  ProjectEvent? event;

/// Create a copy of ProjectState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectStateCopyWith<_ProjectState> get copyWith => __$ProjectStateCopyWithImpl<_ProjectState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectState&&(identical(other.savedDocument, savedDocument) || other.savedDocument == savedDocument)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.event, event) || other.event == event));
}


@override
int get hashCode => Object.hash(runtimeType,savedDocument,filePath,event);

@override
String toString() {
  return 'ProjectState(savedDocument: $savedDocument, filePath: $filePath, event: $event)';
}


}

/// @nodoc
abstract mixin class _$ProjectStateCopyWith<$Res> implements $ProjectStateCopyWith<$Res> {
  factory _$ProjectStateCopyWith(_ProjectState value, $Res Function(_ProjectState) _then) = __$ProjectStateCopyWithImpl;
@override @useResult
$Res call({
 EditorDocument savedDocument, String? filePath, ProjectEvent? event
});


@override $EditorDocumentCopyWith<$Res> get savedDocument;

}
/// @nodoc
class __$ProjectStateCopyWithImpl<$Res>
    implements _$ProjectStateCopyWith<$Res> {
  __$ProjectStateCopyWithImpl(this._self, this._then);

  final _ProjectState _self;
  final $Res Function(_ProjectState) _then;

/// Create a copy of ProjectState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? savedDocument = null,Object? filePath = freezed,Object? event = freezed,}) {
  return _then(_ProjectState(
savedDocument: null == savedDocument ? _self.savedDocument : savedDocument // ignore: cast_nullable_to_non_nullable
as EditorDocument,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as ProjectEvent?,
  ));
}

/// Create a copy of ProjectState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditorDocumentCopyWith<$Res> get savedDocument {
  
  return $EditorDocumentCopyWith<$Res>(_self.savedDocument, (value) {
    return _then(_self.copyWith(savedDocument: value));
  });
}
}

// dart format on
