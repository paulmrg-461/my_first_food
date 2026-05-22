import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/ingredient.dart';
import '../../../domain/repositories/i_local_repository.dart';
import 'ingredients_state.dart';

class IngredientsCubit extends Cubit<IngredientsState> {
  final ILocalRepository _repo;

  IngredientsCubit(this._repo) : super(const IngredientsInitial());

  Future<void> load() async {
    emit(const IngredientsLoading());
    final result = await _repo.getIngredients();
    result.fold(
      (f) => emit(IngredientsError(f.message)),
      (list) => emit(IngredientsLoaded(list)),
    );
  }

  Future<void> add(Ingredient ingredient) async {
    final result = await _repo.addIngredient(ingredient);
    result.fold(
      (f) => emit(IngredientsError(f.message)),
      (_) => load(),
    );
  }

  Future<void> remove(String id) async {
    final result = await _repo.removeIngredient(id);
    result.fold(
      (f) => emit(IngredientsError(f.message)),
      (_) => load(),
    );
  }

  List<String> get ingredientNames {
    final state = this.state;
    if (state is IngredientsLoaded) {
      return state.ingredients.map((i) => i.name).toList();
    }
    return [];
  }
}
