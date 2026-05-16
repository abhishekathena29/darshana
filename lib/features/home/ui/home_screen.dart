import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../provider/home_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context, isDesktop),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context, isDesktop),
            _buildSearchAndFilters(context, isDesktop),
            _buildFeaturedTemples(context, isDesktop),
            _buildCulturalPerformances(context),
            _buildSacredEvents(context, isDesktop),
            _buildNewsletter(context),
            const SizedBox(height: 80), // Padding for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: isDesktop ? null : _buildBottomNav(context),
      floatingActionButton: isDesktop
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              child: const Icon(Icons.auto_awesome),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDesktop) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 4,
      shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuC3sCWKnAQ7yUouqbzjEyx5pXZhzIV9R8XP_rGyod_nypWHQEwacfAJQ_5evmhqpFqeXybXyKdyYKKTFhPgQO_uDlmOcH0fSv0G5fSKZnrsKa3FLH2F6UqeZcKB8s1bpzXy3LCif6KX5ZGO_IExpGG0uUZFABj41GBjmcycFqX1ew7AyQQ5kre4CWTv8rLHbilNdx3c3HYv47lXrAvYKx_-iTXoF4NxJxCWgRH94xf4WfiqwGd_c2fTqlUR1cjkqr6Lt95OoxjuHCU',
            ),
            radius: 18,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              'Sudarshan',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        if (isDesktop) ...[
          TextButton(
            onPressed: () {},
            child: Text(
              'Home',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () {},
            child: Text(
              'Events',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () {},
            child: Text(
              'Sacred Spaces',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 32),
        ],
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDesktop) {
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
          image: const DecorationImage(
            image: CachedNetworkImageProvider(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBEwfEb_TRm96ELULdyI2I2cTdefNsWRpsTyyge_N2vK-HFsNktvj6cc9Qamn5RPidDtjlIDHzEWnPdEVyi2hWu7GVXTC7wPkLCLADMgg34lNPIPMspjWu4v_zPnxLLMis6jH1OX4P3Qbgy2lThqswZ7cOCZQNsrwWwLHBWCba20ymb65IGmrlfVKmkiTlJ_WEGIqZLr7mIO-5We4TDc_se-KZI1Vg13XOmFRye4F_b-yW8XMUexiLA-8eHOhA_QrEJf9EKcXv4Q8s',
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
                  'FEATURED FESTIVAL',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Grand Brahmotsavam at Tirumala',
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
              if (isDesktop)
                Text(
                  'Experience the celestial aura and timeless traditions during the nine-day spiritual celebration of the Lord of Seven Hills.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
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

  Widget _buildFeaturedTemples(BuildContext context, bool isDesktop) {
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
                    child: _buildTempleCard(
                      context,
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAC8-zMkY0RUdyrxAovlboegmsa1i850vK4UYOW1npJYZ8qpzn8VVFvubu6NobRMJYw_D8ddNSNKWo9geBdFjGra9OC_Numy_5HwrqcNFc90RvxDf_H5YDEhAE0F0IozP9XknQqHEtG8vy7zoidQHyel4kucnXORcpJvuGUvn-lu6bmptUoL4uzXW54soy1wL6ZOOWd2JL-zpeFZHeI_Zcr4XFV3Ks_Zi9OPPcmqU_Rscp4gSGSjPoyLDt6OXJsj2UN1xMKSgDpO20',
                      'Meenakshi Amman',
                      'Madurai, Tamil Nadu',
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildTempleCard(
                            context,
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCH2nCQECscyLgZMmoJxNX-FTOybPTVHjYNo43ArqS1wd-UjwdMZjzpKdzCUd7Z--Q51XmYQuye8I8eaTpqn5RzCC5-mi2frEs6MSFblQZM36E7xzLEVhIcBRhCCdF4n6XClvgXfjXg5mWd0fW9Q9lEtZ05jF-Di1lZVIJwF4_iCywIuyit0I8eThbGoSR4qU9dTRyBEN6kI2CdzMtSgJnksrRHwR2I0P6QCH7TCd1rMf0QnEwTeR2xnsVejYQwH7s4_Gb8QepsZ8M',
                            'Golden Temple',
                            'Amritsar, Punjab',
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: _buildTempleCard(
                            context,
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuA63TArA23Q3cQ-yzPFV5WOp54WPwH12_lC_fXuIbT7zXKRFA2TgSza6Rq6MEGzx0oFSKKKMOt_cTgmtwUMNKVTcyjyrXqC8WRO6LrGMZDHAG0KSzSvVA6gTloLIpWHXemU2_7q_22ObsO2NTYbLdToCERe10t7JKCrfmQjejEDZcamO-qL9Jh0L6V9LooYKrMz3uq2kltqZIZNShLNsxrDAZ2dfKnzp2kG5OagStmMsetyXEyUswKrDQcQJSeP7iy1fceo8MWr_EE',
                            'Brihadisvara',
                            'Thanjavur, Tamil Nadu',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                SizedBox(
                  height: 400,
                  child: _buildTempleCard(
                    context,
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAC8-zMkY0RUdyrxAovlboegmsa1i850vK4UYOW1npJYZ8qpzn8VVFvubu6NobRMJYw_D8ddNSNKWo9geBdFjGra9OC_Numy_5HwrqcNFc90RvxDf_H5YDEhAE0F0IozP9XknQqHEtG8vy7zoidQHyel4kucnXORcpJvuGUvn-lu6bmptUoL4uzXW54soy1wL6ZOOWd2JL-zpeFZHeI_Zcr4XFV3Ks_Zi9OPPcmqU_Rscp4gSGSjPoyLDt6OXJsj2UN1xMKSgDpO20',
                    'Meenakshi Amman',
                    'Madurai, Tamil Nadu',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: _buildTempleCard(
                    context,
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCH2nCQECscyLgZMmoJxNX-FTOybPTVHjYNo43ArqS1wd-UjwdMZjzpKdzCUd7Z--Q51XmYQuye8I8eaTpqn5RzCC5-mi2frEs6MSFblQZM36E7xzLEVhIcBRhCCdF4n6XClvgXfjXg5mWd0fW9Q9lEtZ05jF-Di1lZVIJwF4_iCywIuyit0I8eThbGoSR4qU9dTRyBEN6kI2CdzMtSgJnksrRHwR2I0P6QCH7TCd1rMf0QnEwTeR2xnsVejYQwH7s4_Gb8QepsZ8M',
                    'Golden Temple',
                    'Amritsar, Punjab',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: _buildTempleCard(
                    context,
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA63TArA23Q3cQ-yzPFV5WOp54WPwH12_lC_fXuIbT7zXKRFA2TgSza6Rq6MEGzx0oFSKKKMOt_cTgmtwUMNKVTcyjyrXqC8WRO6LrGMZDHAG0KSzSvVA6gTloLIpWHXemU2_7q_22ObsO2NTYbLdToCERe10t7JKCrfmQjejEDZcamO-qL9Jh0L6V9LooYKrMz3uq2kltqZIZNShLNsxrDAZ2dfKnzp2kG5OagStmMsetyXEyUswKrDQcQJSeP7iy1fceo8MWr_EE',
                    'Brihadisvara',
                    'Thanjavur, Tamil Nadu',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTempleCard(
    BuildContext context,
    String imageUrl,
    String title,
    String location,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
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
              title,
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
                  location,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCulturalPerformances(BuildContext context) {
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
          height: 380,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              _buildPerformanceCard(
                context,
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAGMEp4Hy7LocA-Jbs1JA9gwrhwHpPQlf7P35k00XW4PyN0gFC3mRP49dtcr4fet9WUSUOhFolnSSwutNOgy_bjucl_XJDyrXTab1gttAUU6t66To7b3MlUA64oEJFj8YeWJ3mEFHEWRydtOqpv0cM6Y0s49eujgURaVESFfze3QkmSQKT15pvzMhqKgcjj2RxGPznmKDeFKh8unTLTLC9qkHWlBdd7Ikv2sTUNKxab6jZeX8WopNLCgrtVrzZCU_ikSLGQzSL5eLQ',
                'Classical Vocal',
                'LIVE',
                'Smt. Aruna Sairam',
                'Oct 24 • 6:30 PM • Music Academy',
              ),
              const SizedBox(width: 24),
              _buildPerformanceCard(
                context,
                'https://lh3.googleusercontent.com/aida-public/AB6AXuC8xGTH7J6s3f6g0qkIMzyL5-YsdzD-SUbNcm4RNa6yAC-JqRJE5OTQtBMR28Jo032kR8Hq8LuGNLC5Q3dH7vANnXKhpFkBDXfkLZOHy6HtJpFf-qGSjTKuQs-wA6H7QlbkGuIa4G7iO17J155Gt1y9kxpWANy9l-2DnPL5KTuFlc_ihGZU7inoSJlvkWvEipkQhc_6O32I93YMd_mf8NUCv59dK_vi6VRBD4CZ2AOJ7zzznEFKGBq0TvKnlaKEewqeDr2Wq0VjVoc',
                'Sitar Symphony',
                'PREMIUM',
                'Pandit Ravi Shankar Series',
                'Oct 26 • 7:00 PM • NCPA Mumbai',
              ),
              const SizedBox(width: 24),
              _buildPerformanceCard(
                context,
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAP-YR_qg_IRjhs0WlY12EdugvDzhzwaWpBhr9OhqOZBqZg8ZnfjJIbPquLutCEjOcdmviTe47CiY6_eALrcURT-vUovA4Bf00BzYd9MbuzSA2ksamcmEt1gz2NJAZ4gr-LB-pJ9vtoU1MUcYs_skXMjFYBcm8tfUKEvwQaQPMjqN_iCvpN-kEYMyIfW3T5B5x_RXUTo6Liou0dEmB2rsi5DrH92qxGLTdedOfKddv0d3MTtor_2Oba3me1OMkl3p0i46LXw5yzivg',
                'Odissi Recital',
                'LIMITED',
                'Nrityagram Ensemble',
                'Oct 28 • 5:45 PM • Bangalore Palace',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceCard(
    BuildContext context,
    String imageUrl,
    String title,
    String tag,
    String subtitle,
    String timeStr,
  ) {
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
                image: CachedNetworkImageProvider(imageUrl),
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
                  title,
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
                  tag,
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
            subtitle,
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
                  timeStr,
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
            onPressed: () {},
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

  Widget _buildSacredEvents(BuildContext context, bool isDesktop) {
    final items = [
      _buildSacredEventItem(
        context,
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDK3sOcuTKYJsdselZepRaVy1_tEFgJmmix7NnBH8pXKmsZU5nJ-LBW6Bz61cj6_v9DUDAOPy3cvpXMm-5UTRtO6_DwZ0ONIO9NZv949VYAEiFpurtvfeCoEgkziTtjcuu1gF02pa2qc72jzYJ6EtRCNWEGPtUw_W9pDVN8a7jRE_mjipVLvbM4IWqPKdlccIkmUv_ANAplt6XIYSvdqtd5CBeerjNS85ZsD0788BVKwYq_wV31zyJQXJnYk0zYSFlpvN1bouyhJRo',
        'OCT 24 • TUESDAY',
        'Vasantotsavam',
        'The Spring Festival ritual at Kapaleeshwarar Temple.',
      ),
      _buildSacredEventItem(
        context,
        'https://lh3.googleusercontent.com/aida-public/AB6AXuARfKc8XTKpZdjSbsSuotZYZVApfi6GPXYFO_21VAT659DXB8TUPmwLh4z_eVsJB8brquOau3H0DsvltHSB3ssUMlQ7VwvV9156r8mA85N083uciVy1te01H84VCoa_ywal66EcvFpI4U_rDAt1jKF_KLlfDTscALbP86hhxu9_evsQZx-49vxbawgvpzeuECzND7b_JTZaR5aGjQ-u25czpzazESKHayeavGxbQGdK_U2md7A9GahNl7TD8l-Krxy5Y731_SKTuRQ',
        'OCT 26 • THURSDAY',
        'Abhishekam Ceremony',
        'Sacred bathing ritual for world peace and prosperity.',
      ),
      _buildSacredEventItem(
        context,
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBIE4Io5DxoaWpj6rPfOj7ys9mHFiRZTjtcdMH5WRRbsZD-z5VD9IsRAZWY55d5c9t6MTDvg_V6RWoVOP8lDUYcRRGMxZRokqf4ydU4wm12emePGxK9ZNSkB48oqMyW3iWSjRZxEtAoQIe_ayOI1tpHQNfgUitoL3FXBxPYveQLvqIJApsekkDbGfj2HVlKTI2o7rCGi2zEoNgH_xKZyWY_0dRfY0db4p8CBUqCr1rrDOTo73nV1d9VQK9KD-vRFC2x8FlKUF9UNNA',
        'OCT 28 • SATURDAY',
        'Srimad Ramayana Play',
        'Traditional shadow puppetry retelling the epic saga.',
      ),
    ];

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

  Widget _buildSacredEventItem(
    BuildContext context,
    String imageUrl,
    String dateText,
    String title,
    String subtitle,
  ) {
    return Container(
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
                  dateText,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
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

  Widget _buildBottomNav(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    Icons.home_filled,
                    'Home',
                    0,
                    provider,
                  ),
                  _buildNavItem(
                    context,
                    Icons.calendar_month,
                    'Events',
                    1,
                    provider,
                  ),
                  _buildNavItem(context, Icons.auto_awesome, 'AI', 2, provider),
                  _buildNavItem(context, Icons.person, 'Profile', 3, provider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    HomeProvider provider,
  ) {
    final isSelected = provider.currentBottomNavIndex == index;
    return InkWell(
      onTap: () => provider.updateBottomNavIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
