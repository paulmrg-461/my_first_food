import 'package:freezed_annotation/freezed_annotation.dart';
import 'ingredient.dart';

part 'shopping_item.freezed.dart';
part 'shopping_item.g.dart';

@freezed
abstract class ShoppingItem with _$ShoppingItem {
  const factory ShoppingItem({
    required Ingredient ingredient,
    required String reason,
    @Default(0.0) double estimatedCost,
  }) = _ShoppingItem;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemFromJson(json);
}
