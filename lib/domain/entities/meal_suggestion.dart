import 'package:freezed_annotation/freezed_annotation.dart';
import 'ingredient.dart';

part 'meal_suggestion.freezed.dart';
part 'meal_suggestion.g.dart';

@freezed
abstract class MealSuggestion with _$MealSuggestion {
  const factory MealSuggestion({
    required String title,
    required String description,
    required List<Ingredient> ingredients,
    required String instructions,
    required int minAgeMonths,
    @Default('') String sourceDocument,
    @Default([]) List<String> nutritionHighlights,
    @Default([]) List<String> missingIngredients,
  }) = _MealSuggestion;

  factory MealSuggestion.fromJson(Map<String, dynamic> json) =>
      _$MealSuggestionFromJson(json);
}
