import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/baby.dart';
import '../../../domain/entities/ingredient.dart';

class FirestoreSyncDatasource {
  final FirebaseFirestore _db;

  FirestoreSyncDatasource(this._db);

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  Future<Baby?> fetchBaby(String uid) async {
    try {
      final snap = await _userDoc(uid).get();
      final data = snap.data();
      if (data == null || !data.containsKey('baby')) return null;
      return Baby.fromJson(Map<String, dynamic>.from(data['baby'] as Map));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveBaby(String uid, Baby baby) async {
    try {
      await _userDoc(uid).set({'baby': baby.toJson()}, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<List<Ingredient>> fetchIngredients(String uid) async {
    try {
      final snap = await _userDoc(uid).get();
      final data = snap.data();
      if (data == null || !data.containsKey('ingredients')) return [];
      final list = data['ingredients'] as List<dynamic>;
      return list
          .map((e) => Ingredient.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveIngredients(String uid, List<Ingredient> ingredients) async {
    try {
      await _userDoc(uid).set(
        {'ingredients': ingredients.map((i) => i.toJson()).toList()},
        SetOptions(merge: true),
      );
    } catch (_) {}
  }
}
