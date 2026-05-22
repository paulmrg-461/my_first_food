import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/blocs/ingredients/ingredients_cubit.dart';
import '../../../application/blocs/ingredients/ingredients_state.dart';
import '../../../domain/entities/ingredient.dart';
import '../../theme/app_theme.dart';

class IngredientsScreen extends StatelessWidget {
  const IngredientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Ingredientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
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
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.ingredients.length,
              itemBuilder: (context, i) {
                final ingredient = state.ingredients[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    leading: const Icon(Icons.eco, color: AppColors.primary),
                    title: Text(ingredient.name),
                    subtitle: ingredient.quantity > 0
                        ? Text('${ingredient.quantity} ${ingredient.unit}')
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () =>
                          context.read<IngredientsCubit>().remove(ingredient.id),
                    ),
                  ),
                );
              },
            );
          }
          if (state is IngredientsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    String unit = 'unidad';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar ingrediente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Nombre (ej: zanahoria)'),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: qtyCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                DropdownButton<String>(
                  value: unit,
                  items: ['unidad', 'g', 'kg', 'ml', 'taza']
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (v) => unit = v ?? unit,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              context.read<IngredientsCubit>().add(Ingredient(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameCtrl.text.trim(),
                    quantity: double.tryParse(qtyCtrl.text) ?? 0,
                    unit: unit,
                  ));
              Navigator.pop(ctx);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 72, color: AppColors.muted),
          SizedBox(height: AppSpacing.md),
          Text('Sin ingredientes aún', style: TextStyle(color: AppColors.muted)),
          SizedBox(height: AppSpacing.sm),
          Text('Toca + para agregar lo que tienes', style: TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ),
    );
  }
}
