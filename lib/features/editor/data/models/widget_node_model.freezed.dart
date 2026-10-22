// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'widget_node_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WidgetNodeModel {

 String get id; String get type;@JsonKey(includeIfNull: false) String? get label; Map<String, dynamic> get props; List<WidgetNodeModel> get children;
/// Create a copy of WidgetNodeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WidgetNodeModelCopyWith<WidgetNodeModel> get copyWith => _$WidgetNodeModelCopyWithImpl<WidgetNodeModel>(this as WidgetNodeModel, _$identity);

  /// Serializes this WidgetNodeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WidgetNodeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.props, props)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,label,const DeepCollectionEquality().hash(props),const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'WidgetNodeModel(id: $id, type: $type, label: $label, props: $props, children: $children)';
}


}

/// @nodoc
abstract mixin class $WidgetNodeModelCopyWith<$Res>  {
  factory $WidgetNodeModelCopyWith(WidgetNodeModel value, $Res Function(WidgetNodeModel) _then) = _$WidgetNodeModelCopyWithImpl;
@useResult
$Res call({
 String id, String type,@JsonKey(includeIfNull: false) String? label, Map<String, dynamic> props, List<WidgetNodeModel> children
});




}
/// @nodoc
class _$WidgetNodeModelCopyWithImpl<$Res>
    implements $WidgetNodeModelCopyWith<$Res> {
  _$WidgetNodeModelCopyWithImpl(this._self, this._then);

  final WidgetNodeModel _self;
  final $Res Function(WidgetNodeModel) _then;

/// Create a copy of WidgetNodeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? label = freezed,Object? props = null,Object? children = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,props: null == props ? _self.props : props // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<WidgetNodeModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [WidgetNodeModel].
extension WidgetNodeModelPatterns on WidgetNodeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WidgetNodeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WidgetNodeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WidgetNodeModel value)  $default,){
final _that = this;
switch (_that) {
case _WidgetNodeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WidgetNodeModel value)?  $default,){
final _that = this;
switch (_that) {
case _WidgetNodeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type, @JsonKey(includeIfNull: false)  String? label,  Map<String, dynamic> props,  List<WidgetNodeModel> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WidgetNodeModel() when $default != null:
return $default(_that.id,_that.type,_that.label,_that.props,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type, @JsonKey(includeIfNull: false)  String? label,  Map<String, dynamic> props,  List<WidgetNodeModel> children)  $default,) {final _that = this;
switch (_that) {
case _WidgetNodeModel():
return $default(_that.id,_that.type,_that.label,_that.props,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type, @JsonKey(includeIfNull: false)  String? label,  Map<String, dynamic> props,  List<WidgetNodeModel> children)?  $default,) {final _that = this;
switch (_that) {
case _WidgetNodeModel() when $default != null:
return $default(_that.id,_that.type,_that.label,_that.props,_that.children);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, checked: true)
class _WidgetNodeModel extends WidgetNodeModel {
  const _WidgetNodeModel({required this.id, required this.type, @JsonKey(includeIfNull: false) this.label, final  Map<String, dynamic> props = const <String, dynamic>{}, final  List<WidgetNodeModel> children = const <WidgetNodeModel>[]}): _props = props,_children = children,super._();
  factory _WidgetNodeModel.fromJson(Map<String, dynamic> json) => _$WidgetNodeModelFromJson(json);

@override final  String id;
@override final  String type;
@override@JsonKey(includeIfNull: false) final  String? label;
 final  Map<String, dynamic> _props;
@override@JsonKey() Map<String, dynamic> get props {
  if (_props is EqualUnmodifiableMapView) return _props;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_props);
}

 final  List<WidgetNodeModel> _children;
@override@JsonKey() List<WidgetNodeModel> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of WidgetNodeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WidgetNodeModelCopyWith<_WidgetNodeModel> get copyWith => __$WidgetNodeModelCopyWithImpl<_WidgetNodeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WidgetNodeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WidgetNodeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other._props, _props)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,label,const DeepCollectionEquality().hash(_props),const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'WidgetNodeModel(id: $id, type: $type, label: $label, props: $props, children: $children)';
}


}

/// @nodoc
abstract mixin class _$WidgetNodeModelCopyWith<$Res> implements $WidgetNodeModelCopyWith<$Res> {
  factory _$WidgetNodeModelCopyWith(_WidgetNodeModel value, $Res Function(_WidgetNodeModel) _then) = __$WidgetNodeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String type,@JsonKey(includeIfNull: false) String? label, Map<String, dynamic> props, List<WidgetNodeModel> children
});




}
/// @nodoc
class __$WidgetNodeModelCopyWithImpl<$Res>
    implements _$WidgetNodeModelCopyWith<$Res> {
  __$WidgetNodeModelCopyWithImpl(this._self, this._then);

  final _WidgetNodeModel _self;
  final $Res Function(_WidgetNodeModel) _then;

/// Create a copy of WidgetNodeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? label = freezed,Object? props = null,Object? children = null,}) {
  return _then(_WidgetNodeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,props: null == props ? _self._props : props // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<WidgetNodeModel>,
  ));
}


}

// dart format on
