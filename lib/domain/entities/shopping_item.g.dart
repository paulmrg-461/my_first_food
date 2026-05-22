// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShoppingItem _$ShoppingItemFromJson(Map<String, dynamic> json) =>
    _ShoppingItem(
      ingredient: Ingredient.fromJson(
        json['ingredient'] as Map<String, dynamic>,
      ),
      reason: json['reason'] as String,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ShoppingItemToJson(_ShoppingItem instance) =>
    <String, dynamic>{
      'ingredient': instance.ingredient,
      'reason': instance.reason,
      'estimatedCost': instance.estimatedCost,
    };
