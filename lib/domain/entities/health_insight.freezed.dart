// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_insight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthInsight {

 String get ingredient; List<String> get benefits; List<String> get warnings; int get recommendedAgeMonths; String get preparationTip;
/// Create a copy of HealthInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthInsightCopyWith<HealthInsight> get copyWith => _$HealthInsightCopyWithImpl<HealthInsight>(this as HealthInsight, _$identity);

  /// Serializes this HealthInsight to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthInsight&&(identical(other.ingredient, ingredient) || other.ingredient == ingredient)&&const DeepCollectionEquality().equals(other.benefits, benefits)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&(identical(other.recommendedAgeMonths, recommendedAgeMonths) || other.recommendedAgeMonths == recommendedAgeMonths)&&(identical(other.preparationTip, preparationTip) || other.preparationTip == preparationTip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ingredient,const DeepCollectionEquality().hash(benefits),const DeepCollectionEquality().hash(warnings),recommendedAgeMonths,preparationTip);

@override
String toString() {
  return 'HealthInsight(ingredient: $ingredient, benefits: $benefits, warnings: $warnings, recommendedAgeMonths: $recommendedAgeMonths, preparationTip: $preparationTip)';
}


}

/// @nodoc
abstract mixin class $HealthInsightCopyWith<$Res>  {
  factory $HealthInsightCopyWith(HealthInsight value, $Res Function(HealthInsight) _then) = _$HealthInsightCopyWithImpl;
@useResult
$Res call({
 String ingredient, List<String> benefits, List<String> warnings, int recommendedAgeMonths, String preparationTip
});




}
/// @nodoc
class _$HealthInsightCopyWithImpl<$Res>
    implements $HealthInsightCopyWith<$Res> {
  _$HealthInsightCopyWithImpl(this._self, this._then);

  final HealthInsight _self;
  final $Res Function(HealthInsight) _then;

/// Create a copy of HealthInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ingredient = null,Object? benefits = null,Object? warnings = null,Object? recommendedAgeMonths = null,Object? preparationTip = null,}) {
  return _then(_self.copyWith(
ingredient: null == ingredient ? _self.ingredient : ingredient // ignore: cast_nullable_to_non_nullable
as String,benefits: null == benefits ? _self.benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,recommendedAgeMonths: null == recommendedAgeMonths ? _self.recommendedAgeMonths : recommendedAgeMonths // ignore: cast_nullable_to_non_nullable
as int,preparationTip: null == preparationTip ? _self.preparationTip : preparationTip // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthInsight].
extension HealthInsightPatterns on HealthInsight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthInsight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthInsight value)  $default,){
final _that = this;
switch (_that) {
case _HealthInsight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthInsight value)?  $default,){
final _that = this;
switch (_that) {
case _HealthInsight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ingredient,  List<String> benefits,  List<String> warnings,  int recommendedAgeMonths,  String preparationTip)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthInsight() when $default != null:
return $default(_that.ingredient,_that.benefits,_that.warnings,_that.recommendedAgeMonths,_that.preparationTip);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ingredient,  List<String> benefits,  List<String> warnings,  int recommendedAgeMonths,  String preparationTip)  $default,) {final _that = this;
switch (_that) {
case _HealthInsight():
return $default(_that.ingredient,_that.benefits,_that.warnings,_that.recommendedAgeMonths,_that.preparationTip);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ingredient,  List<String> benefits,  List<String> warnings,  int recommendedAgeMonths,  String preparationTip)?  $default,) {final _that = this;
switch (_that) {
case _HealthInsight() when $default != null:
return $default(_that.ingredient,_that.benefits,_that.warnings,_that.recommendedAgeMonths,_that.preparationTip);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthInsight implements HealthInsight {
  const _HealthInsight({required this.ingredient, required final  List<String> benefits, required final  List<String> warnings, required this.recommendedAgeMonths, this.preparationTip = ''}): _benefits = benefits,_warnings = warnings;
  factory _HealthInsight.fromJson(Map<String, dynamic> json) => _$HealthInsightFromJson(json);

@override final  String ingredient;
 final  List<String> _benefits;
@override List<String> get benefits {
  if (_benefits is EqualUnmodifiableListView) return _benefits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_benefits);
}

 final  List<String> _warnings;
@override List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}

@override final  int recommendedAgeMonths;
@override@JsonKey() final  String preparationTip;

/// Create a copy of HealthInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthInsightCopyWith<_HealthInsight> get copyWith => __$HealthInsightCopyWithImpl<_HealthInsight>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthInsightToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthInsight&&(identical(other.ingredient, ingredient) || other.ingredient == ingredient)&&const DeepCollectionEquality().equals(other._benefits, _benefits)&&const DeepCollectionEquality().equals(other._warnings, _warnings)&&(identical(other.recommendedAgeMonths, recommendedAgeMonths) || other.recommendedAgeMonths == recommendedAgeMonths)&&(identical(other.preparationTip, preparationTip) || other.preparationTip == preparationTip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ingredient,const DeepCollectionEquality().hash(_benefits),const DeepCollectionEquality().hash(_warnings),recommendedAgeMonths,preparationTip);

@override
String toString() {
  return 'HealthInsight(ingredient: $ingredient, benefits: $benefits, warnings: $warnings, recommendedAgeMonths: $recommendedAgeMonths, preparationTip: $preparationTip)';
}


}

/// @nodoc
abstract mixin class _$HealthInsightCopyWith<$Res> implements $HealthInsightCopyWith<$Res> {
  factory _$HealthInsightCopyWith(_HealthInsight value, $Res Function(_HealthInsight) _then) = __$HealthInsightCopyWithImpl;
@override @useResult
$Res call({
 String ingredient, List<String> benefits, List<String> warnings, int recommendedAgeMonths, String preparationTip
});




}
/// @nodoc
class __$HealthInsightCopyWithImpl<$Res>
    implements _$HealthInsightCopyWith<$Res> {
  __$HealthInsightCopyWithImpl(this._self, this._then);

  final _HealthInsight _self;
  final $Res Function(_HealthInsight) _then;

/// Create a copy of HealthInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ingredient = null,Object? benefits = null,Object? warnings = null,Object? recommendedAgeMonths = null,Object? preparationTip = null,}) {
  return _then(_HealthInsight(
ingredient: null == ingredient ? _self.ingredient : ingredient // ignore: cast_nullable_to_non_nullable
as String,benefits: null == benefits ? _self._benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,recommendedAgeMonths: null == recommendedAgeMonths ? _self.recommendedAgeMonths : recommendedAgeMonths // ignore: cast_nullable_to_non_nullable
as int,preparationTip: null == preparationTip ? _self.preparationTip : preparationTip // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
