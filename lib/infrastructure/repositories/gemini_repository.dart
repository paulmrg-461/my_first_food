import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../core/config/app_config.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/health_insight.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/meal_suggestion.dart';
import '../../domain/entities/shopping_item.dart';
import '../../domain/repositories/i_ai_repository.dart';
import '../datasources/local/hive_local_datasource.dart';
import '../datasources/remote/gemini_service.dart';

class GeminiRepository implements IAiRepository {
  final GeminiService _gemini;
  final HiveLocalDatasource _local;

  GeminiRepository(this._gemini, this._local);

  @override
  Future<Either<Failure, void>> ensureFilesUploaded() async {
    try {
      if (await _local.areFileUrisValid()) return const Right(null);
      final uris = await _gemini.uploadAllPdfs();
      await _local.saveFileUris(
        uris,
        expiresAt: DateTime.now().add(
          const Duration(hours: AppConfig.geminiFileExpiryHours),
        ),
      );
      return const Right(null);
    } on QuotaExhaustedException {
      return const Left(QuotaExhaustedFailure());
    } on FileUploadException catch (e) {
      return Left(FileUploadFailure(e.message));
    } catch (e) {
      return Left(AiFailure('Upload failed: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MealSuggestion>>> suggestMeals({
    required int babyAgeMonths,
    required List<String> availableIngredients,
  }) async {
    try {
      final uploadResult = await ensureFilesUploaded();
      if (uploadResult.isLeft()) return Left(uploadResult.fold(id, (_) => const AiFailure('')));

      final fileUris = await _local.getFileUris() ?? [];
      final prompt = _mealPrompt(babyAgeMonths, availableIngredients);
      final raw = await _gemini.generateContent(prompt, fileUris);
      final json = _extractJson(raw);
      final list = (json['suggestions'] as List<dynamic>)
          .map((e) => MealSuggestion.fromJson(e as Map<String, dynamic>))
          .toList();
      await _local.cacheSuggestions(list);
      return Right(list);
    } on QuotaExhaustedException {
      return const Left(QuotaExhaustedFailure());
    } catch (e) {
      return Left(AiFailure('suggestMeals failed: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ShoppingItem>>> getShoppingList({
    required int babyAgeMonths,
    required List<String> availableIngredients,
    int desiredMealsCount = 3,
  }) async {
    try {
      final uploadResult = await ensureFilesUploaded();
      if (uploadResult.isLeft()) return Left(uploadResult.fold(id, (_) => const AiFailure('')));

      final fileUris = await _local.getFileUris() ?? [];
      final prompt = _shoppingPrompt(babyAgeMonths, availableIngredients, desiredMealsCount);
      final raw = await _gemini.generateContent(prompt, fileUris);
      final json = _extractJson(raw);
      final list = (json['shopping_items'] as List<dynamic>).map((e) {
        final map = e as Map<String, dynamic>;
        return ShoppingItem(
          ingredient: Ingredient(
            id: map['name'] as String,
            name: map['name'] as String,
            quantity: (map['quantity'] as num?)?.toDouble() ?? 1,
            unit: map['unit'] as String? ?? 'unidad',
            isAvailable: false,
          ),
          reason: map['reason'] as String? ?? '',
        );
      }).toList();
      return Right(list);
    } on QuotaExhaustedException {
      return const Left(QuotaExhaustedFailure());
    } catch (e) {
      return Left(AiFailure('getShoppingList failed: $e'));
    }
  }

  @override
  Future<Either<Failure, HealthInsight>> getHealthInsight({
    required String ingredient,
    required int babyAgeMonths,
  }) async {
    try {
      final uploadResult = await ensureFilesUploaded();
      if (uploadResult.isLeft()) return Left(uploadResult.fold(id, (_) => const AiFailure('')));

      final fileUris = await _local.getFileUris() ?? [];
      final prompt = _healthPrompt(ingredient, babyAgeMonths);
      final raw = await _gemini.generateContent(prompt, fileUris);
      final json = _extractJson(raw);
      return Right(HealthInsight.fromJson(json));
    } on QuotaExhaustedException {
      return const Left(QuotaExhaustedFailure());
    } catch (e) {
      return Left(AiFailure('getHealthInsight failed: $e'));
    }
  }

  Map<String, dynamic> _extractJson(String raw) {
    final cleaned = raw
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();
    return jsonDecode(cleaned) as Map<String, dynamic>;
  }

  String _mealPrompt(int age, List<String> ingredients) => '''
Eres nutricionista pediátrico experto. Tienes acceso a libros de recetas para bebés en los documentos adjuntos.

Bebé de $age meses. Ingredientes disponibles: ${ingredients.isEmpty ? 'ingredientes básicos del hogar' : ingredients.join(', ')}.

REGLAS DE SEGURIDAD (OBLIGATORIAS):
- Solo recetas apropiadas para $age meses
${age < 12 ? '- PROHIBIDO: miel, sal añadida, azúcar, leche de vaca como bebida principal' : ''}
${age < 8 ? '- Texturas: purés suaves únicamente' : age < 10 ? '- Texturas: purés y aplastados' : '- Texturas: trozos blandos permitidos'}

Sugiere 3 recetas de los documentos adjuntos. Usa preferiblemente los ingredientes disponibles. Indica cuáles faltan.

Responde ÚNICAMENTE con este JSON (sin texto extra, sin markdown):
{
  "suggestions": [
    {
      "title": "string",
      "description": "string corto",
      "instructions": "pasos numerados",
      "ingredients": [{"name": "string", "quantity": 1.0, "unit": "string", "isAvailable": true}],
      "minAgeMonths": $age,
      "nutritionHighlights": ["beneficio 1", "beneficio 2"],
      "missingIngredients": ["ingrediente faltante"],
      "sourceDocument": "nombre del libro de donde viene"
    }
  ]
}''';

  String _shoppingPrompt(int age, List<String> available, int count) => '''
Eres nutricionista pediátrico experto. Bebé de $age meses.

Ingredientes disponibles: ${available.isEmpty ? 'ninguno' : available.join(', ')}.

Basándote en los documentos adjuntos, ¿qué $count ingredientes básicos debería comprar para preparar comidas variadas y nutritivas para un bebé de $age meses?

Responde ÚNICAMENTE con este JSON:
{
  "shopping_items": [
    {
      "name": "string",
      "quantity": 1.0,
      "unit": "string",
      "reason": "para qué receta o nutriente"
    }
  ]
}''';

  String _healthPrompt(String ingredient, int age) => '''
Eres nutricionista pediátrico experto. Bebé de $age meses.

Basándote en los documentos adjuntos, explica el impacto del ingrediente "$ingredient" en la salud de un bebé de $age meses.

Responde ÚNICAMENTE con este JSON:
{
  "ingredient": "$ingredient",
  "benefits": ["beneficio 1", "beneficio 2", "beneficio 3"],
  "warnings": ["advertencia si aplica"],
  "recommendedAgeMonths": $age,
  "preparationTip": "cómo prepararlo para $age meses"
}''';
}
