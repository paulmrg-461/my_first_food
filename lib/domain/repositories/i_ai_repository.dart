import 'package:dartz/dartz.dart';
import '../entities/meal_suggestion.dart';
import '../entities/shopping_item.dart';
import '../entities/health_insight.dart';
import '../../core/error/failures.dart';

abstract class IAiRepository {
  Future<Either<Failure, List<MealSuggestion>>> suggestMeals({
    required int babyAgeMonths,
    required List<String> availableIngredients,
  });

  Future<Either<Failure, List<ShoppingItem>>> getShoppingList({
    required int babyAgeMonths,
    required List<String> availableIngredients,
    int desiredMealsCount = 3,
  });

  Future<Either<Failure, HealthInsight>> getHealthInsight({
    required String ingredient,
    required int babyAgeMonths,
  });

  Future<Either<Failure, void>> ensureFilesUploaded();
}
