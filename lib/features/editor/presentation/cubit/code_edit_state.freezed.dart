// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'code_edit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CodeEditState {

/// What the code editor shows.
 String get text;/// The code the document generates now.
 String get generated;/// What the edited code makes, when it was checked and worked.
 ImportResult? get result;/// Why the edited code does not work.
 Failure? get failure;/// Changes when the text is replaced from outside, so the editor knows to
/// load it. Typing does not change it.
 int get revision;
/// Create a copy of CodeEditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeEditStateCopyWith<CodeEditState> get copyWith => _$CodeEditStateCopyWithImpl<CodeEditState>(this as CodeEditState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CodeEditState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeEditState&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.generated, _this.generated) || other.generated == _this.generated)&&(identical(other.result, _this.result) || other.result == _this.result)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.revision, _this.revision) || other.revision == _this.revision));
}


@override
int get hashCode {
  final _this = this as CodeEditState;
  return Object.hash(runtimeType,_this.text,_this.generated,_this.result,_this.failure,_this.revision);
}

@override
String toString() {
  final _this = this as CodeEditState;
  return 'CodeEditState(text: ${_this.text}, generated: ${_this.generated}, result: ${_this.result}, failure: ${_this.failure}, revision: ${_this.revision})';
}


}

/// @nodoc
abstract mixin class $CodeEditStateCopyWith<$Res>  {
  factory $CodeEditStateCopyWith(CodeEditState value, $Res Function(CodeEditState) _then) = _$CodeEditStateCopyWithImpl;
@useResult
$Res call({
 String text, String generated, ImportResult? result, Failure? failure, int revision
});




}
/// @nodoc
class _$CodeEditStateCopyWithImpl<$Res>
    implements $CodeEditStateCopyWith<$Res> {
  _$CodeEditStateCopyWithImpl(this._self, this._then);

  final CodeEditState _self;
  final $Res Function(CodeEditState) _then;

/// Create a copy of CodeEditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? generated = null,Object? result = freezed,Object? failure = freezed,Object? revision = null,}) {
  return _then(CodeEditState(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,generated: null == generated ? _self.generated : generated // ignore: cast_nullable_to_non_nullable
as String,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ImportResult?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CodeEditState].
extension CodeEditStatePatterns on CodeEditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CodeEditState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CodeEditState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CodeEditState value)  $default,){
final _that = this;
switch (_that) {
case _CodeEditState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CodeEditState value)?  $default,){
final _that = this;
switch (_that) {
case _CodeEditState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String generated,  ImportResult? result,  Failure? failure,  int revision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CodeEditState() when $default != null:
return $default(_that.text,_that.generated,_that.result,_that.failure,_that.revision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String generated,  ImportResult? result,  Failure? failure,  int revision)  $default,) {final _that = this;
switch (_that) {
case _CodeEditState():
return $default(_that.text,_that.generated,_that.result,_that.failure,_that.revision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String generated,  ImportResult? result,  Failure? failure,  int revision)?  $default,) {final _that = this;
switch (_that) {
case _CodeEditState() when $default != null:
return $default(_that.text,_that.generated,_that.result,_that.failure,_that.revision);case _:
  return null;

}
}

}

/// @nodoc


class _CodeEditState extends CodeEditState {
  const _CodeEditState({this.text = '', this.generated = '', this.result, this.failure, this.revision = 0}): super._();
  

/// What the code editor shows.
@override@JsonKey() final  String text;
/// The code the document generates now.
@override@JsonKey() final  String generated;
/// What the edited code makes, when it was checked and worked.
@override final  ImportResult? result;
/// Why the edited code does not work.
@override final  Failure? failure;
/// Changes when the text is replaced from outside, so the editor knows to
/// load it. Typing does not change it.
@override@JsonKey() final  int revision;

/// Create a copy of CodeEditState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CodeEditStateCopyWith<_CodeEditState> get copyWith => __$CodeEditStateCopyWithImpl<_CodeEditState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CodeEditState&&(identical(other.text, text) || other.text == text)&&(identical(other.generated, generated) || other.generated == generated)&&(identical(other.result, result) || other.result == result)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.revision, revision) || other.revision == revision));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,generated,result,failure,revision);
}

@override
String toString() {
    return 'CodeEditState(text: $text, generated: $generated, result: $result, failure: $failure, revision: $revision)';
}


}

/// @nodoc
abstract mixin class _$CodeEditStateCopyWith<$Res> implements $CodeEditStateCopyWith<$Res> {
  factory _$CodeEditStateCopyWith(_CodeEditState value, $Res Function(_CodeEditState) _then) = __$CodeEditStateCopyWithImpl;
@override @useResult
$Res call({
 String text, String generated, ImportResult? result, Failure? failure, int revision
});




}
/// @nodoc
class __$CodeEditStateCopyWithImpl<$Res>
    implements _$CodeEditStateCopyWith<$Res> {
  __$CodeEditStateCopyWithImpl(this._self, this._then);

  final _CodeEditState _self;
  final $Res Function(_CodeEditState) _then;

/// Create a copy of CodeEditState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? generated = null,Object? result = freezed,Object? failure = freezed,Object? revision = null,}) {
  return _then(_CodeEditState(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,generated: null == generated ? _self.generated : generated // ignore: cast_nullable_to_non_nullable
as String,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ImportResult?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
