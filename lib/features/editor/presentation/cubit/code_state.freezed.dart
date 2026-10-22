// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'code_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CodeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CodeState()';
}


}

/// @nodoc
class $CodeStateCopyWith<$Res>  {
$CodeStateCopyWith(CodeState _, $Res Function(CodeState) __);
}


/// Adds pattern-matching-related methods to [CodeState].
extension CodeStatePatterns on CodeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CodeReady value)?  ready,TResult Function( CodeFailed value)?  failed,TResult Function( CodeExporting value)?  exporting,TResult Function( CodeExported value)?  exported,TResult Function( CodeExportFailed value)?  exportFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CodeReady() when ready != null:
return ready(_that);case CodeFailed() when failed != null:
return failed(_that);case CodeExporting() when exporting != null:
return exporting(_that);case CodeExported() when exported != null:
return exported(_that);case CodeExportFailed() when exportFailed != null:
return exportFailed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CodeReady value)  ready,required TResult Function( CodeFailed value)  failed,required TResult Function( CodeExporting value)  exporting,required TResult Function( CodeExported value)  exported,required TResult Function( CodeExportFailed value)  exportFailed,}){
final _that = this;
switch (_that) {
case CodeReady():
return ready(_that);case CodeFailed():
return failed(_that);case CodeExporting():
return exporting(_that);case CodeExported():
return exported(_that);case CodeExportFailed():
return exportFailed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CodeReady value)?  ready,TResult? Function( CodeFailed value)?  failed,TResult? Function( CodeExporting value)?  exporting,TResult? Function( CodeExported value)?  exported,TResult? Function( CodeExportFailed value)?  exportFailed,}){
final _that = this;
switch (_that) {
case CodeReady() when ready != null:
return ready(_that);case CodeFailed() when failed != null:
return failed(_that);case CodeExporting() when exporting != null:
return exporting(_that);case CodeExported() when exported != null:
return exported(_that);case CodeExportFailed() when exportFailed != null:
return exportFailed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<GeneratedFile> files)?  ready,TResult Function( Failure failure)?  failed,TResult Function( List<GeneratedFile> files)?  exporting,TResult Function( List<GeneratedFile> files,  int count)?  exported,TResult Function( List<GeneratedFile> files,  Failure failure)?  exportFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CodeReady() when ready != null:
return ready(_that.files);case CodeFailed() when failed != null:
return failed(_that.failure);case CodeExporting() when exporting != null:
return exporting(_that.files);case CodeExported() when exported != null:
return exported(_that.files,_that.count);case CodeExportFailed() when exportFailed != null:
return exportFailed(_that.files,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<GeneratedFile> files)  ready,required TResult Function( Failure failure)  failed,required TResult Function( List<GeneratedFile> files)  exporting,required TResult Function( List<GeneratedFile> files,  int count)  exported,required TResult Function( List<GeneratedFile> files,  Failure failure)  exportFailed,}) {final _that = this;
switch (_that) {
case CodeReady():
return ready(_that.files);case CodeFailed():
return failed(_that.failure);case CodeExporting():
return exporting(_that.files);case CodeExported():
return exported(_that.files,_that.count);case CodeExportFailed():
return exportFailed(_that.files,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<GeneratedFile> files)?  ready,TResult? Function( Failure failure)?  failed,TResult? Function( List<GeneratedFile> files)?  exporting,TResult? Function( List<GeneratedFile> files,  int count)?  exported,TResult? Function( List<GeneratedFile> files,  Failure failure)?  exportFailed,}) {final _that = this;
switch (_that) {
case CodeReady() when ready != null:
return ready(_that.files);case CodeFailed() when failed != null:
return failed(_that.failure);case CodeExporting() when exporting != null:
return exporting(_that.files);case CodeExported() when exported != null:
return exported(_that.files,_that.count);case CodeExportFailed() when exportFailed != null:
return exportFailed(_that.files,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class CodeReady implements CodeState {
  const CodeReady(final  List<GeneratedFile> files): _files = files;
  

 final  List<GeneratedFile> _files;
 List<GeneratedFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeReadyCopyWith<CodeReady> get copyWith => _$CodeReadyCopyWithImpl<CodeReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeReady&&const DeepCollectionEquality().equals(other._files, _files));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'CodeState.ready(files: $files)';
}


}

/// @nodoc
abstract mixin class $CodeReadyCopyWith<$Res> implements $CodeStateCopyWith<$Res> {
  factory $CodeReadyCopyWith(CodeReady value, $Res Function(CodeReady) _then) = _$CodeReadyCopyWithImpl;
@useResult
$Res call({
 List<GeneratedFile> files
});




}
/// @nodoc
class _$CodeReadyCopyWithImpl<$Res>
    implements $CodeReadyCopyWith<$Res> {
  _$CodeReadyCopyWithImpl(this._self, this._then);

  final CodeReady _self;
  final $Res Function(CodeReady) _then;

/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? files = null,}) {
  return _then(CodeReady(
null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<GeneratedFile>,
  ));
}


}

