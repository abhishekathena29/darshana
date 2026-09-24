import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/temple_model.dart';
import '../../../core/services/temple_repository.dart';
import '../../../core/session/user_session.dart';
import '../provider/temple_profile_provider.dart';
import 'edit_temple_screen.dart';

class TempleProfileScreen extends StatelessWidget {
  final String templeId;
  const TempleProfileScreen({super.key, required this.templeId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TempleProfileProvider(),
      child: StreamBuilder<TempleModel?>(
        stream: TempleRepository().watchById(templeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          final temple = snapshot.data;
          if (temple == null) {
            return const Scaffold(body: Center(child: Text('This temple could not be found.')));
          }
          return _TempleProfileContent(temple: temple);
        },
      ),
    );
  }
}

class _TempleProfileContent extends StatelessWidget {
  final TempleModel temple;
  const _TempleProfileContent({required this.temple});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isSmall = size.width < 360;
    final session = context.watch<UserSession>();
    final isOwner = session.uid != null && session.uid == temple.ownerId;
    final isSaved = session.savedTempleIds.contains(temple.id);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, isOwner: isOwner, isSaved: isSaved, session: session),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 120.0), // space for bottom nav and fab
                  child: Column(
                    children: [
                      _buildKeyInfoBar(context),
                      _buildTabs(context),
                      _buildContentGrid(context, isDesktop),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Action Bottom Call
          Positioned(
            bottom: isDesktop ? 48 : 20, // adjust for bottom nav
            left: isDesktop ? null : 24,
            right: isDesktop ? 48 : 24,
            width: isDesktop ? 320 : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primaryContainer,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => _openOfficialPortal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.confirmation_num_outlined, color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            isSmall ? 'BOOK SEVA' : 'BOOK DARSHAN / SEVA',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: isSmall ? 13 : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  temple.officialPortal.isEmpty
                      ? 'This temple hasn\'t added a booking link yet'
                      : 'Redirecting to ${temple.officialPortal}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openOfficialPortal(BuildContext context) async {
    final portal = temple.officialPortal.trim();
    if (portal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This temple hasn\'t added a booking link yet.')),
      );
      return;
    }
    final uri = Uri.tryParse(portal.startsWith('http') ? portal : 'https://$portal');
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the booking link.')),
      );
    }
  }

  Widget _buildSliverAppBar(
    BuildContext context, {
    required bool isOwner,
    required bool isSaved,
    required UserSession session,
  }) {
    final size = MediaQuery.of(context).size;
    final expandedHeight = (size.height * 0.55).clamp(360.0, 530.0);
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        'Darshana',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
      ),
      actions: [
        if (isOwner)
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.primary),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => EditTempleScreen(templeId: temple.id)),
            ),
          )
        else
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => session.toggleSavedTemple(temple.id),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: temple.imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent, Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 48,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (temple.deity.isNotEmpty)
                    Text(
                      'Presiding Deity: ${temple.deity}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                            fontSize: size.width < 360 ? 13 : null,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      temple.name,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyInfoBar(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            children: [
              Expanded(
                child: _buildInfoColumn(context, Icons.schedule, 'TIMINGS', temple.timings, true),
              ),
              Expanded(
                child: _buildInfoColumn(context, Icons.checkroom, 'DRESS CODE', temple.dressCode, true),
              ),
              Expanded(
                child: _buildInfoColumn(context, Icons.location_on, 'LOCATION', temple.location, false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, IconData icon, String title, String subtitle, bool showBorder) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 4 : 8),
      decoration: showBorder
          ? BoxDecoration(
              border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3))),
            )
          : null,
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: isSmall ? 1.0 : 2.0,
              color: Theme.of(context).colorScheme.outline,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: isSmall ? 11 : 14),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    final tabs = ['Significance', 'Pooja Schedule', 'Seva & Offerings', 'History'];
    return Consumer<TempleProfileProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final title = entry.value;
              final isSelected = provider.selectedTabIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: GestureDetector(
                  onTap: () => provider.selectTab(index),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildContentGrid(BuildContext context, bool isDesktop) {
    return Consumer<TempleProfileProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildTabContent(context, isDesktop, provider.selectedTabIndex),
              const SizedBox(height: 24),
              _buildFacilitiesCard(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent(BuildContext context, bool isDesktop, int tabIndex) {
    switch (tabIndex) {
      case 1:
        return _buildScheduleCard(context);
      case 2:
        return _buildSevaCard(context);
      case 3:
        return _buildHistoryCard(context);
      case 0:
      default:
        return isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildSignificanceCard(context)),
                  const SizedBox(width: 24),
                  Expanded(flex: 1, child: _buildProTipsCard(context)),
                ],
              )
            : Column(
                children: [
                  _buildSignificanceCard(context),
                  const SizedBox(height: 24),
                  _buildProTipsCard(context),
                ],
              );
    }
  }

  Widget _buildScheduleCard(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pooja Schedule',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.schedule, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  temple.timings.isEmpty
                      ? 'The temple administrator hasn\'t added a pooja schedule yet.'
                      : temple.timings,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.6,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSevaCard(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seva & Offerings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 24),
          if (temple.proTips.isEmpty)
            Text(
              'No seva or offering details added yet.',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8)),
            )
          else
            for (var i = 0; i < temple.proTips.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              _buildProTipItem(context, Icons.volunteer_activism, temple.proTips[i]),
            ],
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            temple.history.isEmpty
                ? 'The temple administrator hasn\'t added a history yet.'
                : temple.history,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.6,
              fontSize: 16,
            ),
          ),
          if (temple.architecture.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ARCHITECTURE',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(temple.architecture, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSignificanceCard(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Divine Significance',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            temple.significance.isEmpty
                ? 'The temple administrator hasn\'t added a description yet.'
                : temple.significance,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.6,
              fontSize: 16,
            ),
          ),
          if (temple.history.isNotEmpty || temple.architecture.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (temple.history.isNotEmpty)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HISTORY',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(temple.history, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                if (temple.history.isNotEmpty && temple.architecture.isNotEmpty)
                  const SizedBox(width: 16),
                if (temple.architecture.isNotEmpty)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ARCHITECTURE',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(temple.architecture, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProTipsCard(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -24,
            right: -24,
            child: Icon(
              Icons.info,
              size: 140,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pro-Tips',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 24),
              if (temple.proTips.isEmpty)
                Text(
                  'No pro-tips added yet.',
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8)),
                )
              else
                for (var i = 0; i < temple.proTips.length; i++) ...[
                  if (i > 0) const SizedBox(height: 16),
                  _buildProTipItem(context, Icons.check_circle_outline, temple.proTips[i]),
                ],
              if (temple.officialPortal.isNotEmpty) ...[
                const SizedBox(height: 32),
                Divider(color: Colors.white.withOpacity(0.2)),
                const SizedBox(height: 24),
                Text(
                  'OFFICIAL PORTAL',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  temple.officialPortal,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProTipItem(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.onPrimary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitiesCard(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilgrim Amenities',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: temple.facilities.isEmpty
                ? [
                    _buildFacilityItem(context, Icons.accessible, 'ACCESS', 'Ramp & Lift'),
                    _buildFacilityItem(context, Icons.local_parking, 'PARKING', 'Secured Lot'),
                    _buildFacilityItem(context, Icons.restaurant, 'FOOD', 'Annaprasadam'),
                    _buildFacilityItem(context, Icons.wifi, 'DIGITAL', 'Public WiFi'),
                  ]
                : temple.facilities
                    .map((f) => _buildFacilityItem(context, _facilityIcon(f.icon), f.title, f.subtitle))
                    .toList(),
          ),
        ],
      ),
    );
  }

  static const _facilityIcons = <String, IconData>{
    'accessible': Icons.accessible,
    'parking': Icons.local_parking,
    'food': Icons.restaurant,
    'wifi': Icons.wifi,
    'info': Icons.info_outline,
  };

  IconData _facilityIcon(String key) => _facilityIcons[key] ?? Icons.info_outline;

  Widget _buildFacilityItem(BuildContext context, IconData icon, String title, String subtitle) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth < 360 ? screenWidth - 80 : 160.0;
    return SizedBox(
      width: itemWidth,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
