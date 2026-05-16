import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../onboarding/ui/onboarding_screen.dart';
import '../../login/ui/login_screen.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final isWide = size.width > 600;
    final horizontalPadding = isSmall ? 20.0 : (isWide ? 32.0 : 24.0);
    final verticalPadding = isSmall ? 16.0 : 24.0;
    final decorIconSize = isWide ? 200.0 : 140.0;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAkWUG3mUcCQvl_Lh1JIdt6_79pxKgDSaZsCi3Iwjd7PEsLLfJaNnsf9cVu7xitbhBOyMCKgKUn0Vvp3nGk8S4nG-7tcSMpsR5qUEb-AImrdY4lxNrNjXkyMf1nkTUMGrbLF7iZd2LdIOFT_hFzbew6Yp83G2nvJxdPKB9znW3RTWNVJ6fj6i3BG2EciuTi1T8AfBzyEhToPEQF_1AJA2uCT-f-IEuhqtcCJzoffneHO77h4ggIsic3sFYpq9VoWwbbxbkj-b3fOh8',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black45,
                  ],
                ),
              ),
            ),
          ),

          // Decorative Element (clipped to avoid horizontal overflow on small screens)
          Positioned(
            top: -decorIconSize * 0.2,
            right: -decorIconSize * 0.2,
            child: Opacity(
              opacity: 0.2,
              child: Icon(
                Icons.temple_hindu,
                size: decorIconSize,
                color: Colors.white,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - (verticalPadding * 2),
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Branding
                          Text(
                            'Sudarshan',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                  fontSize: isSmall ? 22 : null,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 48,
                            height: 2,
                            color: AppColors.primaryLight,
                          ),

                          const Spacer(),

                          // Central Content
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                              child: Text(
                                'Discover the divine.\nExperience the culture.',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      color: Colors.white,
                                      height: 1.2,
                                      fontSize: isSmall ? 24 : null,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: isSmall ? 20 : 32),

                          // CTA Section
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: isSmall ? 12 : 24,
                            runSpacing: 16,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppColors.ctaGradientStart, AppColors.ctaGradientEnd],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      offset: const Offset(0, 12),
                                      blurRadius: 32,
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmall ? 24 : 40,
                                      vertical: isSmall ? 16 : 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: Text(
                                    'BEGIN YOUR JOURNEY',
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          fontSize: isSmall ? 12 : null,
                                        ),
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                                },
                                icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                label: Text(
                                  'LOG IN',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5,
                                      ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isSmall ? 28 : 48),

                          // Footer Details
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: isSmall ? 40 : 48,
                                      height: isSmall ? 40 : 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white24, width: 2),
                                        image: const DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCW93nTqFhk6CKJVSMKvsZAJQgSN9Dcvr-tzD1jyrm0etYCAQH02ZX9m0ka_vLh_OoCAisgpKGq3_1Thp5rKlTE3XskFiT-KspvtEg9ZeOOQgZLN_N6eTpN-5LWnuzQll0r6OpdHFg4IgyOnJf9nOIhtaFP5_ZcsxRUau0afaAMhzsMPIn3rxu9hUUWWIMh0LMXW6_QiO7ReP-fc2vJ77FUxoIqOE0JN2yHWvsTpelqaEJcxaFzp-tXpZvayFDx2M3KuSRJddU944Y',
                                          ),
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
                                            'CURRENT WISDOM',
                                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                  color: Colors.white60,
                                                  letterSpacing: 2.0,
                                                  fontSize: 10,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '"Truth is one, paths are many."',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.white,
                                                  fontSize: isSmall ? 13 : null,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Stats (hidden on small screens)
                              if (isWide) ...[
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'SACRED SITES',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: Colors.white60,
                                            letterSpacing: 2.0,
                                            fontSize: 10,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '1,200+',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 32),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'SEEKERS',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: Colors.white60,
                                            letterSpacing: 2.0,
                                            fontSize: 10,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '450k',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
