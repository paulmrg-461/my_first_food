import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/blocs/baby/baby_cubit.dart';
import '../../../application/blocs/baby/baby_state.dart';
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del Bebé')),
      body: BlocConsumer<BabyCubit, BabyState>(
        listener: (context, state) {
          if (state is BabyLoaded) {
            _nameCtrl.text = state.baby.name;
            _birthDate = state.baby.birthDate;
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
                  decoration: const InputDecoration(
                    labelText: 'Nombre del bebé',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.child_care),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    _birthDate == null
                        ? 'Seleccionar fecha de nacimiento'
                        : 'Nacido: ${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _birthDate ?? DateTime.now().subtract(const Duration(days: 180)),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _birthDate = picked);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text('Guardar'),
                  ),
                ),
                if (state is BabyError)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: Text(state.message, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty || _birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa nombre y fecha de nacimiento')),
      );
      return;
    }
    context.read<BabyCubit>().save(Baby(
          id: 'baby_1',
          name: _nameCtrl.text.trim(),
          birthDate: _birthDate!,
        ));
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
