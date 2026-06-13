import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../provider/host_dashboard_provider.dart';

class HostDashboardScreen extends StatelessWidget {
  /// Space reserved at the top for the floating glass navigation in [MainShell].
  final double topInset;

  const HostDashboardScreen({super.key, this.topInset = 0});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HostDashboardProvider(),
      child: _HostDashboardContent(topInset: topInset),
    );
  }
}

class _HostDashboardContent extends StatelessWidget {
  final double topInset;

  const _HostDashboardContent({required this.topInset});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isSmall = size.width < 360;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: topInset + 20,
        left: isSmall ? 16.0 : 24.0,
        right: isSmall ? 16.0 : 24.0,
        bottom: isSmall ? 20.0 : 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 40),
          _buildQuickStats(context, isDesktop),
          const SizedBox(height: 48),
          _buildActionGrid(context, isDesktop),
          const SizedBox(height: 48),
          _buildManagementAndActivity(context, isDesktop),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'Organizer Dashboard',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back, Temple Administrator. Here is your community overview.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: isSmall ? 13 : 16,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, bool isDesktop) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (isDesktop) {
      return SizedBox(
        height: 320,
        child: Row(
          children: [
            Expanded(flex: 2, child: _buildMainStat(context)),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(child: _buildSecondaryStat(context, Icons.visibility, '8.4k', 'PAGE VIEWS', Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 24),
                  Expanded(child: _buildSecondaryStat(context, Icons.event_available, '12', 'ACTIVE EVENTS', Theme.of(context).colorScheme.tertiary)),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      final mainStatHeight = screenHeight < 700 ? 240.0 : 300.0;
      final secondaryHeight = screenHeight < 700 ? 120.0 : 140.0;
      return Column(
        children: [
          SizedBox(height: mainStatHeight, child: _buildMainStat(context)),
          const SizedBox(height: 24),
          SizedBox(height: secondaryHeight, child: _buildSecondaryStat(context, Icons.visibility, '8.4k', 'PAGE VIEWS', Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 24),
          SizedBox(height: secondaryHeight, child: _buildSecondaryStat(context, Icons.event_available, '12', 'ACTIVE EVENTS', Theme.of(context).colorScheme.tertiary)),
        ],
      );
    }
  }

  Widget _buildMainStat(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL REGISTRATIONS',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '1,284',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, color: Theme.of(context).colorScheme.onPrimaryContainer, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '+12%',
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // CSS Graph Representation
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(context, 0.4, false),
              const SizedBox(width: 4),
              _buildBar(context, 0.6, false),
              const SizedBox(width: 4),
              _buildBar(context, 0.45, false),
              const SizedBox(width: 4),
              _buildBar(context, 0.8, false),
              const SizedBox(width: 4),
              _buildBar(context, 0.55, false),
              const SizedBox(width: 4),
              _buildBar(context, 0.95, true),
              const SizedBox(width: 4),
              _buildBar(context, 0.7, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context, double heightFactor, bool isHighlighted) {
    return Expanded(
      child: FractionallySizedBox(
        heightFactor: heightFactor,
        child: Container(
          decoration: BoxDecoration(
            color: isHighlighted ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryStat(BuildContext context, IconData icon, String value, String label, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context, bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: isDesktop ? 1.5 : 2.5,
      mainAxisSpacing: 24,
      crossAxisSpacing: 24,
      children: [
        _buildActionCard(context, Icons.add_circle, 'Add New Event', true),
        _buildActionCard(context, Icons.schedule, 'Temple Schedule', false),
        _buildActionCard(context, Icons.campaign, 'Post Announcement', false),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String title, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isPrimary ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: isPrimary ? null : Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: isPrimary ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: isPrimary ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementAndActivity(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildEventManagement(context)),
          const SizedBox(width: 48),
          Expanded(flex: 1, child: _buildRecentActivity(context)),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventManagement(context),
          const SizedBox(height: 48),
          _buildRecentActivity(context),
        ],
      );
    }
  }

  Widget _buildEventManagement(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Event Management',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VIEW ALL',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
                Icon(Icons.arrow_forward, size: 16, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildEventRow(
          context,
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAkbUUL3LD2XW7P4NeeBH0w8Zu6r07ojwBEB0hqmyjq2mMeS_TaQ6SDqQDYYOkuovBf0LC6gmS_WBbPDNsMStVAo2C-Pcn4SsLc7dVqvUjCPNnKf2NZr8XFhAVKTUdp_VMY_It6NfGtzWrtrFm4g-Lp3wh4LvzWklbjxeiyT1SoDXatS4Kje6NZBgyKPi8jQ_H-d0tzk6unxOP0RQf3KzE0nUILDaG3esLQ23ZVpZSNsKlKZmkAUvQYZoKtYw8A_FiW3WoLImlo4aA',
          'Evening Aarti Ceremony',
          'Oct 24, 2023 • Varanasi Ghats',
          '142/200',
          'LIVE',
          Colors.green,
        ),
        const SizedBox(height: 16),
        _buildEventRow(
          context,
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA38D23peL1nNSdfCvXKz5JNAmR-aHIHPtrKYxLjaBp3523T4lB-6stNrzVrYnJfVsTuBkIwuExcSx6FZ_Dab4wK-lx5RJ_oTQSgIu0j95MIYKdwgEl2He6Teb8tEBvCu-qlp6r7CzvVvlL8VTd3sMffhE-uieuGWjvKxVIw8KREJMKNPVR7Y8atuawH0imV-gcjHlsnMp13WEe9qyJIMoy02D9-OtwJh2RVfUTFPMPwvW4X_onLIlmHWp-GX4i3RRSSmw7qCdNBe4',
          'Classical Mudra Workshop',
          'Nov 02, 2023 • Cultural Hall',
          '45/50',
          'DRAFT',
          Colors.grey,
        ),
        const SizedBox(height: 16),
        _buildEventRow(
          context,
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDjXArwAXnG-7KDqRsf2fziNrLG8c1quX2NjEykmYOyXBFi1B-cuDW_NsfHESTxqMgtzryvJvf6l6O_jcg2kDhLHaYJVrCb6bGbTQn3Vj8BokdtzgVvJyOhEvBw8rIqkm18fCye9kskmH0WMoxHTAP-oIKFObCQ3BWzBn1cXU7pACQ06FeEjMi8LQY64kdQCY20Mvc3alg1Ld9ellH1kRmPWXFGxaeSSE9ACvrt6-_VGzYp7z8uqjo7VDi14D8lqIm5EEF1Q2uoeM0',
          'Deepavali Night Gala',
          'Nov 12, 2023 • Main Plaza',
          '500/500',
          'SOLD OUT',
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildEventRow(BuildContext context, String imageUrl, String title, String subtitle, String tickets, String status, MaterialColor statusColor) {
    final isNarrow = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (isNarrow) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(tickets, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor.shade800,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!isNarrow) ...[
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'TICKETS',
                  style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
                const SizedBox(height: 2),
                Text(tickets, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(width: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor.shade800,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ] else
            const SizedBox(width: 8),
          Icon(Icons.more_vert, color: Theme.of(context).colorScheme.outline),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Stack(
          children: [
            Positioned(
              left: 19,
              top: 8,
              bottom: 8,
              child: Container(
                width: 2,
                color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
              ),
            ),
            Column(
              children: [
                _buildActivityItem(
                  context,
                  Icons.confirmation_number,
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primary,
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                      children: const [
                        TextSpan(text: 'Aarav Sharma', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' registered for the Morning Yoga session.'),
                      ],
                    ),
                  ),
                  '2 minutes ago',
                  null,
                ),
                const SizedBox(height: 24),
                _buildActivityItem(
                  context,
                  Icons.verified_user,
                  Theme.of(context).colorScheme.tertiaryContainer,
                  Theme.of(context).colorScheme.tertiary,
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                      children: const [
                        TextSpan(text: 'New '),
                        TextSpan(text: 'Verification Request', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' from Pandit Rajan for priest credentials.'),
                      ],
                    ),
                  ),
                  '1 hour ago',
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('APPROVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildActivityItem(
                  context,
                  Icons.rate_review,
                  Theme.of(context).colorScheme.secondaryContainer,
                  Theme.of(context).colorScheme.secondary,
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                      children: const [
                        TextSpan(text: 'New review posted for '),
                        TextSpan(text: 'Heritage Walk', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                  '4 hours ago',
                  Row(
                    children: List.generate(5, (index) => Icon(Icons.star, color: Theme.of(context).colorScheme.secondary, size: 14)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityItem(BuildContext context, IconData icon, Color bgColor, Color iconColor, Widget textWidget, String time, Widget? extra) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).colorScheme.surface, width: 4),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget,
              if (extra != null) ...[
                const SizedBox(height: 8),
                extra,
              ],
              const SizedBox(height: 8),
              Text(time, style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

}
