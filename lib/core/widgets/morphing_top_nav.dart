import 'package:flutter/material.dart';
import 'glass_container.dart';

/// A single navigation destination shown in the morphing top nav.
class NavDestinationData {
  final IconData icon;
  final String label;

  const NavDestinationData({required this.icon, required this.label});
}

/// A scroll-driven navigation header that morphs between two states:
///
///  * `progress == 0` — an expanded **grid** of large destination tiles
///    (brand row on top), à la the District-by-Zomato landing.
///  * `progress == 1` — a slim, pinned **glass tab bar** with the same
///    destinations laid out horizontally.
///
/// The whole surface is glassmorphic and floats over the page content. The
/// host ([MainShell]) feeds it a `progress` value derived from scroll offset.
class MorphingTopNav extends StatelessWidget {
  static const double collapsedContentHeight = 60;
  static const double expandedContentHeight = 196;

  /// Distance (in px of scroll) over which the nav fully collapses.
  static const double collapseDistance =
      expandedContentHeight - collapsedContentHeight;

  final double progress; // 0 = grid, 1 = tab bar
  final List<NavDestinationData> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final String brand;
  final VoidCallback? onNotifications;
  final VoidCallback? onAvatar;
  final String? avatarUrl;

  const MorphingTopNav({
    super.key,
    required this.progress,
    required this.destinations,
    required this.currentIndex,
    required this.onSelect,
    this.brand = 'Darshana',
    this.onNotifications,
    this.onAvatar,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final t = progress.clamp(0.0, 1.0);
    final topInset = MediaQuery.of(context).padding.top;
    final contentHeight =
        lerpDouble(expandedContentHeight, collapsedContentHeight, t);

    return GlassContainer(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      padding: EdgeInsets.only(top: topInset),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06 + 0.06 * t),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
      child: SizedBox(
        height: contentHeight,
        width: double.infinity,
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Collapsed tab bar (fades in as we scroll up)
              if (t > 0.05)
                Opacity(
                  opacity: Curves.easeIn.transform(t),
                  child: IgnorePointer(
                    ignoring: t < 0.5,
                    child: _TabBar(
                      destinations: destinations,
                      currentIndex: currentIndex,
                      onSelect: onSelect,
                    ),
                  ),
                ),

              // Expanded grid (fades out as we scroll up)
              if (t < 0.95)
                Opacity(
                  opacity: Curves.easeOut.transform(1 - t),
                  child: IgnorePointer(
                    ignoring: t >= 0.5,
                    child: OverflowBox(
                      minHeight: 0,
                      maxHeight: expandedContentHeight,
                      alignment: Alignment.topCenter,
                      child: _ExpandedGrid(
                        brand: brand,
                        destinations: destinations,
                        currentIndex: currentIndex,
                        onSelect: onSelect,
                        onNotifications: onNotifications,
                        onAvatar: onAvatar,
                        avatarUrl: avatarUrl,
                      ),
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

double lerpDouble(double a, double b, double t) => a + (b - a) * t;

/// Slim horizontal tab bar shown when the header is collapsed.
class _TabBar extends StatelessWidget {
  final List<NavDestinationData> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const _TabBar({
    required this.destinations,
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          for (int i = 0; i < destinations.length; i++)
            Expanded(
              child: _TabItem(
                data: destinations[i],
                selected: i == currentIndex,
                onTap: () => onSelect(i),
                theme: theme,
              ),
            ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final NavDestinationData data;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _TabItem({
    required this.data,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final active = theme.colorScheme.primary;
    final inactive = theme.colorScheme.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primaryContainer.withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data.icon,
                size: 20, color: selected ? active : inactive),
            const SizedBox(height: 2),
            Text(
              data.label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: selected ? active : inactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The expanded grid of large tiles shown at the top of a page.
class _ExpandedGrid extends StatelessWidget {
  final String brand;
  final List<NavDestinationData> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback? onNotifications;
  final VoidCallback? onAvatar;
  final String? avatarUrl;

  const _ExpandedGrid({
    required this.brand,
    required this.destinations,
    required this.currentIndex,
    required this.onSelect,
    this.onNotifications,
    this.onAvatar,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Brand row
          Row(
            children: [
              if (avatarUrl != null) ...[
                GestureDetector(
                  onTap: onAvatar,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(avatarUrl!),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  brand,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onNotifications,
                icon: Icon(Icons.notifications_outlined,
                    color: theme.colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Grid of destination tiles
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < destinations.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: i == 0 ? 0 : 5,
                      right: i == destinations.length - 1 ? 0 : 5,
                    ),
                    child: _GridTile(
                      data: destinations[i],
                      selected: i == currentIndex,
                      onTap: () => onSelect(i),
                      theme: theme,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridTile extends StatelessWidget {
  final NavDestinationData data;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _GridTile({
    required this.data,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final active = theme.colorScheme.primary;
    final onActive = theme.colorScheme.onPrimary;
    final inactive = theme.colorScheme.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    active,
                    active.withOpacity(0.78),
                  ],
                )
              : null,
          color: selected
              ? null
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.45),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : theme.colorScheme.outlineVariant.withOpacity(0.4),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(data.icon,
                size: 24, color: selected ? onActive : active),
            const SizedBox(height: 8),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: selected ? onActive : inactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
