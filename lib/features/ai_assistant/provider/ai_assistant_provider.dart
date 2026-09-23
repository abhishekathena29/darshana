import 'package:flutter/material.dart';
import '../../../core/services/app_config_repository.dart';
import '../../../core/services/groq_service.dart';
import '../model/chat_message.dart';

class AIAssistantProvider extends ChangeNotifier {
  final TextEditingController _messageController = TextEditingController();
  TextEditingController get messageController => _messageController;

  final AppConfigRepository _configRepository = AppConfigRepository();
  final GroqService _groqService = GroqService();

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  bool _isSending = false;
  bool get isSending => _isSending;

  static const _systemPrompt =
      'You are the Sacred Path Guide, a warm and knowledgeable assistant inside the '
      'Darshana app. You help pilgrims and travellers with temple visits, rituals, '
      'travel logistics, dress codes and cultural etiquette across Indian sacred sites. '
      'Keep answers concise, practical and respectful.';

  Future<void> sendMessage([String? text]) async {
    final content = (text ?? _messageController.text).trim();
    if (content.isEmpty || _isSending) return;

    _messageController.clear();
    _messages.add(ChatMessage(role: ChatRole.user, text: content));
    _isSending = true;
    notifyListeners();

    try {
      final config = await _configRepository.fetchAiConfig();
      if (!config.isConfigured) {
        _messages.add(const ChatMessage(
          role: ChatRole.assistant,
          isError: true,
          text: 'The AI assistant isn\'t configured yet. Ask the app administrator to '
              'set a Groq API key in Firestore under config/ai_assistant.',
        ));
        return;
      }

      final history = <Map<String, String>>[
        {'role': 'system', 'content': _systemPrompt},
        for (final m in _messages)
          {'role': m.role == ChatRole.user ? 'user' : 'assistant', 'content': m.text},
      ];

      final reply = await _groqService.complete(
        apiKey: config.apiKey,
        model: config.model,
        messages: history,
      );
      _messages.add(ChatMessage(role: ChatRole.assistant, text: reply));
    } on GroqException catch (e) {
      _messages.add(ChatMessage(role: ChatRole.assistant, isError: true, text: e.message));
    } catch (_) {
      _messages.add(const ChatMessage(
        role: ChatRole.assistant,
        isError: true,
        text: 'Something went wrong. Please try again.',
      ));
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
