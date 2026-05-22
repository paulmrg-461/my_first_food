import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/blocs/baby/baby_cubit.dart';
import '../../../application/blocs/baby/baby_state.dart';
import '../../../application/blocs/ingredients/ingredients_cubit.dart';
import '../../../application/blocs/meals/meals_cubit.dart';
import '../../../application/blocs/meals/meals_state.dart';
import '../../../domain/entities/meal_suggestion.dart';
import '../../theme/app_theme.dart';

class SuggestionsScreen extends StatelessWidget {
  const SuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('¿Qué le preparo?')),
      body: BlocBuilder<MealsCubit, MealsState>(
        builder: (context, state) {
          if (state is MealsLoading) {
            return const _LoadingState();
          }
          if (state is MealsLoaded) {
            return _SuggestionsList(suggestions: state.suggestions);
          }
          if (state is MealsError) {
            return _ErrorState(message: state.message);
          }
          return _IdleState(
            onTap: () => _suggest(context),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _suggest(context),
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Sugerir recetas'),
      ),
    );
  }

  void _suggest(BuildContext context) {
    final babyState = context.read<BabyCubit>().state;
    if (babyState is! BabyLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero configura el perfil del bebé')),
      );
      return;
    }

    final ingredients = context.read<IngredientsCubit>().ingredientNames;
    context.read<MealsCubit>().suggest(
          babyAgeMonths: babyState.baby.ageInMonths,
          availableIngredients: ingredients,
        );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppSpacing.md),
          Text('Consultando los libros de recetas...', textAlign: TextAlign.center),
          SizedBox(height: AppSpacing.sm),
          Text(
            '(Primera vez puede tomar 1-2 min\npara subir los PDFs a Gemini)',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _IdleState extends StatelessWidget {
  final VoidCallback onTap;
  const _IdleState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant_menu, size: 80, color: AppColors.primary),
          const SizedBox(height: AppSpacing.md),
          const Text('Toca el botón para obtener', style: TextStyle(color: AppColors.muted)),
          const Text('ideas de recetas para tu bebé', style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Sugerir recetas'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

class _SuggestionsList extends StatelessWidget {
  final List<MealSuggestion> suggestions;
  const _SuggestionsList({required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: suggestions.length,
      itemBuilder: (context, i) => _MealCard(meal: suggestions[i]),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealSuggestion meal;
  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ExpansionTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.restaurant, color: Colors.white),
        ),
        title: Text(meal.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(meal.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (meal.nutritionHighlights.isNotEmpty) ...[
                  const Text('Nutrición:', style: TextStyle(fontWeight: FontWeight.w600)),
                  ...meal.nutritionHighlights.map((h) => Text('• $h')),
                  const SizedBox(height: AppSpacing.sm),
                ],
                const Text('Preparación:', style: TextStyle(fontWeight: FontWeight.w600)),
                Text(meal.instructions),
                if (meal.missingIngredients.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const Text('Te falta:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange)),
                  ...meal.missingIngredients.map((m) => Text('• $m', style: const TextStyle(color: Colors.orange))),
                ],
                if (meal.sourceDocument.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text('Fuente: ${meal.sourceDocument}',
                      style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
