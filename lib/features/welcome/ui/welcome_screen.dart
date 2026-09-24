import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../onboarding/ui/onboarding_screen.dart';
import '../../login/ui/login_screen.dart';
import 'widgets/temple_hero_background.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final horizontalPadding = isSmall ? 20.0 : 32.0;

    return Scaffold(
      body: Stack(
        children: [
          // Background: code-drawn temple skyline at dusk
          const Positioned.fill(
            child: TempleHeroBackground(),
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

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Branding
                  Text(
                    'Darshana',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
                  Text(
                    'Discover the divine.\nExperience the culture.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          height: 1.2,
                          fontSize: isSmall ? 26 : 34,
                        ),
                  ),
                  SizedBox(height: isSmall ? 32 : 48),

                  // CTA Section
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.ctaGradientStart, AppColors.ctaGradientEnd],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
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
                          padding: EdgeInsets.symmetric(vertical: isSmall ? 16 : 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'BEGIN YOUR JOURNEY',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontSize: isSmall ? 12 : null,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton.icon(
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
