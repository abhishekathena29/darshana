import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    final isDesktop = size.width > 800;
    final isSmall = size.width < 360;
    final horizontalPad = isSmall ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    _buildGreeting(context),
                    const SizedBox(height: 32),
                    _buildSuggestedPrompts(context),
                    const SizedBox(height: 48),
                    _buildChatHistory(context, isDesktop),
                    const SizedBox(height: 120), // Space for the input bar
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                    child: _buildInputBar(context),
                  ),
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
          const CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBbjFPU83KfenYDa16RYo87cvzatV0i6o3q8rWbGBi5H67XHCn3Zzl2QNH741kMJwtaPjL8VcaDan2hd2I_FU9PLuUs5GppmA0IqiO6WAlmFMJhjkjO2KYuUDU5Uv6qHeO1q1KLgTOetFOLX1mfYAjkbStWElzKjhHkz_PVKQxpnyRYmjbTHKi3YwrOsO0oXPfV5wyE3Ujy5SkHoD0BlRxXAdcaH_DVG6hXje4rlGbAKyCcJrIM2z59QmRyFGViQ_Sreug1jLYXCkg',
            ),
            radius: 18,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              'Sudarshan',
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
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Theme.of(context).colorScheme.outline),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
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

  Widget _buildSuggestedPrompts(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _buildPromptChip(context, 'Plan a 2-day trip to Madurai'),
        _buildPromptChip(context, 'Nearby temples with evening sevas'),
        _buildPromptChip(context, 'Dress code for Tirupati'),
      ],
    );
  }

  Widget _buildPromptChip(BuildContext context, String text) {
    return ActionChip(
      label: Text(text),
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      onPressed: () {},
    );
  }

  Widget _buildChatHistory(BuildContext context, bool isDesktop) {
    return Column(
      children: [
        _buildUserMessage(context, 'Tell me about the best time to visit Madurai Meenakshi Temple and suggest a stay.'),
        const SizedBox(height: 24),
        _buildAIResponse(context, isDesktop),
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

  Widget _buildAIResponse(BuildContext context, bool isDesktop) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Response
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14, height: 1.5),
                      children: [
                        const TextSpan(text: 'Madurai is divine throughout the year, but the '),
                        const TextSpan(text: 'October to March', style: TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: ' window offers pleasant weather for temple circumambulation. For your stay, I recommend heritage properties near the Chithirai streets to witness the temple\'s morning vibrations.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Custom tip: Women usually wear sarees or churidars; traditional attire is appreciated for the inner sanctum.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Interactive Planning: Temple Cards & Map
            if (isDesktop)
              Row(
                children: [
                  Expanded(child: _buildTempleCard(context)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMapCard(context)),
                ],
              )
            else
              Column(
                children: [
                  _buildTempleCard(context),
                  const SizedBox(height: 16),
                  _buildMapCard(context),
                ],
              ),
            const SizedBox(height: 16),
            // Stay Recommendation
            _buildStayRecommendation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTempleCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 128,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuB4TCv2GLI-N3uZgpDitEt2sbyt3FqRpAn0lVu0RvqduamDW2PR176nnlqsrOnEbrutRHoLNR-aQ1Wz8h_beSjtWokPrY7h0V3zJogzN_JBo9p7zp35cyXyqoJOWlPsfNvDqPw3ylx9zIY0AMXd2OuE5jp3c-3SHwnWAMyKEoUfacP--HaVMuQOzcTWOW-_WayOram9CoSoMcEM5iGIw7AK2OWS-Lj76bXAMinjaM7IF2UXe0_1x3lRnr_aRf2bI4_Go-mFPjZg38A',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meenakshi Amman',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'MORNING SEVA 5:00 AM',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The heart of Madurai, known for its 14 gopurams and thousands of vibrant sculptures.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard(BuildContext context) {
    return Container(
      height: 236, // Match approximate height of Temple Card
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
        image: const DecorationImage(
          image: CachedNetworkImageProvider(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCLspVSauhU2xEtxqpzMpEnQAsUOWadmy6MfjymzjBzNVnoR2EnktVIIEviTnfZT2b-_zrzn3CcSYOsgdlES_8wV_8tdCPiLz_9RfnUmlC8M_qmNywkauFG5IL8bjXC8b81TMHY2nQFBAI4DBSqYm_su70flZxUhwo9_8QWHMocD8rOa5_O-j_PWJtdfDUMg4ZMvUwtiH84Td51-TVBBSipCMPi8xT992q2rvCZHHYx_2NEtVDH48hO8oqHnYIg3QSr23pXPiZOVn8',
          ),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Theme.of(context).colorScheme.surface.withOpacity(0.9), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 16),
                const SizedBox(width: 4),
                const Text(
                  'TEMPLE DISTRICT VIEW',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Open in Sacred Maps',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStayRecommendation(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: isSmall ? 48 : 64,
            height: isSmall ? 48 : 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: CachedNetworkImageProvider(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAta52mYUKVGsc_QJw9jaYHjyGdF33DUHOprC1WGbG0nnnnpbyR31wvRjVrSPxb5z-b0UsdHc3wEKfQs2_u7od_4m9vwpBqPXVONMFflDS7xmHkTKAOorvqSTc_yxtdPhHhHYefvWlkzjsZO1nUsw06-N0xPBD2tVL1h-L5zlh8NxOpQgk_6uTqpr7Ue7zu42EnEIKkICpZqBj236-C506qmIryd-HgLhMq8dMCGFZt_VvxqYQDNoiTKPTfgyXIaSGXYHoAhysEeWo',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Heritage Madurai',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Recommended: 1.2km from Temple North Gate',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    4,
                    (index) => Icon(Icons.star, color: Colors.orange.shade400, size: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
            ),
            child: const Text('BOOK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          ),
        ],
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
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.outline),
                onPressed: () {},
              ),
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
