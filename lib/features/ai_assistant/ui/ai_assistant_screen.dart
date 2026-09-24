import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../model/chat_message.dart';
import '../provider/ai_assistant_provider.dart';

class AIAssistantScreen extends StatelessWidget {
  const AIAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AIAssistantProvider(),
      child: const _AIAssistantContent(),
    );
  }
}

class _AIAssistantContent extends StatelessWidget {
  const _AIAssistantContent();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final horizontalPad = isSmall ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AIAssistantProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  reverse: provider.messages.isNotEmpty,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 24.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: provider.messages.isEmpty
                          ? Column(
                              children: [
                                _buildGreeting(context),
                                const SizedBox(height: 32),
                                _buildSuggestedPrompts(context, provider),
                              ],
                            )
                          : _buildChatHistory(context, provider),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad, 8),
                  child: _buildInputBar(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary, size: 22),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'Darshana',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Column(
      children: [
        Container(
          width: isSmall ? 64 : 80,
          height: isSmall ? 64 : 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.auto_awesome,
            size: isSmall ? 32 : 40,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Namaste, I am your Sacred Path Guide...',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isSmall ? 20 : null,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Ask me anything about your spiritual journey, temple customs, or travel logistics.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: isSmall ? 13 : 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSuggestedPrompts(BuildContext context, AIAssistantProvider provider) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _buildPromptChip(context, 'Plan a 2-day trip to Madurai', provider),
        _buildPromptChip(context, 'Nearby temples with evening sevas', provider),
        _buildPromptChip(context, 'Dress code for Tirupati', provider),
      ],
    );
  }

  Widget _buildPromptChip(BuildContext context, String text, AIAssistantProvider provider) {
    return ActionChip(
      label: Text(text),
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      onPressed: provider.isSending ? null : () => provider.sendMessage(text),
    );
  }

  Widget _buildChatHistory(BuildContext context, AIAssistantProvider provider) {
    return Column(
      children: [
        for (final message in provider.messages) ...[
          if (message.role == ChatRole.user)
            _buildUserMessage(context, message.text)
          else
            _buildAIResponse(context, message),
          const SizedBox(height: 24),
        ],
        if (provider.isSending)
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.primary),
            ),
          ),
      ],
    );
  }

  Widget _buildUserMessage(BuildContext context, String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    final leftMargin = screenWidth < 360 ? 24.0 : 48.0;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(left: leftMargin),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAIResponse(BuildContext context, ChatMessage message) {
    final screenWidth = MediaQuery.of(context).size.width;
    final rightMargin = screenWidth < 360 ? 8.0 : 32.0;
    final errorColor = Theme.of(context).colorScheme.error;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(right: rightMargin),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: message.isError
              ? errorColor.withOpacity(0.08)
              : Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          border: Border.all(
            color: message.isError
                ? errorColor.withOpacity(0.3)
                : Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
          ),
        ),
        child: message.isError
            ? Text(
                message.text,
                style: TextStyle(color: errorColor, fontSize: 14, height: 1.5),
              )
            : MarkdownBody(
                data: message.text,
                selectable: true,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  strong: const TextStyle(fontWeight: FontWeight.bold),
                  listBullet: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                  code: TextStyle(
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    fontSize: 13,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Consumer<AIAssistantProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: provider.messageController,
                  decoration: InputDecoration(
                    hintText: MediaQuery.of(context).size.width < 360
                        ? 'Ask anything...'
                        : 'Ask about rituals, travel, or history...',
                    hintMaxLines: 1,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: provider.sendMessage,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
