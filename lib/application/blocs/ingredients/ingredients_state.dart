import 'package:equatable/equatable.dart';
import '../../../domain/entities/ingredient.dart';

sealed class IngredientsState extends Equatable {
  const IngredientsState();
  @override
  List<Object?> get props => [];
}

final class IngredientsInitial extends IngredientsState {
  const IngredientsInitial();
}

final class IngredientsLoading extends IngredientsState {
  const IngredientsLoading();
}

final class IngredientsLoaded extends IngredientsState {
  final List<Ingredient> ingredients;
  const IngredientsLoaded(this.ingredients);
  @override
  List<Object?> get props => [ingredients];
}

final class IngredientsError extends IngredientsState {
  final String message;
  const IngredientsError(this.message);
  @override
  List<Object?> get props => [message];
}
