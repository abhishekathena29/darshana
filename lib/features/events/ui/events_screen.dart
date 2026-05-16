import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../provider/events_provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventsProvider(),
      child: const _EventsScreenContent(),
    );
  }
}

class _EventsScreenContent extends StatelessWidget {
  const _EventsScreenContent();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSearch(context),
            const SizedBox(height: 32),
            _buildCategoryScroll(context),
            const SizedBox(height: 40),
            _buildFeaturedBentoGrid(context, isDesktop),
            const SizedBox(height: 48),
            _buildUpcomingEvents(context, isDesktop),
            const SizedBox(height: 100), // padding for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: isDesktop ? null : _buildBottomNav(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.primary),
        onPressed: () {},
      ),
      title: Text(
        'Sanctuary',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
      ),
      actions: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBl3pXYIlih--dEH6zYitCOIkIgytNjlWDOfeclLGRtypaPdr7a-AmqrEULjZXv90LU6XoSB1NTev5_LwvPwtvCIJeW-FZLkTUDvTE3SV9_JFMXHBPKkTT6AvybNppK_EY1-srYJKwNMqp8UHeEnF28pe-0DIh9IlZzBk98VOi0v3m1vz7FupmxBu8SMC6EljBuK34EZauz40mELa-BTHPB7u41FuEjfoDjG10MHXFDs2D-eI1UTU-OQK6Qn7cVVO1zS27n3wk6Keg',
            ),
            radius: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSearch(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discover Sacred Gatherings\n& Cultural Festivals',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
        ),
        const SizedBox(height: 24),
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
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

  Widget _buildFeaturedBentoGrid(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      return SizedBox(
        height: 500,
        child: Row(
          children: [
            Expanded(flex: 2, child: _buildLargeFeaturedCard(context)),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(child: _buildSideFeaturedCard(context, 'Spiritual Music', 'Evening Raga & Meditation', 'A soul-stirring performance by maestros in the heart of the sacred valley.', 'March 12 • 5 PM', null)),
                  const SizedBox(height: 24),
                  Expanded(child: _buildSideFeaturedCard(context, 'Cultural Tour', 'Temple Heritage Walk', null, 'March 15 • 7 AM', 'Limited Spots')),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 400, child: _buildLargeFeaturedCard(context)),
          const SizedBox(height: 24),
          _buildSideFeaturedCard(context, 'Spiritual Music', 'Evening Raga & Meditation', 'A soul-stirring performance by maestros in the heart of the sacred valley.', 'March 12 • 5 PM', null),
          const SizedBox(height: 24),
          _buildSideFeaturedCard(context, 'Cultural Tour', 'Temple Heritage Walk', null, 'March 15 • 7 AM', 'Limited Spots'),
        ],
      );
    }
  }

  Widget _buildLargeFeaturedCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: CachedNetworkImageProvider(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAdfhQvhLaA6RCxWiMBr5WGMj45NMtcXqh5pCqRAbDUwP82kWQOdBKvuGuVH-17ofDfeBL5xkHxSC2tVdHI4-kV9vuAIZjpJRq5v9PQ30dMZdu5G2qJouof4ozjEsMKBi4nRIWujx1YN4kUzCKDIgLg8yLx23henCcOjssPwd5RaFCxUmowLuGjiWYqSM0HdwcGy2zerbjscMUvNy6zuNdLEXWkB_TL8D-scncSf0JnI3MKjah47UjAgSiRoTU2DRoK9ob667-h5Ro',
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  const Text(
                    'LIVE NOW',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Maha Shivratri Celebration 2024',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                    SizedBox(width: 8),
                    Text('Tonight, 6:00 PM', style: TextStyle(color: Colors.white70)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.location_on, color: Colors.white70, size: 16),
                    SizedBox(width: 8),
                    Text('Varanasi Ghats, India', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideFeaturedCard(BuildContext context, String tag, String title, String? description, String timeStr, String? badge) {
    return Container(
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
            tag.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (description != null) ...[
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
          if (badge != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timeStr.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Events',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: isDesktop ? 3 : 1,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: isDesktop ? 0.75 : 1.0,
          children: [
            _buildEventCard(
              context,
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDTCs4Ew6tFzt1nRh-5bq9svMtGid7nJ2_Rw56gsMjte8ZY3Ing4kAqlgIjCqO_TJlIuW2zjhPyg4DZOdJNhBlK9W0bqybuec55zfoJCCSsMMiTJZ5Ek_BAB2MOrjukoRemRLT7tIHMQZvrBKvphSxdVhEHJRWMZxN5DtOs1gTSYt7HiyyfkfuqukO-MFeJgP65ru7vaEv5HSF_Y40nmrEEUZLXiWNv2JiLqC1glFI7sEpPvK7w3_Pt-Q2pbM2Yh7tIhsXx0fikVVM',
              'Mar',
              '18',
              'Vedic Chanting Workshop',
              '10:00 AM - 1:00 PM',
              'The Lotus Center, Rishikesh',
            ),
            _buildEventCard(
              context,
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCVbeTpQTeUaCuTOLpBM9uiIsYagvcNLEXOz6-s6YBtnCKLKdgStonN5ZuOLYW-wA1-2hcuH5GVOhL7BJI6Rbdy4wGifVCcQB91-T_8nKyrpTw1w2U-WeOKoyHzGRLSTn5wNLbgpvptkDwdBRXoT9O3dGA4BInOGaCMMJ3D6TzIs2xU0wcFfG6jPucqhJivkeUXufeJBY4w8t37kCJsOF89fhgNs5pxmqxgLS7qcG37my_Q_wKiMSjZt_UX33mFzpHvf-hXCrmUbI0',
              'Mar',
              '22',
              'Spring Kathak Recital',
              '07:30 PM Onwards',
              'Royal Opera House',
            ),
            _buildEventCard(
              context,
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCZ-trqgjaEbqIsoQ-OcuSVuvJvmvu-j3z4EyuIAdCvstBY7KEe-LNW_-3A6abxJOqk9dCwFprdOynMKV0_snDq2MvFGx1wQxUmABVNKesSd0igExXJRvsqsaMoWz44W04Y10R4jjjfV7679NiAfSmuqgzoLp4sINEBndyclc1yu66vbjjhaR-bXoaN6jv7mnrshSYu2zFTYnKUxP9Smh1H6vdtypurfNJ0NO6SUAYk1wQdv_Pg4VwQSXcvC-r5-lClGGzIDRAqW1w',
              'Mar',
              '25',
              'Saraswati Puja Gathering',
              '09:00 AM Daily',
              'Community Hall, South Extension',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, String imageUrl, String month, String date, String title, String time, String location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
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
                        date,
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
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.schedule, size: 16, color: Theme.of(context).colorScheme.outline),
            const SizedBox(width: 8),
            Text(time, style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Theme.of(context).colorScheme.outline),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                location,
                style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              _buildNavItem(context, Icons.temple_hindu, 'Home', false),
              _buildNavItem(context, Icons.event_note, 'Events', true),
              _buildNavItem(context, Icons.menu_book, 'Journal', false),
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
        color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5) : Colors.transparent,
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
