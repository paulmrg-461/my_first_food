// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealSuggestion _$MealSuggestionFromJson(Map<String, dynamic> json) =>
    _MealSuggestion(
      title: json['title'] as String,
      description: json['description'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      instructions: json['instructions'] as String,
      minAgeMonths: (json['minAgeMonths'] as num).toInt(),
      sourceDocument: json['sourceDocument'] as String? ?? '',
      nutritionHighlights:
          (json['nutritionHighlights'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      missingIngredients:
          (json['missingIngredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MealSuggestionToJson(_MealSuggestion instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'minAgeMonths': instance.minAgeMonths,
      'sourceDocument': instance.sourceDocument,
      'nutritionHighlights': instance.nutritionHighlights,
      'missingIngredients': instance.missingIngredients,
    };
