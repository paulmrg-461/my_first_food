import 'package:dartz/dartz.dart';
import '../entities/meal_suggestion.dart';
import '../repositories/i_ai_repository.dart';
import '../../core/error/failures.dart';

class SuggestMealsUseCase {
  final IAiRepository _repo;
  SuggestMealsUseCase(this._repo);

  Future<Either<Failure, List<MealSuggestion>>> call({
    required int babyAgeMonths,
    required List<String> availableIngredients,
  }) =>
      _repo.suggestMeals(
        babyAgeMonths: babyAgeMonths,
        availableIngredients: availableIngredients,
      );
}
