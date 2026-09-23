enum ChatRole { user, assistant }

class ChatMessage {
  final ChatRole role;
  final String text;
  final bool isError;

  const ChatMessage({
    required this.role,
    required this.text,
    this.isError = false,
  });
}
