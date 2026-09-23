import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqException implements Exception {
  final String message;
  const GroqException(this.message);

  @override
  String toString() => message;
}

/// Minimal client for Groq's OpenAI-compatible chat completions endpoint.
/// https://console.groq.com/docs/api-reference#chat-create
class GroqService {
  static const _endpoint = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> complete({
    required String apiKey,
    required String model,
    required List<Map<String, String>> messages,
  }) async {
    late final http.Response response;
    try {
      response = await http
          .post(
            Uri.parse(_endpoint),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': model,
              'messages': messages,
              'temperature': 0.7,
            }),
          )
          .timeout(const Duration(seconds: 30));
    } catch (_) {
      throw const GroqException('Could not reach the AI service. Check your connection.');
    }

    if (response.statusCode != 200) {
      String detail = 'The AI service returned an error.';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        detail = (body['error']?['message'] as String?) ?? detail;
      } catch (_) {
        // keep default detail
      }
      throw GroqException(detail);
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = body['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw const GroqException('The AI service returned an empty response.');
    }
    final content = choices.first['message']?['content'] as String?;
    return content?.trim() ?? '';
  }
}
