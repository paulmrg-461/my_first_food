import 'package:dartz/dartz.dart';
import '../entities/shopping_item.dart';
import '../repositories/i_ai_repository.dart';
import '../../core/error/failures.dart';

class GetShoppingListUseCase {
  final IAiRepository _repo;
  GetShoppingListUseCase(this._repo);

  Future<Either<Failure, List<ShoppingItem>>> call({
    required int babyAgeMonths,
    required List<String> availableIngredients,
  }) =>
      _repo.getShoppingList(
        babyAgeMonths: babyAgeMonths,
        availableIngredients: availableIngredients,
      );
}
