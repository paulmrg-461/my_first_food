import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/baby.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/ingredient.dart';
import '../../../domain/entities/meal_suggestion.dart';

const _boxName = 'my_first_food';
const _keyBaby = 'baby';
const _keyIngredients = 'ingredients';
const _keyFileUris = 'gemini_file_uris';
const _keyFileUrisExpiry = 'gemini_file_uris_expiry';
const _keyCachedSuggestions = 'cached_suggestions';
const _keyChatHistory = 'chat_history';
const _maxChatPersisted = 100;

class HiveLocalDatasource {
  Box? _box;

  Future<Box> get _openBox async {
    _box ??= await Hive.openBox(_boxName);
    return _box!;
  }

  Future<Baby?> getBaby() async {
    try {
      final box = await _openBox;
      final raw = box.get(_keyBaby) as String?;
      if (raw == null) return null;
      return Baby.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      throw LocalStorageException('getBaby failed: $e');
    }
  }

  Future<void> saveBaby(Baby baby) async {
    final box = await _openBox;
    await box.put(_keyBaby, jsonEncode(baby.toJson()));
  }

  Future<List<Ingredient>> getIngredients() async {
    try {
      final box = await _openBox;
      final raw = box.get(_keyIngredients) as String?;
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw LocalStorageException('getIngredients failed: $e');
    }
  }

  Future<void> saveIngredients(List<Ingredient> ingredients) async {
    final box = await _openBox;
    await box.put(
      _keyIngredients,
      jsonEncode(ingredients.map((i) => i.toJson()).toList()),
    );
  }

  Future<List<MealSuggestion>> getCachedSuggestions() async {
    try {
      final box = await _openBox;
      final raw = box.get(_keyCachedSuggestions) as String?;
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => MealSuggestion.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> cacheSuggestions(List<MealSuggestion> suggestions) async {
    final box = await _openBox;
    await box.put(
      _keyCachedSuggestions,
      jsonEncode(suggestions.map((s) => s.toJson()).toList()),
    );
  }

  Future<List<String>?> getFileUris() async {
    final box = await _openBox;
    final raw = box.get(_keyFileUris) as String?;
    if (raw == null) return null;
    return List<String>.from(jsonDecode(raw) as List);
  }

  Future<void> saveFileUris(List<String> uris, {required DateTime expiresAt}) async {
    final box = await _openBox;
    await box.put(_keyFileUris, jsonEncode(uris));
    await box.put(_keyFileUrisExpiry, expiresAt.toIso8601String());
  }

  Future<void> clearFileUris() async {
    final box = await _openBox;
    await box.delete(_keyFileUris);
    await box.delete(_keyFileUrisExpiry);
  }

  Future<List<ChatMessage>> getChatHistory() async {
    try {
      final box = await _openBox;
      final raw = box.get(_keyChatHistory) as String?;
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveChatHistory(List<ChatMessage> messages) async {
    final box = await _openBox;
    final capped = messages.length > _maxChatPersisted
        ? messages.sublist(messages.length - _maxChatPersisted)
        : messages;
    await box.put(
      _keyChatHistory,
      jsonEncode(capped.map((m) => m.toJson()).toList()),
    );
  }

  Future<void> clearChatHistory() async {
    final box = await _openBox;
    await box.delete(_keyChatHistory);
  }

  Future<bool> areFileUrisValid() async {
    final box = await _openBox;
    final uris = box.get(_keyFileUris) as String?;
    final expiryRaw = box.get(_keyFileUrisExpiry) as String?;
    if (uris == null || expiryRaw == null) return false;
    final expiry = DateTime.tryParse(expiryRaw);
    if (expiry == null) return false;
    return DateTime.now().isBefore(expiry);
  }
}
