// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ingredient _$IngredientFromJson(Map<String, dynamic> json) => _Ingredient(
  id: json['id'] as String,
  name: json['name'] as String,
  quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
  unit: json['unit'] as String? ?? 'unidad',
  isAvailable: json['isAvailable'] as bool? ?? true,
);

Map<String, dynamic> _$IngredientToJson(_Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'isAvailable': instance.isAvailable,
    };
