class ChatMessage {
  final String role; // 'user' | 'model'
  final String content;
  final DateTime timestamp;

  const ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });
}
