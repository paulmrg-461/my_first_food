import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/blocs/baby/baby_cubit.dart';
import '../../../application/blocs/baby/baby_state.dart';
import '../../../application/blocs/chat/chat_cubit.dart';
import '../../../application/blocs/chat/chat_state.dart';
import '../../../application/blocs/ingredients/ingredients_cubit.dart';
import '../../../application/blocs/theme/theme_cubit.dart';
import '../../../domain/entities/chat_message.dart';
import '../../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final babyState = context.read<BabyCubit>().state;
    if (babyState is! BabyLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero configura el perfil del bebé')),
      );
      return;
    }

    _controller.clear();
    context.read<ChatCubit>().sendMessage(
          text,
          babyAgeMonths: babyState.baby.ageInMonths,
          availableIngredients: context.read<IngredientsCubit>().ingredientNames,
        );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente de Nutrición'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Limpiar chat',
            onPressed: () => context.read<ChatCubit>().clearChat(),
          ),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => IconButton(
              icon: Icon(mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => context.read<ThemeCubit>().toggle(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _FreeKeysBanner(),
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatUpdated || state is ChatLoading) _scrollToBottom();
              },
              builder: (context, state) {
                final messages = switch (state) {
                  ChatLoading s => s.messages,
                  ChatUpdated s => s.messages,
                  ChatError s => s.messages,
                  _ => <ChatMessage>[],
                };

                if (messages.isEmpty && state is ChatInitial) {
                  return _WelcomeState(
                    onSuggestion: (text) {
                      _controller.text = text;
                      _send(context);
                    },
                  );
                }

                final isLoading = state is ChatLoading;
                final isError = state is ChatError;
                final extraItems = (isLoading ? 1 : 0) + (isError ? 1 : 0);

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: messages.length + extraItems,
                  itemBuilder: (context, i) {
                    if (i < messages.length) return _MessageBubble(message: messages[i]);
                    if (isLoading) return const _TypingIndicator();
                    return _ErrorChip(message: (state as ChatError).message);
                  },
                );
              },
            ),
          ),
          _InputBar(controller: _controller, onSend: () => _send(context)),
        ],
      ),
    );
  }
}

class _FreeKeysBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.accent.withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 12, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            'Usando claves gratuitas · sin costo de facturación',
            style: TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _WelcomeState extends StatelessWidget {
  final void Function(String) onSuggestion;
  const _WelcomeState({required this.onSuggestion});

  @override
  Widget build(BuildContext context) {
    const suggestions = [
      '¿Qué le preparo con lo que tengo?',
      '¿Es buena la zanahoria para mi bebé?',
      '¿Qué debo comprar esta semana?',
      'Dame una receta con aguacate',
    ];

    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final chipBgAlpha = isDark ? 0.08 : 0.15;
    final chipBorderAlpha = isDark ? 0.2 : 0.4;
    final chipForeground =
        isDark ? AppColors.primaryLight : AppColors.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Hero card
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
            child: const Column(
              children: [
                Text('🤱', style: TextStyle(fontSize: 56)),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Tu asistente de\nnutrición pediátrica',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Pregúntame sobre recetas, ingredientes\no la alimentación de tu bebé.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sugerencias para empezar:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.muted,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: suggestions
                .map((s) => ActionChip(
                      avatar: Icon(Icons.chat_bubble_outline_rounded,
                          size: 14, color: chipForeground),
                      label: Text(s,
                          style: TextStyle(
                              fontSize: 12, color: chipForeground)),
                      onPressed: () => onSuggestion(s),
                      backgroundColor:
                          AppColors.primary.withValues(alpha: chipBgAlpha),
                      side: BorderSide(
                          color: AppColors.primary
                              .withValues(alpha: chipBorderAlpha)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSpacing.sm,
        left: isUser ? AppSpacing.xl : 0,
        right: isUser ? 0 : AppSpacing.xl,
      ),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.smart_toy, size: 16, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Text(
                message.content,
                style: TextStyle(color: isUser ? Colors.white : null),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: AppSpacing.sm),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.smart_toy, size: 16, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const SizedBox(
              width: 40,
              height: 20,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorChip extends StatelessWidget {
  final String message;
  const _ErrorChip({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 16, color: Colors.red),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(message, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final isLoading = state is ChatLoading;
        return Container(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
            top: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isLoading,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => isLoading ? null : onSend(),
                  decoration: InputDecoration(
                    hintText: 'Pregúntame algo...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton(
                onPressed: isLoading ? null : onSend,
                style: FilledButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(AppSpacing.md),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send),
              ),
            ],
          ),
        );
      },
    );
  }
}
