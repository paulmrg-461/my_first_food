import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/i_local_repository.dart';
import '../../../domain/usecases/suggest_meals_usecase.dart';
import '../../../domain/usecases/get_shopping_list_usecase.dart';
import 'meals_state.dart';

class MealsCubit extends Cubit<MealsState> {
  final SuggestMealsUseCase _suggestMeals;
  final GetShoppingListUseCase _getShoppingList;
  final ILocalRepository _localRepo;

  MealsCubit(this._suggestMeals, this._getShoppingList, this._localRepo)
      : super(const MealsInitial());

  Future<void> retryWithFreshUpload({
    required int babyAgeMonths,
    required List<String> availableIngredients,
  }) async {
    await _localRepo.clearFileUris();
    await suggest(
      babyAgeMonths: babyAgeMonths,
      availableIngredients: availableIngredients,
    );
  }

  Future<void> suggest({
    required int babyAgeMonths,
    required List<String> availableIngredients,
  }) async {
    emit(const MealsLoading());
    final result = await _suggestMeals(
      babyAgeMonths: babyAgeMonths,
      availableIngredients: availableIngredients,
    );
    result.fold(
      (f) => emit(MealsError(f.message)),
      (suggestions) => emit(MealsLoaded(suggestions)),
    );
  }

  Future<void> loadShoppingList({
    required int babyAgeMonths,
    required List<String> availableIngredients,
  }) async {
    emit(const MealsLoading());
    final result = await _getShoppingList(
      babyAgeMonths: babyAgeMonths,
      availableIngredients: availableIngredients,
    );
    result.fold(
      (f) => emit(MealsError(f.message)),
      (items) => emit(ShoppingLoaded(items)),
    );
  }
}
