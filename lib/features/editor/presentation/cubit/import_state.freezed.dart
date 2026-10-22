// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImportState {

/// The outcome of the last render, when it worked.
 ImportResult? get result;/// Why the last render or file read failed.
 Failure? get failure;/// Text read from a file, for the dialog to show. It changes each time a
/// file is read, even to the same text.
 String? get fileText; int get fileRevision;
/// Create a copy of ImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportStateCopyWith<ImportState> get copyWith => _$ImportStateCopyWithImpl<ImportState>(this as ImportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportState&&(identical(other.result, result) || other.result == result)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.fileText, fileText) || other.fileText == fileText)&&(identical(other.fileRevision, fileRevision) || other.fileRevision == fileRevision));
}


@override
int get hashCode => Object.hash(runtimeType,result,failure,fileText,fileRevision);

@override
String toString() {
  return 'ImportState(result: $result, failure: $failure, fileText: $fileText, fileRevision: $fileRevision)';
}


}

/// @nodoc
abstract mixin class $ImportStateCopyWith<$Res>  {
  factory $ImportStateCopyWith(ImportState value, $Res Function(ImportState) _then) = _$ImportStateCopyWithImpl;
@useResult
$Res call({
 ImportResult? result, Failure? failure, String? fileText, int fileRevision
});




}
/// @nodoc
class _$ImportStateCopyWithImpl<$Res>
    implements $ImportStateCopyWith<$Res> {
  _$ImportStateCopyWithImpl(this._self, this._then);

  final ImportState _self;
  final $Res Function(ImportState) _then;

/// Create a copy of ImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? result = freezed,Object? failure = freezed,Object? fileText = freezed,Object? fileRevision = null,}) {
  return _then(_self.copyWith(
result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ImportResult?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,fileText: freezed == fileText ? _self.fileText : fileText // ignore: cast_nullable_to_non_nullable
as String?,fileRevision: null == fileRevision ? _self.fileRevision : fileRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportState].
extension ImportStatePatterns on ImportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportState value)  $default,){
final _that = this;
switch (_that) {
case _ImportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportState value)?  $default,){
final _that = this;
switch (_that) {
case _ImportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ImportResult? result,  Failure? failure,  String? fileText,  int fileRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportState() when $default != null:
return $default(_that.result,_that.failure,_that.fileText,_that.fileRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ImportResult? result,  Failure? failure,  String? fileText,  int fileRevision)  $default,) {final _that = this;
switch (_that) {
case _ImportState():
return $default(_that.result,_that.failure,_that.fileText,_that.fileRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ImportResult? result,  Failure? failure,  String? fileText,  int fileRevision)?  $default,) {final _that = this;
switch (_that) {
case _ImportState() when $default != null:
return $default(_that.result,_that.failure,_that.fileText,_that.fileRevision);case _:
  return null;

}
}

}

/// @nodoc


class _ImportState implements ImportState {
  const _ImportState({this.result, this.failure, this.fileText, this.fileRevision = 0});
  

/// The outcome of the last render, when it worked.
@override final  ImportResult? result;
/// Why the last render or file read failed.
@override final  Failure? failure;
/// Text read from a file, for the dialog to show. It changes each time a
/// file is read, even to the same text.
@override final  String? fileText;
@override@JsonKey() final  int fileRevision;

/// Create a copy of ImportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportStateCopyWith<_ImportState> get copyWith => __$ImportStateCopyWithImpl<_ImportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportState&&(identical(other.result, result) || other.result == result)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.fileText, fileText) || other.fileText == fileText)&&(identical(other.fileRevision, fileRevision) || other.fileRevision == fileRevision));
}


@override
int get hashCode => Object.hash(runtimeType,result,failure,fileText,fileRevision);

@override
String toString() {
  return 'ImportState(result: $result, failure: $failure, fileText: $fileText, fileRevision: $fileRevision)';
}


}

/// @nodoc
abstract mixin class _$ImportStateCopyWith<$Res> implements $ImportStateCopyWith<$Res> {
  factory _$ImportStateCopyWith(_ImportState value, $Res Function(_ImportState) _then) = __$ImportStateCopyWithImpl;
@override @useResult
$Res call({
 ImportResult? result, Failure? failure, String? fileText, int fileRevision
});




}
/// @nodoc
class __$ImportStateCopyWithImpl<$Res>
    implements _$ImportStateCopyWith<$Res> {
  __$ImportStateCopyWithImpl(this._self, this._then);

  final _ImportState _self;
  final $Res Function(_ImportState) _then;

/// Create a copy of ImportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? result = freezed,Object? failure = freezed,Object? fileText = freezed,Object? fileRevision = null,}) {
  return _then(_ImportState(
result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ImportResult?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,fileText: freezed == fileText ? _self.fileText : fileText // ignore: cast_nullable_to_non_nullable
as String?,fileRevision: null == fileRevision ? _self.fileRevision : fileRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
