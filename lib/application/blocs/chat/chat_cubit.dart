import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/repositories/i_ai_repository.dart';
import '../../../domain/repositories/i_local_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final IAiRepository _repo;
  final ILocalRepository _local;
  final List<ChatMessage> _messages = [];

  // Sent to AI: last 20. Persisted: last 100 (capped in datasource).
  static const _maxHistory = 20;

  ChatCubit(this._repo, this._local) : super(ChatInitial());

  Future<void> init() async {
    final history = await _local.getChatHistory();
    if (history.isEmpty) return;
    _messages
      ..clear()
      ..addAll(history);
    emit(ChatUpdated(List.from(_messages)));
  }

  Future<void> sendMessage(
    String text, {
    required int babyAgeMonths,
    required List<String> availableIngredients,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _messages.add(ChatMessage(role: 'user', content: trimmed, timestamp: DateTime.now()));
    emit(ChatLoading(List.from(_messages)));

    final historyToSend = _messages.length > 1
        ? _messages.sublist(
            _messages.length > _maxHistory + 1 ? _messages.length - _maxHistory - 1 : 0,
            _messages.length - 1,
          )
        : <ChatMessage>[];

    final result = await _repo.sendChatMessage(
      history: historyToSend,
      userMessage: trimmed,
      babyAgeMonths: babyAgeMonths,
      availableIngredients: availableIngredients,
    );

    result.fold(
      (failure) => emit(ChatError(List.from(_messages), failure.message)),
      (response) {
        _messages.add(
          ChatMessage(role: 'model', content: response, timestamp: DateTime.now()),
        );
        _local.saveChatHistory(List.from(_messages));
        emit(ChatUpdated(List.from(_messages)));
      },
    );
  }

  Future<void> clearChat() async {
    _messages.clear();
    await _local.clearChatHistory();
    emit(ChatInitial());
  }
}
