import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/blocs/baby/baby_cubit.dart';
import '../../../application/blocs/baby/baby_state.dart';
import '../../../application/blocs/ingredients/ingredients_cubit.dart';
import '../../../application/blocs/meals/meals_cubit.dart';
import '../../../application/blocs/meals/meals_state.dart';
import '../../../application/blocs/theme/theme_cubit.dart';
import '../../../domain/entities/meal_suggestion.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_logo.dart';

class SuggestionsScreen extends StatelessWidget {
  const SuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppLogo(),
        title: const Text('Mi Primera Comida'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => IconButton(
              icon: Icon(mode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
              onPressed: () => context.read<ThemeCubit>().toggle(),
            ),
          ),
        ],
      ),
      body: BlocBuilder<MealsCubit, MealsState>(
        builder: (context, state) {
          if (state is MealsLoading) return const _LoadingState();
          if (state is MealsLoaded) return _SuggestionsList(suggestions: state.suggestions);
          if (state is MealsError) {
            return _ErrorState(
              message: state.message,
              onRetry: () => _retryWithFreshUpload(context),
            );
          }
          return _IdleState(onTap: () => _suggest(context));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _suggest(context),
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Sugerir recetas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _suggest(BuildContext context) {
    final babyState = context.read<BabyCubit>().state;
    if (babyState is! BabyLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Primero configura el perfil del bebé'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    context.read<MealsCubit>().suggest(
          babyAgeMonths: babyState.baby.ageInMonths,
          availableIngredients: context.read<IngredientsCubit>().ingredientNames,
        );
  }

  void _retryWithFreshUpload(BuildContext context) {
    final babyState = context.read<BabyCubit>().state;
    if (babyState is! BabyLoaded) return;
    context.read<MealsCubit>().retryWithFreshUpload(
          babyAgeMonths: babyState.baby.ageInMonths,
          availableIngredients: context.read<IngredientsCubit>().ingredientNames,
        );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Consultando los libros de recetas...',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'La primera vez puede tomar 1-2 minutos\nwhile se suben los PDFs a Gemini',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdleState extends StatelessWidget {
  final VoidCallback onTap;
  const _IdleState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final babyState = context.watch<BabyCubit>().state;
    final babyName = babyState is BabyLoaded ? babyState.baby.name : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Hero gradient card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo_no_bg.png',
                  height: 80,
                  color: Colors.white,
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (context, e, _) => const Icon(
                    Icons.restaurant,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  babyName != null
                      ? '¿Qué le preparamos\nhoy a $babyName? 🍼'
                      : '¿Qué cocinamos\nhoy? 🍼',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Recetas personalizadas basadas en\nlos ingredientes que tienes',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Tips row
          Row(
            children: [
              _TipCard(
                icon: Icons.menu_book_rounded,
                color: AppColors.secondary,
                title: '5 libros',
                subtitle: 'de recetas',
              ),
              const SizedBox(width: AppSpacing.sm),
              _TipCard(
                icon: Icons.verified_rounded,
                color: AppColors.accent,
                title: 'Seguro',
                subtitle: 'para tu bebé',
              ),
              const SizedBox(width: AppSpacing.sm),
              _TipCard(
                icon: Icons.eco_rounded,
                color: AppColors.primary,
                title: 'Con lo\nque tienes',
                subtitle: 'en casa',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Sugerir recetas ahora'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _TipCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                height: 1.2,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Algo salió mal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Limpiar caché y reintentar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
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
      itemBuilder: (context, i) => _MealCard(meal: suggestions[i], index: i),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealSuggestion meal;
  final int index;
  const _MealCard({required this.meal, required this.index});

  static const _gradients = [
    [Color(0xFFE8677A), Color(0xFFFFA552)],
    [Color(0xFF7DC4B0), Color(0xFF42A5F5)],
    [Color(0xFFFFA552), Color(0xFFFFD49E)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[index % _gradients.length];
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 2,
      shadowColor: colors[0].withValues(alpha: 0.2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          leading: null,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient header strip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        meal.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (meal.minAgeMonths > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '+${meal.minAgeMonths}m',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              ),
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Text(
                  meal.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: AppColors.muted),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (meal.nutritionHighlights.isNotEmpty) ...[
                    const _SectionLabel('Beneficios nutricionales'),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: meal.nutritionHighlights
                          .map((h) => Chip(
                                label: Text(h),
                                avatar: const Icon(
                                  Icons.favorite_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                                labelStyle: const TextStyle(fontSize: 11),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  const _SectionLabel('Preparación'),
                  const SizedBox(height: AppSpacing.xs),
                  Text(meal.instructions, style: const TextStyle(fontSize: 13, height: 1.5)),
                  if (meal.missingIngredients.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🛒 Te falta comprar:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.secondary,
                            ),
                          ),
                          ...meal.missingIngredients.map(
                            (m) => Text(
                              '• $m',
                              style: const TextStyle(fontSize: 12, color: AppColors.muted),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (meal.sourceDocument.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        const Icon(Icons.menu_book_outlined, size: 12, color: AppColors.muted),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            meal.sourceDocument,
                            style: const TextStyle(color: AppColors.muted, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: AppColors.onBackground,
      ),
    );
  }
}
