import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/baby.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/meal_suggestion.dart';
import '../../domain/repositories/i_local_repository.dart';
import '../datasources/local/hive_local_datasource.dart';

class LocalRepository implements ILocalRepository {
  final HiveLocalDatasource _local;
  LocalRepository(this._local);

  @override
  Future<Either<Failure, Baby?>> getBaby() async {
    try {
      return Right(await _local.getBaby());
    } on LocalStorageException catch (e) {
      return Left(LocalStorageFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveBaby(Baby baby) async {
    try {
      await _local.saveBaby(baby);
      return const Right(null);
    } on LocalStorageException catch (e) {
      return Left(LocalStorageFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Ingredient>>> getIngredients() async {
    try {
      return Right(await _local.getIngredients());
    } on LocalStorageException catch (e) {
      return Left(LocalStorageFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveIngredients(List<Ingredient> ingredients) async {
    try {
      await _local.saveIngredients(ingredients);
      return const Right(null);
    } on LocalStorageException catch (e) {
      return Left(LocalStorageFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addIngredient(Ingredient ingredient) async {
    final result = await getIngredients();
    return result.fold(Left.new, (list) async {
      final updated = [...list, ingredient];
      return saveIngredients(updated);
    });
  }

  @override
  Future<Either<Failure, void>> removeIngredient(String id) async {
    final result = await getIngredients();
    return result.fold(Left.new, (list) async {
      final updated = list.where((i) => i.id != id).toList();
      return saveIngredients(updated);
    });
  }

  @override
  Future<Either<Failure, List<MealSuggestion>>> getCachedSuggestions() async {
    try {
      return Right(await _local.getCachedSuggestions());
    } catch (e) {
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, void>> cacheSuggestions(List<MealSuggestion> suggestions) async {
    try {
      await _local.cacheSuggestions(suggestions);
      return const Right(null);
    } on LocalStorageException catch (e) {
      return Left(LocalStorageFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>?>> getGeminiFileUris() async {
    return Right(await _local.getFileUris());
  }

  @override
  Future<Either<Failure, void>> saveGeminiFileUris(
    List<String> uris, {
    required DateTime expiresAt,
  }) async {
    await _local.saveFileUris(uris, expiresAt: expiresAt);
    return const Right(null);
  }

  @override
  Future<bool> areFileUrisValid() => _local.areFileUrisValid();

  @override
  Future<void> clearFileUris() => _local.clearFileUris();
}
