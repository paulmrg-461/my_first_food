import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/blocs/ingredients/ingredients_cubit.dart';
import '../../../application/blocs/ingredients/ingredients_state.dart';
import '../../../application/blocs/theme/theme_cubit.dart';
import '../../../domain/entities/ingredient.dart';
import '../../theme/app_theme.dart';

class IngredientsScreen extends StatelessWidget {
  const IngredientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Ingredientes'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => IconButton(
              icon: Icon(mode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
              onPressed: () => context.read<ThemeCubit>().toggle(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Agregar'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<IngredientsCubit, IngredientsState>(
        builder: (context, state) {
          if (state is IngredientsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is IngredientsLoaded && state.ingredients.isEmpty) {
            return const _EmptyState();
          }
          if (state is IngredientsLoaded) {
            return _IngredientsGrid(ingredients: state.ingredients);
          }
          if (state is IngredientsError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: AppColors.muted)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _AddIngredientDialog(
        onAdd: (ingredient) => context.read<IngredientsCubit>().add(ingredient),
      ),
    );
  }
}

class _IngredientsGrid extends StatelessWidget {
  final List<Ingredient> ingredients;
  const _IngredientsGrid({required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header count
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${ingredients.length} ingrediente${ingredients.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Chips
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.xxl + AppSpacing.lg,
            ),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: ingredients
                  .map((i) => _IngredientChip(ingredient: i))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _IngredientChip extends StatelessWidget {
  final Ingredient ingredient;
  const _IngredientChip({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final hasQty = ingredient.quantity > 0;
    return Chip(
      avatar: const Icon(Icons.eco_rounded, size: 16, color: AppColors.accent),
      label: Text(
        hasQty
            ? '${ingredient.name} · ${ingredient.quantity.toStringAsFixed(ingredient.quantity % 1 == 0 ? 0 : 1)} ${ingredient.unit}'
            : ingredient.name,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      deleteIcon: const Icon(Icons.close_rounded, size: 16, color: AppColors.muted),
      onDeleted: () => context.read<IngredientsCubit>().remove(ingredient.id),
      backgroundColor: AppColors.accent.withValues(alpha: 0.1),
      side: BorderSide(color: AppColors.accent.withValues(alpha: 0.25)),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🛒', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Sin ingredientes aún',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Agrega lo que tienes en casa y\nla IA usará eso para sugerir recetas.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddIngredientDialog extends StatefulWidget {
  final void Function(Ingredient) onAdd;
  const _AddIngredientDialog({required this.onAdd});

  @override
  State<_AddIngredientDialog> createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<_AddIngredientDialog> {
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  String _unit = 'unidad';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.eco_rounded, color: AppColors.accent),
          SizedBox(width: AppSpacing.sm),
          Text('Agregar ingrediente'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Ingrediente',
              hintText: 'ej: zanahoria, manzana...',
              prefixIcon: Icon(Icons.local_grocery_store_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _qtyCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    hintText: '0',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _unit,
                    items: ['unidad', 'g', 'kg', 'ml', 'taza']
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (v) => setState(() => _unit = v ?? _unit),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: AppColors.muted)),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Agregar'),
          onPressed: () {
            if (_nameCtrl.text.trim().isEmpty) return;
            widget.onAdd(Ingredient(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: _nameCtrl.text.trim(),
              quantity: double.tryParse(_qtyCtrl.text) ?? 0,
              unit: _unit,
            ));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
