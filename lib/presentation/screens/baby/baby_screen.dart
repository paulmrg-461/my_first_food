import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/blocs/baby/baby_cubit.dart';
import '../../../application/blocs/baby/baby_state.dart';
import '../../../application/blocs/theme/theme_cubit.dart';
import '../../../domain/entities/baby.dart';
import '../../theme/app_theme.dart';

class BabyScreen extends StatefulWidget {
  const BabyScreen({super.key});

  @override
  State<BabyScreen> createState() => _BabyScreenState();
}

class _BabyScreenState extends State<BabyScreen> {
  final _nameCtrl = TextEditingController();
  DateTime? _birthDate;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Bebé'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => IconButton(
              icon: Icon(mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
              tooltip: mode == ThemeMode.dark ? 'Tema claro' : 'Tema oscuro',
              onPressed: () => context.read<ThemeCubit>().toggle(),
            ),
          ),
        ],
      ),
      body: BlocConsumer<BabyCubit, BabyState>(
        listener: (context, state) {
          if (state is BabyLoaded) {
            setState(() {
              _nameCtrl.text = state.baby.name;
              _birthDate = state.baby.birthDate;
            });
          }
          if (state is BabyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BabyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is BabyLoaded) _AgeCard(baby: state.baby),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del bebé',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.child_care),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          _birthDate == null
                              ? 'Fecha de nacimiento *'
                              : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                          style: TextStyle(
                            color: _birthDate == null ? Colors.grey : null,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Guardar perfil', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now().subtract(const Duration(days: 180)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Fecha de nacimiento del bebé',
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe el nombre del bebé')),
      );
      return;
    }
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona la fecha de nacimiento')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await context.read<BabyCubit>().save(Baby(
          id: 'baby_1',
          name: name,
          birthDate: _birthDate!,
        ));

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Perfil guardado! 🎉'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class _AgeCard extends StatelessWidget {
  final Baby baby;
  const _AgeCard({required this.baby});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.child_friendly, size: 48, color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(baby.name, style: Theme.of(context).textTheme.headlineSmall),
          Text(
            '${baby.ageInMonths} meses',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