/// @nodoc


class CodeFailed implements CodeState {
  const CodeFailed(this.failure);
  

 final  Failure failure;

/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeFailedCopyWith<CodeFailed> get copyWith => _$CodeFailedCopyWithImpl<CodeFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'CodeState.failed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CodeFailedCopyWith<$Res> implements $CodeStateCopyWith<$Res> {
  factory $CodeFailedCopyWith(CodeFailed value, $Res Function(CodeFailed) _then) = _$CodeFailedCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$CodeFailedCopyWithImpl<$Res>
    implements $CodeFailedCopyWith<$Res> {
  _$CodeFailedCopyWithImpl(this._self, this._then);

  final CodeFailed _self;
  final $Res Function(CodeFailed) _then;

/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(CodeFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

/// @nodoc


class CodeExporting implements CodeState {
  const CodeExporting(final  List<GeneratedFile> files): _files = files;
  

 final  List<GeneratedFile> _files;
 List<GeneratedFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeExportingCopyWith<CodeExporting> get copyWith => _$CodeExportingCopyWithImpl<CodeExporting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeExporting&&const DeepCollectionEquality().equals(other._files, _files));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'CodeState.exporting(files: $files)';
}


}

/// @nodoc
abstract mixin class $CodeExportingCopyWith<$Res> implements $CodeStateCopyWith<$Res> {
  factory $CodeExportingCopyWith(CodeExporting value, $Res Function(CodeExporting) _then) = _$CodeExportingCopyWithImpl;
@useResult
$Res call({
 List<GeneratedFile> files
});




}
/// @nodoc
class _$CodeExportingCopyWithImpl<$Res>
    implements $CodeExportingCopyWith<$Res> {
  _$CodeExportingCopyWithImpl(this._self, this._then);

  final CodeExporting _self;
  final $Res Function(CodeExporting) _then;

/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? files = null,}) {
  return _then(CodeExporting(
null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<GeneratedFile>,
  ));
}


}

/// @nodoc


class CodeExported implements CodeState {
  const CodeExported(final  List<GeneratedFile> files, this.count): _files = files;
  

 final  List<GeneratedFile> _files;
 List<GeneratedFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

 final  int count;

/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeExportedCopyWith<CodeExported> get copyWith => _$CodeExportedCopyWithImpl<CodeExported>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeExported&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files),count);

@override
String toString() {
  return 'CodeState.exported(files: $files, count: $count)';
}


}

/// @nodoc
abstract mixin class $CodeExportedCopyWith<$Res> implements $CodeStateCopyWith<$Res> {
  factory $CodeExportedCopyWith(CodeExported value, $Res Function(CodeExported) _then) = _$CodeExportedCopyWithImpl;
@useResult
$Res call({
 List<GeneratedFile> files, int count
});




}
/// @nodoc
class _$CodeExportedCopyWithImpl<$Res>
    implements $CodeExportedCopyWith<$Res> {
  _$CodeExportedCopyWithImpl(this._self, this._then);

  final CodeExported _self;
  final $Res Function(CodeExported) _then;

/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? files = null,Object? count = null,}) {
  return _then(CodeExported(
null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<GeneratedFile>,null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class CodeExportFailed implements CodeState {
  const CodeExportFailed(final  List<GeneratedFile> files, this.failure): _files = files;
  

 final  List<GeneratedFile> _files;
 List<GeneratedFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

 final  Failure failure;

/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeExportFailedCopyWith<CodeExportFailed> get copyWith => _$CodeExportFailedCopyWithImpl<CodeExportFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeExportFailed&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files),failure);

@override
String toString() {
  return 'CodeState.exportFailed(files: $files, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CodeExportFailedCopyWith<$Res> implements $CodeStateCopyWith<$Res> {
  factory $CodeExportFailedCopyWith(CodeExportFailed value, $Res Function(CodeExportFailed) _then) = _$CodeExportFailedCopyWithImpl;
@useResult
$Res call({
 List<GeneratedFile> files, Failure failure
});




}
/// @nodoc
class _$CodeExportFailedCopyWithImpl<$Res>
    implements $CodeExportFailedCopyWith<$Res> {
  _$CodeExportFailedCopyWithImpl(this._self, this._then);

  final CodeExportFailed _self;
  final $Res Function(CodeExportFailed) _then;

/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? files = null,Object? failure = null,}) {
  return _then(CodeExportFailed(
null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<GeneratedFile>,null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
