import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/sacred_path_model.dart';
import '../../../core/services/sacred_path_repository.dart';
import '../provider/sacred_path_provider.dart';

class SacredPathScreen extends StatelessWidget {
  /// Space reserved at the top for the floating glass navigation in [MainShell].
  final double topInset;

  const SacredPathScreen({super.key, this.topInset = 0});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SacredPathProvider(),
      child: _SacredPathContent(topInset: topInset),
    );
  }
}

class _SacredPathContent extends StatelessWidget {
  final double topInset;

  const _SacredPathContent({required this.topInset});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isSmall = size.width < 360;
    final horizontalPad = isDesktop ? 64.0 : (isSmall ? 16.0 : 24.0);

    return StreamBuilder<SacredPathModel?>(
      stream: SacredPathRepository().watchFeatured(),
      builder: (context, snapshot) {
        final path = snapshot.data;
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            top: topInset + 24,
            left: horizontalPad,
            right: horizontalPad,
            bottom: 40,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1024),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, path),
                  const SizedBox(height: 64),
                  if (path == null || path.stops.isEmpty)
                    Text(
                      snapshot.connectionState == ConnectionState.waiting
                          ? 'Loading your journey...'
                          : 'No sacred path has been published yet.',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    )
                  else
                    _buildPathTimeline(context, isDesktop, path),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, SacredPathModel? path) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR JOURNEY',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            path?.title ?? 'The Southern Trail',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          path?.description.isNotEmpty == true
              ? path!.description
              : 'A curated spiritual itinerary traversing the ancient Dravidian architectural marvels, designed to harmonize with traditional pooja timings.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildPathTimeline(BuildContext context, bool isDesktop, SacredPathModel path) {
    return Column(
      children: [
        for (var i = 0; i < path.stops.length; i++)
          _buildJourneyStop(
            context,
            stepNumber: (i + 1).toString().padLeft(2, '0'),
            title: path.stops[i].title,
            subtitle: path.stops[i].subtitle,
            time: path.stops[i].time,
            imageUrl: path.stops[i].imageUrl,
            isFirst: i == 0,
            isLast: i == path.stops.length - 1,
            isActive: i == 0,
            isDesktop: isDesktop,
          ),
      ],
    );
  }

  Widget _buildJourneyStop(
    BuildContext context, {
    required String stepNumber,
    required String title,
    required String subtitle,
    required String time,
    required String imageUrl,
    bool isFirst = false,
    bool isLast = false,
    bool isCompleted = false,
    bool isActive = false,
    required bool isDesktop,
  }) {
    // Colors based on state
    final Color textColor = isCompleted || isActive
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6);

    final isSmall = MediaQuery.of(context).size.width < 360;
    final cardPadding = isSmall ? 16.0 : (isDesktop ? 32.0 : 24.0);
    final timelineGap = isSmall ? 16.0 : 32.0;
    final nodeSize = isSmall ? 36.0 : 48.0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line & Node
          Column(
            children: [
              Container(
                width: nodeSize,
                height: nodeSize,
                decoration: BoxDecoration(
                  color: isCompleted ? Theme.of(context).colorScheme.primary : (isActive ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surface),
                  shape: BoxShape.circle,
                  border: isCompleted || isActive ? null : Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 2),
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(Icons.check, color: Theme.of(context).colorScheme.onPrimary, size: 20)
                      : Text(
                          stepNumber,
                          style: TextStyle(
                            color: isActive ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.outline,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: isCompleted ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          SizedBox(width: timelineGap),

          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 64.0),
              child: Container(
                padding: EdgeInsets.all(cardPadding),
                decoration: BoxDecoration(
                  color: isActive ? Theme.of(context).colorScheme.surfaceContainerLowest : Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(32), // High radius as per DESIGN.md
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ]
                      : null,
                ),
                child: isDesktop
                    ? Row(
                        children: [
                          Expanded(child: _buildCardText(context, title, subtitle, time, textColor, isActive)),
                          const SizedBox(width: 32),
                          _buildCardImage(imageUrl, fixedWidth: true),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildCardImage(imageUrl, fixedWidth: false),
                          const SizedBox(height: 24),
                          _buildCardText(context, title, subtitle, time, textColor, isActive),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardText(BuildContext context, String title, String subtitle, String time, Color textColor, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.schedule, size: 14, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              time,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: isActive ? 1.0 : 0.6),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        if (isActive) ...[
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.navigation),
            label: const Text('DIRECTIONS'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildCardImage(String imageUrl, {bool fixedWidth = true}) {
    return Container(
      height: 160,
      width: fixedWidth ? 200 : double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

}
