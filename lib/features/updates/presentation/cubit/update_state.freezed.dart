// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'UpdateState()';
}


}

/// @nodoc
class $UpdateStateCopyWith<$Res>  {
$UpdateStateCopyWith(UpdateState _, $Res Function(UpdateState) __);
}


/// Adds pattern-matching-related methods to [UpdateState].
extension UpdateStatePatterns on UpdateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UpdateIdle value)?  idle,TResult Function( UpdateChecking value)?  checking,TResult Function( UpdateAvailable value)?  available,TResult Function( UpdateUpToDate value)?  upToDate,TResult Function( UpdateFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UpdateIdle() when idle != null:
return idle(_that);case UpdateChecking() when checking != null:
return checking(_that);case UpdateAvailable() when available != null:
return available(_that);case UpdateUpToDate() when upToDate != null:
return upToDate(_that);case UpdateFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UpdateIdle value)  idle,required TResult Function( UpdateChecking value)  checking,required TResult Function( UpdateAvailable value)  available,required TResult Function( UpdateUpToDate value)  upToDate,required TResult Function( UpdateFailed value)  failed,}){
final _that = this;
switch (_that) {
case UpdateIdle():
return idle(_that);case UpdateChecking():
return checking(_that);case UpdateAvailable():
return available(_that);case UpdateUpToDate():
return upToDate(_that);case UpdateFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UpdateIdle value)?  idle,TResult? Function( UpdateChecking value)?  checking,TResult? Function( UpdateAvailable value)?  available,TResult? Function( UpdateUpToDate value)?  upToDate,TResult? Function( UpdateFailed value)?  failed,}){
final _that = this;
switch (_that) {
case UpdateIdle() when idle != null:
return idle(_that);case UpdateChecking() when checking != null:
return checking(_that);case UpdateAvailable() when available != null:
return available(_that);case UpdateUpToDate() when upToDate != null:
return upToDate(_that);case UpdateFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  checking,TResult Function( AppRelease release)?  available,TResult Function()?  upToDate,TResult Function( Failure failure)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UpdateIdle() when idle != null:
return idle();case UpdateChecking() when checking != null:
return checking();case UpdateAvailable() when available != null:
return available(_that.release);case UpdateUpToDate() when upToDate != null:
return upToDate();case UpdateFailed() when failed != null:
return failed(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  checking,required TResult Function( AppRelease release)  available,required TResult Function()  upToDate,required TResult Function( Failure failure)  failed,}) {final _that = this;
switch (_that) {
case UpdateIdle():
return idle();case UpdateChecking():
return checking();case UpdateAvailable():
return available(_that.release);case UpdateUpToDate():
return upToDate();case UpdateFailed():
return failed(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  checking,TResult? Function( AppRelease release)?  available,TResult? Function()?  upToDate,TResult? Function( Failure failure)?  failed,}) {final _that = this;
switch (_that) {
case UpdateIdle() when idle != null:
return idle();case UpdateChecking() when checking != null:
return checking();case UpdateAvailable() when available != null:
return available(_that.release);case UpdateUpToDate() when upToDate != null:
return upToDate();case UpdateFailed() when failed != null:
return failed(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class UpdateIdle implements UpdateState {
  const UpdateIdle();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'UpdateState.idle()';
}


}




/// @nodoc


class UpdateChecking implements UpdateState {
  const UpdateChecking();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateChecking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'UpdateState.checking()';
}


}




/// @nodoc


class UpdateAvailable implements UpdateState {
  const UpdateAvailable(this.release);
  

 final  AppRelease release;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAvailableCopyWith<UpdateAvailable> get copyWith => _$UpdateAvailableCopyWithImpl<UpdateAvailable>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAvailable&&(identical(other.release, release) || other.release == release));
}


@override
int get hashCode {
    return Object.hash(runtimeType,release);
}

@override
String toString() {
    return 'UpdateState.available(release: $release)';
}


}

/// @nodoc
abstract mixin class $UpdateAvailableCopyWith<$Res> implements $UpdateStateCopyWith<$Res> {
  factory $UpdateAvailableCopyWith(UpdateAvailable value, $Res Function(UpdateAvailable) _then) = _$UpdateAvailableCopyWithImpl;
@useResult
$Res call({
 AppRelease release
});


$AppReleaseCopyWith<$Res> get release;

}
/// @nodoc
class _$UpdateAvailableCopyWithImpl<$Res>
    implements $UpdateAvailableCopyWith<$Res> {
  _$UpdateAvailableCopyWithImpl(this._self, this._then);

  final UpdateAvailable _self;
  final $Res Function(UpdateAvailable) _then;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? release = null,}) {
  return _then(UpdateAvailable(
null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as AppRelease,
  ));
}

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppReleaseCopyWith<$Res> get release {
  
  return $AppReleaseCopyWith<$Res>(_self.release, (value) {
    return _then(_self.copyWith(release: value));
  });
}
}

/// @nodoc


class UpdateUpToDate implements UpdateState {
  const UpdateUpToDate();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateUpToDate);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'UpdateState.upToDate()';
}


}




/// @nodoc


class UpdateFailed implements UpdateState {
  const UpdateFailed(this.failure);
  

 final  Failure failure;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateFailedCopyWith<UpdateFailed> get copyWith => _$UpdateFailedCopyWithImpl<UpdateFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'UpdateState.failed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $UpdateFailedCopyWith<$Res> implements $UpdateStateCopyWith<$Res> {
  factory $UpdateFailedCopyWith(UpdateFailed value, $Res Function(UpdateFailed) _then) = _$UpdateFailedCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$UpdateFailedCopyWithImpl<$Res>
    implements $UpdateFailedCopyWith<$Res> {
  _$UpdateFailedCopyWithImpl(this._self, this._then);

  final UpdateFailed _self;
  final $Res Function(UpdateFailed) _then;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(UpdateFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
