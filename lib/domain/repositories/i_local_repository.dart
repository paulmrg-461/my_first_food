import 'package:dartz/dartz.dart';
import '../entities/baby.dart';
import '../entities/chat_message.dart';
import '../entities/ingredient.dart';
import '../entities/meal_suggestion.dart';
import '../../core/error/failures.dart';

abstract class ILocalRepository {
  Future<Either<Failure, Baby?>> getBaby();
  Future<Either<Failure, void>> saveBaby(Baby baby);

  Future<Either<Failure, List<Ingredient>>> getIngredients();
  Future<Either<Failure, void>> saveIngredients(List<Ingredient> ingredients);
  Future<Either<Failure, void>> addIngredient(Ingredient ingredient);
  Future<Either<Failure, void>> removeIngredient(String id);

  Future<Either<Failure, List<MealSuggestion>>> getCachedSuggestions();
  Future<Either<Failure, void>> cacheSuggestions(List<MealSuggestion> suggestions);

  Future<Either<Failure, List<String>?>> getGeminiFileUris();
  Future<Either<Failure, void>> saveGeminiFileUris(
    List<String> uris, {
    required DateTime expiresAt,
  });
  Future<bool> areFileUrisValid();
  Future<void> clearFileUris();

  Future<List<ChatMessage>> getChatHistory();
  Future<void> saveChatHistory(List<ChatMessage> messages);
  Future<void> clearChatHistory();
}
