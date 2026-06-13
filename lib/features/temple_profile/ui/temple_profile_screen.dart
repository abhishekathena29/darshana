import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../provider/temple_profile_provider.dart';

class TempleProfileScreen extends StatelessWidget {
  const TempleProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TempleProfileProvider(),
      child: const _TempleProfileContent(),
    );
  }
}

class _TempleProfileContent extends StatelessWidget {
  const _TempleProfileContent();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isSmall = size.width < 360;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
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
            bottom: isDesktop ? 48 : 100, // adjust for bottom nav
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
                    onPressed: () {},
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
                  'Redirecting to official TTD booking portal',
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

  Widget _buildSliverAppBar(BuildContext context) {
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
        'Sudarshan',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Theme.of(context).colorScheme.primary),
          onPressed: () {},
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCBZXGls2w8mKonx4hlXsbhV3uwvoUDg494ZpJ2TkvU8IUti_Nr11dqEA5atHdthVX2wfG2utwpiwd5E1nxnqyTyWdcYSVmJp-K74Kf1RXIDNnoQ7MY9lutllvNoLrb78r_CutnqroxKakHM1cUT9WB2cE5dFZ2-yOSSQAWgMyOK4RPLcCGAzIW6FQTtIiFO0uP11lS72L2HC36lfjYr-kYTIXVhyGBArQeeryceLK0Ng7eVQF-AYxE5rI13_krFX5DISc0R62KSUc',
            ),
            radius: 18,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBEIysNsnaCmGG66ptZVYbNLQMpvUp5Rum0BtwLES3_dAy33tJgiO0JXyEKzzHQDOla1LInCvpJpMtPUPgAzZAE5jaba3OmZ8fUfIN1MazcsbiOYwXODxXiqOqcNe9HbKkNFjMkCMquR8D82CyVA4dJmPuXXDtWwQOLfu15Xn9v5l4nXV-MfcL3YjBcFpFDUp-V7UH8p1aQ6juOzICo9s59WUz11ETiUF-KB5u_iGawT92gBWlTCPqCJUCl-EOAjsmTqEtxyTSgYO4',
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
                  Text(
                    'Presiding Deity: Lord Venkateswara',
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
                      'Sri Padmavathi Amman Temple',
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
                child: _buildInfoColumn(context, Icons.schedule, 'TIMINGS', '5:30 AM - 9:00 PM', true),
              ),
              Expanded(
                child: _buildInfoColumn(context, Icons.checkroom, 'DRESS CODE', 'Traditional Only', true),
              ),
              Expanded(
                child: _buildInfoColumn(context, Icons.location_on, 'LOCATION', 'Tiruchanur', false),
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildSignificanceCard(context)),
                const SizedBox(width: 24),
                Expanded(flex: 1, child: _buildProTipsCard(context)),
              ],
            )
          else
            Column(
              children: [
                _buildSignificanceCard(context),
                const SizedBox(height: 24),
                _buildProTipsCard(context),
              ],
            ),
          const SizedBox(height: 24),
          _buildFacilitiesCard(context),
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
            'The temple is dedicated to Goddess Padmavathi, the consort of Lord Venkateswara. Legend has it that she manifested in a golden lotus within the temple tank. Pilgrims traditionally visit this sacred site before proceeding to Tirumala.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.6,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      const Text('Ancient structures dating back to the Pallava era, reflecting Dravidian architectural mastery.', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
                      const Text('Intricate stone carvings and a magnificent seven-tier Rajagopuram facing the sunrise.', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
              _buildProTipItem(context, Icons.check_circle_outline, 'Carry a reusable water bottle; hydration points are available.'),
              const SizedBox(height: 16),
              _buildProTipItem(context, Icons.block, 'Photography is strictly prohibited inside the sanctum.'),
              const SizedBox(height: 16),
              _buildProTipItem(context, Icons.pets, 'Shoe counters are free and located at the South entrance.'),
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
                'tirumala.org',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontStyle: FontStyle.italic,
                    ),
              ),
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
            children: [
              _buildFacilityItem(context, Icons.accessible, 'ACCESS', 'Ramp & Lift'),
              _buildFacilityItem(context, Icons.local_parking, 'PARKING', 'Secured Lot'),
              _buildFacilityItem(context, Icons.restaurant, 'FOOD', 'Annaprasadam'),
              _buildFacilityItem(context, Icons.wifi, 'DIGITAL', 'Public WiFi'),
            ],
          ),
        ],
      ),
    );
  }

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
