import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../provider/sacred_path_provider.dart';

class SacredPathScreen extends StatelessWidget {
  const SacredPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SacredPathProvider(),
      child: const _SacredPathContent(),
    );
  }
}

class _SacredPathContent extends StatelessWidget {
  const _SacredPathContent();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isSmall = size.width < 360;
    final horizontalPad = isDesktop ? 64.0 : (isSmall ? 16.0 : 24.0);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: kToolbarHeight + MediaQuery.of(context).padding.top + 24,
          left: horizontalPad,
          right: horizontalPad,
          bottom: isDesktop ? 64 : 120,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1024),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 64),
                _buildPathTimeline(context, isDesktop),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: isDesktop ? null : _buildBottomNav(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            BlendMode.srcOver,
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
              onPressed: () {},
            ),
            title: Text(
              'Sacred Path',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.map_outlined, color: Theme.of(context).colorScheme.outline),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            'The Southern Trail',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'A curated spiritual itinerary traversing the ancient Dravidian architectural marvels, designed to harmonize with traditional pooja timings.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildPathTimeline(BuildContext context, bool isDesktop) {
    return Column(
      children: [
        _buildJourneyStop(
          context,
          stepNumber: '01',
          title: 'Meenakshi Amman Temple',
          subtitle: 'Morning Darshan & Architectural Walk',
          time: '06:00 AM',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB4TCv2GLI-N3uZgpDitEt2sbyt3FqRpAn0lVu0RvqduamDW2PR176nnlqsrOnEbrutRHoLNR-aQ1Wz8h_beSjtWokPrY7h0V3zJogzN_JBo9p7zp35cyXyqoJOWlPsfNvDqPw3ylx9zIY0AMXd2OuE5jp3c-3SHwnWAMyKEoUfacP--HaVMuQOzcTWOW-_WayOram9CoSoMcEM5iGIw7AK2OWS-Lj76bXAMinjaM7IF2UXe0_1x3lRnr_aRf2bI4_Go-mFPjZg38A',
          isFirst: true,
          isCompleted: true,
          isDesktop: isDesktop,
        ),
        _buildJourneyStop(
          context,
          stepNumber: '02',
          title: 'Thirumalai Nayakkar Mahal',
          subtitle: 'Heritage Exploration',
          time: '11:30 AM',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCQsrlmk8xvGBIUL0Nto3N4GDdLGD39x2LJpScU_R-AtAsQri0UhJLbzopDsXo4e818-uzqJG1IT7KRDUotk6O3o8h0sJNtBnWiozul5GXnledQOH3hoH9EbLP6O9gCDOYSatv7tGzgyQCoEYa1boufDACN0WE-j02kdmE33WX88_1z5uQem7dtZ3jYTsuXVt81sDwZoT8HDToyV1rj_J4NBAxkS5daqJQLdXsiwUH30QCHFu_Ax_3-KWk5RGpiE0YubWjcW2A-bdQ',
          isActive: true,
          isDesktop: isDesktop,
        ),
        _buildJourneyStop(
          context,
          stepNumber: '03',
          title: 'Alagar Koyil',
          subtitle: 'Evening Seva & Prasad',
          time: '05:00 PM',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAkbUUL3LD2XW7P4NeeBH0w8Zu6r07ojwBEB0hqmyjq2mMeS_TaQ6SDqQDYYOkuovBf0LC6gmS_WBbPDNsMStVAo2C-Pcn4SsLc7dVqvUjCPNnKf2NZr8XFhAVKTUdp_VMY_It6NfGtzWrtrFm4g-Lp3wh4LvzWklbjxeiyT1SoDXatS4Kje6NZBgyKPi8jQ_H-d0tzk6unxOP0RQf3KzE0nUILDaG3esLQ23ZVpZSNsKlKZmkAUvQYZoKtYw8A_FiW3WoLImlo4aA',
          isLast: true,
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

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home_max, 'Home', false),
              _buildNavItem(context, Icons.explore, 'Path', true), // Sacred Path
              _buildNavItem(context, Icons.calendar_month, 'Events', false),
              _buildNavItem(context, Icons.person, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
