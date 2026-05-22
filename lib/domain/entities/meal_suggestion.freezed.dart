// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealSuggestion {

 String get title; String get description; List<Ingredient> get ingredients; String get instructions; int get minAgeMonths; String get sourceDocument; List<String> get nutritionHighlights; List<String> get missingIngredients;
/// Create a copy of MealSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealSuggestionCopyWith<MealSuggestion> get copyWith => _$MealSuggestionCopyWithImpl<MealSuggestion>(this as MealSuggestion, _$identity);

  /// Serializes this MealSuggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealSuggestion&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.minAgeMonths, minAgeMonths) || other.minAgeMonths == minAgeMonths)&&(identical(other.sourceDocument, sourceDocument) || other.sourceDocument == sourceDocument)&&const DeepCollectionEquality().equals(other.nutritionHighlights, nutritionHighlights)&&const DeepCollectionEquality().equals(other.missingIngredients, missingIngredients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,const DeepCollectionEquality().hash(ingredients),instructions,minAgeMonths,sourceDocument,const DeepCollectionEquality().hash(nutritionHighlights),const DeepCollectionEquality().hash(missingIngredients));

@override
String toString() {
  return 'MealSuggestion(title: $title, description: $description, ingredients: $ingredients, instructions: $instructions, minAgeMonths: $minAgeMonths, sourceDocument: $sourceDocument, nutritionHighlights: $nutritionHighlights, missingIngredients: $missingIngredients)';
}


}

/// @nodoc
abstract mixin class $MealSuggestionCopyWith<$Res>  {
  factory $MealSuggestionCopyWith(MealSuggestion value, $Res Function(MealSuggestion) _then) = _$MealSuggestionCopyWithImpl;
@useResult
$Res call({
 String title, String description, List<Ingredient> ingredients, String instructions, int minAgeMonths, String sourceDocument, List<String> nutritionHighlights, List<String> missingIngredients
});




}
/// @nodoc
class _$MealSuggestionCopyWithImpl<$Res>
    implements $MealSuggestionCopyWith<$Res> {
  _$MealSuggestionCopyWithImpl(this._self, this._then);

  final MealSuggestion _self;
  final $Res Function(MealSuggestion) _then;

/// Create a copy of MealSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? ingredients = null,Object? instructions = null,Object? minAgeMonths = null,Object? sourceDocument = null,Object? nutritionHighlights = null,Object? missingIngredients = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,minAgeMonths: null == minAgeMonths ? _self.minAgeMonths : minAgeMonths // ignore: cast_nullable_to_non_nullable
as int,sourceDocument: null == sourceDocument ? _self.sourceDocument : sourceDocument // ignore: cast_nullable_to_non_nullable
as String,nutritionHighlights: null == nutritionHighlights ? _self.nutritionHighlights : nutritionHighlights // ignore: cast_nullable_to_non_nullable
as List<String>,missingIngredients: null == missingIngredients ? _self.missingIngredients : missingIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MealSuggestion].
extension MealSuggestionPatterns on MealSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _MealSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _MealSuggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  List<Ingredient> ingredients,  String instructions,  int minAgeMonths,  String sourceDocument,  List<String> nutritionHighlights,  List<String> missingIngredients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealSuggestion() when $default != null:
return $default(_that.title,_that.description,_that.ingredients,_that.instructions,_that.minAgeMonths,_that.sourceDocument,_that.nutritionHighlights,_that.missingIngredients);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  List<Ingredient> ingredients,  String instructions,  int minAgeMonths,  String sourceDocument,  List<String> nutritionHighlights,  List<String> missingIngredients)  $default,) {final _that = this;
switch (_that) {
case _MealSuggestion():
return $default(_that.title,_that.description,_that.ingredients,_that.instructions,_that.minAgeMonths,_that.sourceDocument,_that.nutritionHighlights,_that.missingIngredients);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  List<Ingredient> ingredients,  String instructions,  int minAgeMonths,  String sourceDocument,  List<String> nutritionHighlights,  List<String> missingIngredients)?  $default,) {final _that = this;
switch (_that) {
case _MealSuggestion() when $default != null:
return $default(_that.title,_that.description,_that.ingredients,_that.instructions,_that.minAgeMonths,_that.sourceDocument,_that.nutritionHighlights,_that.missingIngredients);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealSuggestion implements MealSuggestion {
  const _MealSuggestion({required this.title, required this.description, required final  List<Ingredient> ingredients, required this.instructions, required this.minAgeMonths, this.sourceDocument = '', final  List<String> nutritionHighlights = const [], final  List<String> missingIngredients = const []}): _ingredients = ingredients,_nutritionHighlights = nutritionHighlights,_missingIngredients = missingIngredients;
  factory _MealSuggestion.fromJson(Map<String, dynamic> json) => _$MealSuggestionFromJson(json);

@override final  String title;
@override final  String description;
 final  List<Ingredient> _ingredients;
@override List<Ingredient> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

@override final  String instructions;
@override final  int minAgeMonths;
@override@JsonKey() final  String sourceDocument;
 final  List<String> _nutritionHighlights;
@override@JsonKey() List<String> get nutritionHighlights {
  if (_nutritionHighlights is EqualUnmodifiableListView) return _nutritionHighlights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nutritionHighlights);
}

 final  List<String> _missingIngredients;
@override@JsonKey() List<String> get missingIngredients {
  if (_missingIngredients is EqualUnmodifiableListView) return _missingIngredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missingIngredients);
}


/// Create a copy of MealSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealSuggestionCopyWith<_MealSuggestion> get copyWith => __$MealSuggestionCopyWithImpl<_MealSuggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealSuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealSuggestion&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.minAgeMonths, minAgeMonths) || other.minAgeMonths == minAgeMonths)&&(identical(other.sourceDocument, sourceDocument) || other.sourceDocument == sourceDocument)&&const DeepCollectionEquality().equals(other._nutritionHighlights, _nutritionHighlights)&&const DeepCollectionEquality().equals(other._missingIngredients, _missingIngredients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,const DeepCollectionEquality().hash(_ingredients),instructions,minAgeMonths,sourceDocument,const DeepCollectionEquality().hash(_nutritionHighlights),const DeepCollectionEquality().hash(_missingIngredients));

@override
String toString() {
  return 'MealSuggestion(title: $title, description: $description, ingredients: $ingredients, instructions: $instructions, minAgeMonths: $minAgeMonths, sourceDocument: $sourceDocument, nutritionHighlights: $nutritionHighlights, missingIngredients: $missingIngredients)';
}


}

