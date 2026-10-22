// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentHistory {

 EditorDocument get present; List<EditorDocument> get past; List<EditorDocument> get future;
/// Create a copy of DocumentHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentHistoryCopyWith<DocumentHistory> get copyWith => _$DocumentHistoryCopyWithImpl<DocumentHistory>(this as DocumentHistory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentHistory&&(identical(other.present, present) || other.present == present)&&const DeepCollectionEquality().equals(other.past, past)&&const DeepCollectionEquality().equals(other.future, future));
}


@override
int get hashCode => Object.hash(runtimeType,present,const DeepCollectionEquality().hash(past),const DeepCollectionEquality().hash(future));

@override
String toString() {
  return 'DocumentHistory(present: $present, past: $past, future: $future)';
}


}

/// @nodoc
abstract mixin class $DocumentHistoryCopyWith<$Res>  {
  factory $DocumentHistoryCopyWith(DocumentHistory value, $Res Function(DocumentHistory) _then) = _$DocumentHistoryCopyWithImpl;
@useResult
$Res call({
 EditorDocument present, List<EditorDocument> past, List<EditorDocument> future
});


$EditorDocumentCopyWith<$Res> get present;

}
/// @nodoc
class _$DocumentHistoryCopyWithImpl<$Res>
    implements $DocumentHistoryCopyWith<$Res> {
  _$DocumentHistoryCopyWithImpl(this._self, this._then);

  final DocumentHistory _self;
  final $Res Function(DocumentHistory) _then;

/// Create a copy of DocumentHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? present = null,Object? past = null,Object? future = null,}) {
  return _then(_self.copyWith(
present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as EditorDocument,past: null == past ? _self.past : past // ignore: cast_nullable_to_non_nullable
as List<EditorDocument>,future: null == future ? _self.future : future // ignore: cast_nullable_to_non_nullable
as List<EditorDocument>,
  ));
}
/// Create a copy of DocumentHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditorDocumentCopyWith<$Res> get present {
  
  return $EditorDocumentCopyWith<$Res>(_self.present, (value) {
    return _then(_self.copyWith(present: value));
  });
}
}


/// Adds pattern-matching-related methods to [DocumentHistory].
extension DocumentHistoryPatterns on DocumentHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentHistory value)  $default,){
final _that = this;
switch (_that) {
case _DocumentHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentHistory value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EditorDocument present,  List<EditorDocument> past,  List<EditorDocument> future)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentHistory() when $default != null:
return $default(_that.present,_that.past,_that.future);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EditorDocument present,  List<EditorDocument> past,  List<EditorDocument> future)  $default,) {final _that = this;
switch (_that) {
case _DocumentHistory():
return $default(_that.present,_that.past,_that.future);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EditorDocument present,  List<EditorDocument> past,  List<EditorDocument> future)?  $default,) {final _that = this;
switch (_that) {
case _DocumentHistory() when $default != null:
return $default(_that.present,_that.past,_that.future);case _:
  return null;

}
}

}

/// @nodoc


class _DocumentHistory extends DocumentHistory {
  const _DocumentHistory({required this.present, final  List<EditorDocument> past = const <EditorDocument>[], final  List<EditorDocument> future = const <EditorDocument>[]}): _past = past,_future = future,super._();
  

@override final  EditorDocument present;
 final  List<EditorDocument> _past;
@override@JsonKey() List<EditorDocument> get past {
  if (_past is EqualUnmodifiableListView) return _past;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_past);
}

 final  List<EditorDocument> _future;
@override@JsonKey() List<EditorDocument> get future {
  if (_future is EqualUnmodifiableListView) return _future;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_future);
}


/// Create a copy of DocumentHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentHistoryCopyWith<_DocumentHistory> get copyWith => __$DocumentHistoryCopyWithImpl<_DocumentHistory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentHistory&&(identical(other.present, present) || other.present == present)&&const DeepCollectionEquality().equals(other._past, _past)&&const DeepCollectionEquality().equals(other._future, _future));
}


@override
int get hashCode => Object.hash(runtimeType,present,const DeepCollectionEquality().hash(_past),const DeepCollectionEquality().hash(_future));

@override
String toString() {
  return 'DocumentHistory(present: $present, past: $past, future: $future)';
}


}

/// @nodoc
abstract mixin class _$DocumentHistoryCopyWith<$Res> implements $DocumentHistoryCopyWith<$Res> {
  factory _$DocumentHistoryCopyWith(_DocumentHistory value, $Res Function(_DocumentHistory) _then) = __$DocumentHistoryCopyWithImpl;
@override @useResult
$Res call({
 EditorDocument present, List<EditorDocument> past, List<EditorDocument> future
});


@override $EditorDocumentCopyWith<$Res> get present;

}
/// @nodoc
class __$DocumentHistoryCopyWithImpl<$Res>
    implements _$DocumentHistoryCopyWith<$Res> {
  __$DocumentHistoryCopyWithImpl(this._self, this._then);

  final _DocumentHistory _self;
  final $Res Function(_DocumentHistory) _then;

/// Create a copy of DocumentHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? present = null,Object? past = null,Object? future = null,}) {
  return _then(_DocumentHistory(
present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as EditorDocument,past: null == past ? _self._past : past // ignore: cast_nullable_to_non_nullable
as List<EditorDocument>,future: null == future ? _self._future : future // ignore: cast_nullable_to_non_nullable
as List<EditorDocument>,
  ));
}

/// Create a copy of DocumentHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditorDocumentCopyWith<$Res> get present {
  
  return $EditorDocumentCopyWith<$Res>(_self.present, (value) {
    return _then(_self.copyWith(present: value));
  });
}
}

// dart format on
