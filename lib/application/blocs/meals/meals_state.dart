import 'package:equatable/equatable.dart';
import '../../../domain/entities/meal_suggestion.dart';
import '../../../domain/entities/shopping_item.dart';

sealed class MealsState extends Equatable {
  const MealsState();
  @override
  List<Object?> get props => [];
}

final class MealsInitial extends MealsState {
  const MealsInitial();
}

final class MealsLoading extends MealsState {
  const MealsLoading();
}

final class MealsLoaded extends MealsState {
  final List<MealSuggestion> suggestions;
  const MealsLoaded(this.suggestions);
  @override
  List<Object?> get props => [suggestions];
}

final class ShoppingLoaded extends MealsState {
  final List<ShoppingItem> items;
  const ShoppingLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

final class MealsError extends MealsState {
  final String message;
  const MealsError(this.message);
  @override
  List<Object?> get props => [message];
}
