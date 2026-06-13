import 'package:flutter/material.dart';
import 'glass_container.dart';

/// A vertical glass pill anchored to the right edge of the screen that opens
/// the AI assistant. Replaces the old "AI" bottom-navigation tab.
class AISideButton extends StatelessWidget {
  final VoidCallback onTap;

  const AISideButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(22)),
      blur: 14,
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.primary.withOpacity(0.25),
          blurRadius: 18,
          offset: const Offset(-2, 6),
        ),
      ],
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (rect) => LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                ).createShader(rect),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(height: 6),
              RotatedBox(
                quarterTurns: 0,
                child: Text(
                  'AI',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
