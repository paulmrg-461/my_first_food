// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'baby.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Baby {

 String get id; String get name; DateTime get birthDate;
/// Create a copy of Baby
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BabyCopyWith<Baby> get copyWith => _$BabyCopyWithImpl<Baby>(this as Baby, _$identity);

  /// Serializes this Baby to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Baby&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,birthDate);

@override
String toString() {
  return 'Baby(id: $id, name: $name, birthDate: $birthDate)';
}


}

/// @nodoc
abstract mixin class $BabyCopyWith<$Res>  {
  factory $BabyCopyWith(Baby value, $Res Function(Baby) _then) = _$BabyCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime birthDate
});




}
/// @nodoc
class _$BabyCopyWithImpl<$Res>
    implements $BabyCopyWith<$Res> {
  _$BabyCopyWithImpl(this._self, this._then);

  final Baby _self;
  final $Res Function(Baby) _then;

/// Create a copy of Baby
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? birthDate = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Baby].
extension BabyPatterns on Baby {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Baby value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Baby() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Baby value)  $default,){
final _that = this;
switch (_that) {
case _Baby():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Baby value)?  $default,){
final _that = this;
switch (_that) {
case _Baby() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime birthDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Baby() when $default != null:
return $default(_that.id,_that.name,_that.birthDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime birthDate)  $default,) {final _that = this;
switch (_that) {
case _Baby():
return $default(_that.id,_that.name,_that.birthDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime birthDate)?  $default,) {final _that = this;
switch (_that) {
case _Baby() when $default != null:
return $default(_that.id,_that.name,_that.birthDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Baby extends Baby {
  const _Baby({required this.id, required this.name, required this.birthDate}): super._();
  factory _Baby.fromJson(Map<String, dynamic> json) => _$BabyFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime birthDate;

/// Create a copy of Baby
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BabyCopyWith<_Baby> get copyWith => __$BabyCopyWithImpl<_Baby>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BabyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Baby&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,birthDate);

@override
String toString() {
  return 'Baby(id: $id, name: $name, birthDate: $birthDate)';
}


}

/// @nodoc
abstract mixin class _$BabyCopyWith<$Res> implements $BabyCopyWith<$Res> {
  factory _$BabyCopyWith(_Baby value, $Res Function(_Baby) _then) = __$BabyCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime birthDate
});




}
/// @nodoc
class __$BabyCopyWithImpl<$Res>
    implements _$BabyCopyWith<$Res> {
  __$BabyCopyWithImpl(this._self, this._then);

  final _Baby _self;
  final $Res Function(_Baby) _then;

/// Create a copy of Baby
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? birthDate = null,}) {
  return _then(_Baby(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
