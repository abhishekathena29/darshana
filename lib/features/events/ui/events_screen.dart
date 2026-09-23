import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/event_model.dart';
import '../../../core/services/event_repository.dart';
import '../provider/events_provider.dart';
import '../../event_details/ui/event_details_screen.dart';

class EventsScreen extends StatelessWidget {
  /// Space reserved at the top for the floating glass navigation in [MainShell].
  final double topInset;

  const EventsScreen({super.key, this.topInset = 0});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventsProvider(),
      child: _EventsScreenContent(topInset: topInset),
    );
  }
}

class _EventsScreenContent extends StatefulWidget {
  final double topInset;

  const _EventsScreenContent({required this.topInset});

  @override
  State<_EventsScreenContent> createState() => _EventsScreenContentState();
}

class _EventsScreenContentState extends State<_EventsScreenContent> {
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isTablet = size.width >= 600 && size.width <= 800;
    final isSmall = size.width < 360;
    final selectedCategory = context.watch<EventsProvider>().selectedCategory;

    return StreamBuilder<List<EventModel>>(
      stream: EventRepository().watchAll(),
      builder: (context, snapshot) {
        final allEvents = snapshot.data ?? const [];
        final upcoming = allEvents.where((e) => e.isUpcoming).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
        final filtered = upcoming.where((e) {
          final matchesCategory = selectedCategory == 'All Events' || e.category == selectedCategory;
          final matchesSearch = _search.isEmpty || e.title.toLowerCase().contains(_search.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();

        return SingleChildScrollView(
          padding: EdgeInsets.only(
            top: widget.topInset + 16,
            left: isSmall ? 16.0 : 24.0,
            right: isSmall ? 16.0 : 24.0,
            bottom: isSmall ? 16.0 : 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSearch(context),
              const SizedBox(height: 32),
              _buildCategoryScroll(context),
              const SizedBox(height: 40),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator())
              else if (filtered.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No events found.',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              else ...[
                _buildFeaturedBentoGrid(context, isDesktop, filtered),
                const SizedBox(height: 48),
                _buildUpcomingEvents(context, isDesktop, isTablet, filtered),
              ],
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroSearch(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discover Sacred Gatherings\n& Cultural Festivals',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
                fontSize: isSmall ? 22 : null,
              ),
        ),
        const SizedBox(height: 24),
        Container(
          constraints: BoxConstraints(maxWidth: size.width > 600 ? 600 : double.infinity),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _search = value),
            decoration: InputDecoration(
              hintText: 'Search events, poojas, or sites...',
              prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.outline),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryScroll(BuildContext context) {
    final categories = ['All Events', 'Poojas', 'Festivals', 'Music', 'Dance', 'Tours'];

    return Consumer<EventsProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              final isSelected = provider.selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) => provider.selectCategory(category),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  labelStyle: TextStyle(
                    color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedBentoGrid(BuildContext context, bool isDesktop, List<EventModel> events) {
    final screenHeight = MediaQuery.of(context).size.height;
    final large = events.first;
    final sides = events.skip(1).take(2).toList();
    if (sides.isEmpty) {
      final height = isDesktop ? (screenHeight < 700 ? 400.0 : 500.0) : (screenHeight < 700 ? 280.0 : 400.0);
      return SizedBox(height: height, child: _buildLargeFeaturedCard(context, large));
    }
    if (isDesktop) {
      return SizedBox(
        height: screenHeight < 700 ? 400 : 500,
        child: Row(
          children: [
            Expanded(flex: 2, child: _buildLargeFeaturedCard(context, large)),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  for (var i = 0; i < sides.length; i++) ...[
                    if (i > 0) const SizedBox(height: 24),
                    Expanded(child: _buildSideFeaturedCard(context, sides[i])),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      final largeCardHeight = screenHeight < 700 ? 280.0 : 400.0;
      final sideCardHeight = screenHeight < 700 ? 200.0 : 240.0;
      return Column(
        children: [
          SizedBox(height: largeCardHeight, child: _buildLargeFeaturedCard(context, large)),
          for (final side in sides) ...[
            const SizedBox(height: 24),
            SizedBox(height: sideCardHeight, child: _buildSideFeaturedCard(context, side)),
          ],
        ],
      );
    }
  }

  Widget _buildLargeFeaturedCard(BuildContext context, EventModel event) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: event.id)),
      ),
      child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: DecorationImage(
          image: CachedNetworkImageProvider(event.imageUrl),
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
        padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.badge.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      event.badge.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmall ? 22 : null,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    Text('${event.dateText} • ${event.startTime}', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    Text(event.venue, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSideFeaturedCard(BuildContext context, EventModel event) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: event.id)),
      ),
      child: Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.category.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (event.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              event.description,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${event.dateText} • ${event.startTime}'.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context, bool isDesktop, bool isTablet, List<EventModel> events) {
    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);
    final aspectRatio = isDesktop ? 0.75 : (isTablet ? 0.85 : 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Events',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: aspectRatio,
          children: [
            for (final event in events) _buildEventCard(context, event),
          ],
        ),
      ],
    );
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  Widget _buildEventCard(BuildContext context, EventModel event) {
    final month = _months[event.date.month - 1];
    final day = event.date.day.toString();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: event.id)),
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: CachedNetworkImageProvider(event.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        month.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        day,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          event.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.schedule, size: 16, color: Theme.of(context).colorScheme.outline),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                event.startTime,
                style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Theme.of(context).colorScheme.outline),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                event.venue,
                style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
      ),
    );
  }

}
