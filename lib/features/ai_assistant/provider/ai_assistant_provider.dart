import 'package:flutter/material.dart';

class AIAssistantProvider extends ChangeNotifier {
  final TextEditingController _messageController = TextEditingController();
  TextEditingController get messageController => _messageController;

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      // In a real app, send the message to the AI and update chat history.
      _messageController.clear();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
