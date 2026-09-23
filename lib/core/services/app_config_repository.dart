import 'package:cloud_firestore/cloud_firestore.dart';

class AiAssistantConfig {
  final String provider;
  final String apiKey;
  final String model;

  const AiAssistantConfig({
    required this.provider,
    required this.apiKey,
    required this.model,
  });

  bool get isConfigured => apiKey.trim().isNotEmpty;
}

/// Reads app-wide configuration (currently just the AI assistant's provider
/// credentials) from `config/ai_assistant`. This document is intentionally
/// NOT client-writable (see firestore.rules) — set it from the Firebase
/// console: collection `config`, document `ai_assistant`, fields
/// `provider` (e.g. "groq"), `apiKey`, `model` (e.g. "llama-3.3-70b-versatile").
class AppConfigRepository {
  AppConfigRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<AiAssistantConfig> fetchAiConfig() async {
    final doc = await _firestore.collection('config').doc('ai_assistant').get();
    final data = doc.data() ?? const {};
    return AiAssistantConfig(
      provider: data['provider'] as String? ?? 'groq',
      apiKey: data['apiKey'] as String? ?? '',
      model: data['model'] as String? ?? 'llama-3.3-70b-versatile',
    );
  }
}