/// @nodoc
abstract mixin class _$MealSuggestionCopyWith<$Res> implements $MealSuggestionCopyWith<$Res> {
  factory _$MealSuggestionCopyWith(_MealSuggestion value, $Res Function(_MealSuggestion) _then) = __$MealSuggestionCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, List<Ingredient> ingredients, String instructions, int minAgeMonths, String sourceDocument, List<String> nutritionHighlights, List<String> missingIngredients
});




}
/// @nodoc
class __$MealSuggestionCopyWithImpl<$Res>
    implements _$MealSuggestionCopyWith<$Res> {
  __$MealSuggestionCopyWithImpl(this._self, this._then);

  final _MealSuggestion _self;
  final $Res Function(_MealSuggestion) _then;

/// Create a copy of MealSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? ingredients = null,Object? instructions = null,Object? minAgeMonths = null,Object? sourceDocument = null,Object? nutritionHighlights = null,Object? missingIngredients = null,}) {
  return _then(_MealSuggestion(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,minAgeMonths: null == minAgeMonths ? _self.minAgeMonths : minAgeMonths // ignore: cast_nullable_to_non_nullable
as int,sourceDocument: null == sourceDocument ? _self.sourceDocument : sourceDocument // ignore: cast_nullable_to_non_nullable
as String,nutritionHighlights: null == nutritionHighlights ? _self._nutritionHighlights : nutritionHighlights // ignore: cast_nullable_to_non_nullable
as List<String>,missingIngredients: null == missingIngredients ? _self._missingIngredients : missingIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
