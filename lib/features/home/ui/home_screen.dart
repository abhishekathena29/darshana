import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/event_model.dart';
import '../../../core/models/temple_model.dart';
import '../../../core/services/event_repository.dart';
import '../../../core/services/temple_repository.dart';
import '../provider/home_provider.dart';
import '../../event_details/ui/event_details_screen.dart';
import '../../temple_profile/ui/temple_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  /// Space reserved at the top for the floating glass navigation in [MainShell].
  final double topInset;

  const HomeScreen({super.key, this.topInset = 0});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: _HomeScreenContent(topInset: topInset),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  final double topInset;

  const _HomeScreenContent({required this.topInset});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return StreamBuilder<List<TempleModel>>(
      stream: TempleRepository().watchAll(),
      builder: (context, templeSnapshot) {
        final temples = templeSnapshot.data ?? const <TempleModel>[];
        return StreamBuilder<List<EventModel>>(
          stream: EventRepository().watchAll(),
          builder: (context, eventSnapshot) {
            final upcoming = (eventSnapshot.data ?? const <EventModel>[])
                .where((e) => e.isUpcoming)
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));
            final performances = upcoming.where((e) => e.category == 'Music' || e.category == 'Dance').toList();
            final sacredEvents = upcoming.where((e) => e.category == 'Poojas' || e.category == 'Festivals').toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: topInset + 12),
                  _buildHeroSection(context, isDesktop, upcoming.isEmpty ? null : upcoming.first),
                  _buildSearchAndFilters(context, isDesktop),
                  _buildFeaturedTemples(context, isDesktop, temples),
                  _buildCulturalPerformances(context, performances),
                  _buildSacredEvents(context, isDesktop, sacredEvents),
                  _buildNewsletter(context),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDesktop, EventModel? heroEvent) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final heroHeight = isDesktop ? 400.0 : (size.height < 700 ? 240.0 : 300.0);
    final heroPadding = isDesktop ? 48.0 : (isSmall ? 20.0 : 32.0);
    final horizontalPad = isSmall ? 16.0 : 24.0;
    return Padding(
      padding: EdgeInsets.all(horizontalPad),
      child: Container(
        width: double.infinity,
        height: heroHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              heroEvent?.imageUrl.isNotEmpty == true
                  ? heroEvent!.imageUrl
                  : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBEwfEb_TRm96ELULdyI2I2cTdefNsWRpsTyyge_N2vK-HFsNktvj6cc9Qamn5RPidDtjlIDHzEWnPdEVyi2hWu7GVXTC7wPkLCLADMgg34lNPIPMspjWu4v_zPnxLLMis6jH1OX4P3Qbgy2lThqswZ7cOCZQNsrwWwLHBWCba20ymb65IGmrlfVKmkiTlJ_WEGIqZLr7mIO-5We4TDc_se-KZI1Vg13XOmFRye4F_b-yW8XMUexiLA-8eHOhA_QrEJf9EKcXv4Q8s',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black87, Colors.black26, Colors.transparent],
            ),
          ),
          padding: EdgeInsets.all(heroPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'FEATURED EVENT',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                heroEvent?.title ?? 'No upcoming events yet',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmall ? 20 : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              if (isDesktop && heroEvent != null && heroEvent.description.isNotEmpty)
                Text(
                  heroEvent.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: heroEvent == null
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: heroEvent.id)),
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'EXPLORE EVENT',
                  style: TextStyle(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: isDesktop
            ? Row(
                children: [
                  Expanded(flex: 2, child: _buildSearchField(context)),
                  Flexible(child: _buildFilterDropdown(context, 'All Cities')),
                  Flexible(child: _buildFilterDropdown(context, 'Event Type')),
                  Flexible(child: _buildFilterDropdown(context, 'Any Date')),
                ],
              )
            : Column(
                children: [
                  _buildSearchField(context),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown(context, 'All Cities'),
                      ),
                      Expanded(
                        child: _buildFilterDropdown(context, 'Event Type'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildFilterDropdown(context, 'Any Date'),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    return TextField(
      decoration: InputDecoration(
        hintText: isSmall
            ? 'Search...'
            : 'Search for temples, festivals or performances...',
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.outline),
        hintMaxLines: 1,
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildFilterDropdown(BuildContext context, String hint) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            hint,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          items: const [],
          onChanged: (value) {},
          icon: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }

  Widget _buildFeaturedTemples(BuildContext context, bool isDesktop, List<TempleModel> temples) {
    if (temples.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Text(
          'No temples have been added yet.',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }
    final large = temples.first;
    final rest = temples.skip(1).take(2).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SACRED SANCTUARIES',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Featured Temples',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('VIEW GALLERY'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (isDesktop)
            SizedBox(
              height: 600,
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: _buildTempleCard(context, large),
                  ),
                  if (rest.isNotEmpty) ...[
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          for (var i = 0; i < rest.length; i++) ...[
                            if (i > 0) const SizedBox(height: 24),
                            Expanded(child: _buildTempleCard(context, rest[i])),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            )
          else
            Column(
              children: [
                SizedBox(height: 400, child: _buildTempleCard(context, large)),
                for (final temple in rest) ...[
                  const SizedBox(height: 16),
                  SizedBox(height: 300, child: _buildTempleCard(context, temple)),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTempleCard(BuildContext context, TempleModel temple) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TempleProfileScreen(templeId: temple.id)),
      ),
      child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        image: DecorationImage(
          image: CachedNetworkImageProvider(temple.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              temple.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(
                  temple.location,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildCulturalPerformances(BuildContext context, List<EventModel> performances) {
    if (performances.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ARTS & MELODIES',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cultural Performances',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 420,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              for (var i = 0; i < performances.length; i++) ...[
                if (i > 0) const SizedBox(width: 24),
                _buildPerformanceCard(context, performances[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceCard(BuildContext context, EventModel event) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 360 ? screenWidth - 64 : 320.0;
    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: CachedNetworkImageProvider(event.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  event.category.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            event.description.isNotEmpty ? event.description : event.venue,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 14,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${event.dateText} • ${event.startTime} • ${event.venue}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: event.id)),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Text(
              'VIEW DETAILS',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSacredEvents(BuildContext context, bool isDesktop, List<EventModel> events) {
    if (events.isEmpty) return const SizedBox.shrink();
    final items = [for (final e in events) _buildSacredEventItem(context, e)];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          Text(
            'WEEKLY CURATION',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sacred Events This Week',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          if (isDesktop)
            Row(
              children: items
                  .map(
                    (item) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: item,
                      ),
                    ),
                  )
                  .toList(),
            )
          else
            Column(
              children: items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: item,
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSacredEventItem(BuildContext context, EventModel event) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: event.id)),
      ),
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: CachedNetworkImageProvider(event.imageUrl),
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
                  event.dateText,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.description.isNotEmpty ? event.description : event.venue,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
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

  Widget _buildNewsletter(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    return Padding(
      padding: EdgeInsets.all(isSmall ? 16.0 : 24.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isSmall ? 24 : 48),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.primaryContainer.withOpacity(0.1),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          children: [
            Text(
              'Join the Sanctuary',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Receive weekly curations of sacred wisdom, event early-access, and cultural insights directly in your sanctuary.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: isSmall ? 13 : 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
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
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Your spiritual path email...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('SUBSCRIBE'),
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

}
