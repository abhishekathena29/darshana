import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../provider/event_details_provider.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventDetailsProvider(),
      child: const _EventDetailsContent(),
    );
  }
}

class _EventDetailsContent extends StatelessWidget {
  const _EventDetailsContent();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isSmall = size.width < 360;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 48.0 : (isSmall ? 16.0 : 24.0),
          vertical: isSmall ? 16.0 : 24.0,
        ),
        child: Column(
          children: [
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroSection(context),
                        const SizedBox(height: 48),
                        _buildGuideSection(context),
                        const SizedBox(height: 48),
                        _buildArtistsSection(context),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        _buildEventPassSidebar(context),
                        const SizedBox(height: 48),
                        _buildCommunitySection(context),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(context),
                  const SizedBox(height: 32),
                  _buildEventPassSidebar(context),
                  const SizedBox(height: 48),
                  _buildGuideSection(context),
                  const SizedBox(height: 48),
                  _buildArtistsSection(context),
                  const SizedBox(height: 48),
                  _buildCommunitySection(context),
                  const SizedBox(height: 40),
                ],
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        'Darshana',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA0ke83SrFkdXrGmkeL6uEOl61VI6UdfzekOEvq_01FdPh5SSwDzS85X-nQVNl9UjREljzOzzHCHiLckV7-3M_xiT2dSm9-WYGiTJxyXP_odU7XPl7CYa9ywZMmgarhKeeVSK1lncmT9oNteXO864nno5jVAPPtp3eTqPyROxbqqfO80WAOHs5CIsoZOudNDM240qB1kkvXercDOwoPfR_XkTswDp3ZsWenMa-ogGrIHKxOh67mVveVTBmSZewDYfvClvBldWTvB78',
            ),
            radius: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final heroHeight = size.height < 700 ? 280.0 : 400.0;
    return Column(
      children: [
        Container(
          height: heroHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            image: const DecorationImage(
              image: CachedNetworkImageProvider(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCQsrlmk8xvGBIUL0Nto3N4GDdLGD39x2LJpScU_R-AtAsQri0UhJLbzopDsXo4e818-uzqJG1IT7KRDUotk6O3o8h0sJNtBnWiozul5GXnledQOH3hoH9EbLP6O9gCDOYSatv7tGzgyQCoEYa1boufDACN0WE-j02kdmE33WX88_1z5uQem7dtZ3jYTsuXVt81sDwZoT8HDToyV1rj_J4NBAxkS5daqJQLdXsiwUH30QCHFu_Ax_3-KWk5RGpiE0YubWjcW2A-bdQ',
              ),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'GRAND CELEBRATION',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Navaratri Golu & Concert Series',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmall ? 22 : null,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: size.width < 400 ? 2 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: isSmall ? 2.0 : 2.5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildInfoTile(context, Icons.calendar_today, 'DATE', 'Oct 15 - 24, 2024'),
            _buildInfoTile(context, Icons.schedule, 'STARTS AT', '06:00 PM IST'),
            _buildInfoTile(context, Icons.location_on, 'VENUE', 'Heritage Pavilion'),
            _buildInfoTile(context, Icons.hourglass_empty, 'DURATION', '4 Hours Daily'),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEventPassSidebar(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
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
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Pass',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Single Day Entry', style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12)),
                    Text('₹1,250', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'LIMITED',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          _buildFeatureRow(context, 'Full access to Concert Hall'),
          const SizedBox(height: 16),
          _buildFeatureRow(context, 'Prasadam & Evening Refreshments'),
          const SizedBox(height: 16),
          _buildFeatureRow(context, 'Digital Souvenir Kit'),
          const SizedBox(height: 32),
          Consumer<EventDetailsProvider>(
            builder: (context, provider, child) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: provider.isBooking ? null : provider.bookTicket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: provider.isBooking
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'GET ENTRY PASS',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'View Official Ticket Link for Group Bookings',
              style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, String text) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Widget _buildGuideSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                'How to Participate',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
          ],
        ),
        const SizedBox(height: 32),
        _buildGuideStep(context, '1', 'Reporting Time', 'Please arrive at the West Gate by 05:30 PM. Late entries may have to wait for the ritual breaks to find seating.'),
        _buildGuideStep(context, '2', 'Materials Needed', 'Guests are encouraged to bring flowers (Jasmines or Roses) or small fruits for the offering. Please avoid plastic bags inside the pavilion.'),
        _buildGuideStep(context, '3', 'Attire Guide', 'Traditional ethnic wear is highly recommended for all participants to maintain the sanctity of the cultural space.', isLast: true),
      ],
    );
  }

  Widget _buildGuideStep(BuildContext context, String number, String title, String description, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Artists Lineup',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Full Schedule',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildArtistCard(
              context,
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAt1aX1YEw9OHeYGiISC5qFf4-Hb9xpWE84m0H3mzCGEddNtPtlRAXV9ugqQVeli8rDk2WXHu1wsw6pYJUYfX1OaaHqdPAq_GCkb2-1m5I2nkOMfdePCjaVhxkmPvGf6z1JceQfYobSemcPCEGmF1vnoyaKLWbRoR-gRw8pcnujG0PEkHrGCSVxMZGYttbBXvFEYzXWhPzG-iLLJmUh26iKpcOPGCkxkBakLXfglUoaO7ljfITJCgUZEm7s6aKt9VpmTwzzMEgENc8',
              'LEAD VOCALIST',
              'Vidya Ramanathan',
              'Carnatic Classical Legend',
            ),
            _buildArtistCard(
              context,
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDfSIbFYEmBVzTUeoz8aowOa75u5VHV6Qo8nwRNfFHlyKN9m_kxkfJYqBcIMq4w02ec_aC7UZzdf24VcgeS8_4cGKxOVPEewqYhpYMsrQty7lJtkcXm1rq8hCXkDdCPNmC0in3p4LrSppLpWWXCt5co8KqO32T3ColktkvhE60mqGyR8XepNg6Ce29Yav1y0S75ZLtlbT3rFGM0hs2l126vG58DKbgonJ0DjEeBb3yA2NjvCgHUMoMiAro_Y12chwwwdTbsjWZnehM',
              'MRIDANGAM',
              'K. Vishwanathan',
              'Master of Rhythm',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArtistCard(BuildContext context, String imageUrl, String role, String name, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  role,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunitySection(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.groups, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Who else is attending',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildAvatarStack(context),
              const SizedBox(width: 16),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.surface, width: 4),
                ),
                child: Center(
                  child: Text(
                    '+82',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildCommentItem(
            context,
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDY3Xe4aeBtR0aFiIolAP7xOJeCYTqyry1zFmvDLRGr79YQxgAGhKDURZ4TEbLdDdBUp0HqzcH1WoFUdkuGMTjsBcrx_VrAREUWWpJsqza6SRpiF_O-EyZUrYnhjlPVOll3Dv9VxKKpT0ZA265AE8H3yxjuuphQXPqckp1W39A4-ikLCEqfb32mWhU9eVn6VBTxTylX39EG-aGj0wPX2Lh4Y9V2qd5wWOFQHhBW0T8sOntsltdSoh4wL0LgqvIf_4KS1YqGXfU7_0k',
            'Arjun K.',
            "Can't wait for the violin solo on Day 3! Bringing my parents along too.",
            '2 hours ago',
          ),
          const SizedBox(height: 24),
          _buildCommentItem(
            context,
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBEl7yxthS2kbjPIR1Lq1vtuBrzkgb_OsfSiRi-qlt3319mRB9obUOu11VsnjZAVPS3N2a32bfqIVLV8xAyiaF4ZxEwePeXSOw5WiNMyue6WmlEmSEVoDRyx_5lVSeYxp-H2v24I1F_SfPOZxjpUuRREfA5cdkNCe8BdXrpmTjBt7-Cfnva4rJacrtt-X9KV4wAUmz0S0jgmiii83YaAQwWoZGYqLaHS66PUS5Er6WpbAX5kp2pwEROTfxEKc6XufsHrZrUcEDuegE',
            'Sanjana Rao',
            "The Golu arrangements last year were ethereal. Looking forward to this year's theme.",
            '5 hours ago',
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Share your excitement...',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack(BuildContext context) {
    final images = [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBq5lo5c6NIhN6hdwewt9hsUo6FI04FieCOLJeQ0Z8mPjjTT4tV-Jr4nd2ewszXkwyoLeXvYzoCPjDvPTx3Wpe4RhoSeCtVFtCPdYe_6QkKvpDKNiqWW8QwPBnAsmHVXeNjJM1_MtT-H0ZWYStITgsqRDD9lo8jdO88Ayu--0oIyUL97_kW34fuDD_ORWJh_2xc8XjyfJox46vWkkrpVTLRkXOIu-PcUV_mjH7CEp9pG5Fz9p9SzFvzwM9oDyjA39ZaRownwrq-RKE',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAdyU72Uq-EFOw-caFgppVF5zmEAk5q8H4B3AramLgHt-O9XCPkeqPUjBjFF2jIkpwh9ugRiPFHXQNrZ_iWmUjjekhLVapB_HawuFzl2KyeqEHiU_GOXMUvSxYDNIG2uUUbgi0buhNdWP33VNwKKzUYYyQ6NmIeM1qHTZ_r9m-ATTSNzHwrn9GREoAT6bHxI7sl_jjO7F3BdbQzqS8Qr1H78-kSxPyt7716hxo3IOjzya5tp1dwC9ZrajkkbY6Ut0QdIcIuLyjKWPQ',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCsfNrQ60_j6uCjOxPi4ENPRDoqSLyKz0f6ZlvFsR7FbY6BlcnkkXOSszvoTbZ-qWZpNQmgrBlbIM4S8q9w6jF_mSiYJifQKKcKajWf22h8EqWC2JFpc4tM8v-s0GYeps10-UbC9eQfG4fV9679sdm9l6TjFj77Kw4vlTmvPMKQ0ilJVXNKlNPztRqncfQ002zKrxSEP2oT4EW0UWdvT9aWf5JZf6bZL0EgDOUBVTVAp9Pqt033iBF65QC0HbzaCEk79hSinoHcZoE',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAlD_QltHSaidp_JReFQqfOpK2QlL4QvngJIFPj4BXUFUd3LHGbOhQ0ViwD4dVT_PUFGy8vJBcUFT9SNJVFqQ9VtyZo2AiwT1qAwV50G2BnoGZUOU2dq4VPUHdqbwShG_KkRSKylVSe5p4--QV2mKWE6DvL38amuQpcHoKsWqdTvgbTy2pvKpiWJIr-s_N0LhMhD-Ea336ZPqsx23CNbhaFGncetf2UtCeeoSGprdWRhsbKYRk7hZS048oycg0l_dejlFTJkcZGmo0',
    ];

    return SizedBox(
      width: 48.0 + (images.length - 1) * 32.0,
      height: 48,
      child: Stack(
        children: List.generate(images.length, (index) {
          return Positioned(
            left: index * 32.0,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.surface, width: 4),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(images[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, String imageUrl, String name, String comment, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(imageUrl),
          radius: 20,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(comment, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(time, style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 10)),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
