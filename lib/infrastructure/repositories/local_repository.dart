import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/baby.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/meal_suggestion.dart';
import '../../domain/repositories/i_local_repository.dart';
import '../datasources/local/hive_local_datasource.dart';
import '../datasources/remote/firestore_sync_datasource.dart';

class LocalRepository implements ILocalRepository {
  final HiveLocalDatasource _local;
  final FirestoreSyncDatasource _cloud;
  final FirebaseAuth _auth;

  LocalRepository(this._local, this._cloud, this._auth);

  String? get _uid => _auth.currentUser?.uid;

  // Fires Firestore write in background — never blocks the caller.
  void _cloudSaveBaby(Baby baby) {
    final uid = _uid;
    if (uid != null) _cloud.saveBaby(uid, baby);
  }

  void _cloudSaveIngredients(List<Ingredient> ingredients) {
    final uid = _uid;
    if (uid != null) _cloud.saveIngredients(uid, ingredients);
  }

  @override
  Future<Either<Failure, Baby?>> getBaby() async {
    try {
      Baby? baby = await _local.getBaby();
      // New device / fresh install: pull from Firestore once.
      if (baby == null) {
        final uid = _uid;
        if (uid != null) {
          final cloudBaby = await _cloud.fetchBaby(uid);
          if (cloudBaby != null) {
            await _local.saveBaby(cloudBaby);
            final cloudIngredients = await _cloud.fetchIngredients(uid);
            await _local.saveIngredients(cloudIngredients);
            baby = cloudBaby;
          }
        }
      }
      return Right(baby);
    } on LocalStorageException catch (e) {
      return Left(LocalStorageFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveBaby(Baby baby) async {
    try {
      await _local.saveBaby(baby);
      _cloudSaveBaby(baby);
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
      _cloudSaveIngredients(ingredients);
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

  @override
  Future<List<ChatMessage>> getChatHistory() => _local.getChatHistory();

  @override
  Future<void> saveChatHistory(List<ChatMessage> messages) =>
      _local.saveChatHistory(messages);

  @override
  Future<void> clearChatHistory() => _local.clearChatHistory();
}
