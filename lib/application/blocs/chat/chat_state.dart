import '../../../domain/entities/chat_message.dart';

sealed class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  final List<ChatMessage> messages;
  ChatLoading(this.messages);
}

class ChatUpdated extends ChatState {
  final List<ChatMessage> messages;
  ChatUpdated(this.messages);
}

class ChatError extends ChatState {
  final List<ChatMessage> messages;
  final String message;
  ChatError(this.messages, this.message);
}
