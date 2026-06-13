import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../provider/onboarding_provider.dart';
import '../../signup/ui/signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: const _OnboardingContent(),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final isShort = size.height < 700;
    final heroHeight = (isShort ? size.height * 0.4 : size.height * 0.55)
        .clamp(220.0, 520.0);
    final horizontalPad = isSmall ? 20.0 : 32.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // Hero Section
          SizedBox(
            height: heroHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCbP7jM-e7-ujGQJvIsJM25AJpvxPSxuxEZwl6nHM3L9soC6qtIMOLPdzCG_-ucOaaW96-dIhTwq_2P4n9xWT9eXClhZ6H-r0kgyBCAVih5-syKf8C38Fw_zAGL11Rk37Lqab-uWqMBNOn-dHdVNmGcUwcgQXkSTyn2XY1ux7U3_mEPZAROPTsrklbOi3Qi7SVOCXbG60CAqNVh0MlaW6peT0VuJ0ZW4oJJVS162rMwFKx-qTrL9JYG4wy05dSRgG8nHHGFfdfPFAs',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.7, 1.0],
                      colors: [
                        Theme.of(context).colorScheme.surface.withOpacity(0.0),
                        Theme.of(context).colorScheme.surface.withOpacity(0.8),
                        Theme.of(context).colorScheme.surface,
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, left: horizontalPad),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Sanctuary',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                child: Consumer<OnboardingProvider>(
                  builder: (context, provider, child) {
                    return SingleChildScrollView(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step Indicator
                        Row(
                          children: [
                            _buildStepIndicator(0, provider.currentStep, context),
                            const SizedBox(width: 8),
                            _buildStepIndicator(1, provider.currentStep, context),
                            const SizedBox(width: 8),
                            _buildStepIndicator(2, provider.currentStep, context),
                            const SizedBox(width: 16),
                            Text(
                              'STEP 0${provider.currentStep + 1} / 03',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Headline
                        Text.rich(
                          TextSpan(
                            text: 'Discover Sacred\n',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                  fontSize: isSmall ? 28 : null,
                                ),
                            children: [
                              TextSpan(
                                text: 'Sanctuaries',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Body Text
                        Text(
                          'Explore the living history of timeless monuments. Uncover hidden traditions, precise ritual timings, and the architectural wonders of the ancient world.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                height: 1.6,
                              ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Feature Chips
                        Row(
                          children: [
                            _buildFeatureChip(Icons.history_edu, 'History', context),
                            const SizedBox(width: 16),
                            _buildFeatureChip(Icons.schedule, 'Timings', context),
                          ],
                        ),

                        SizedBox(height: isShort ? 24 : 48),

                        // Buttons
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.ctaGradientStart, AppColors.ctaGradientEnd],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                offset: const Offset(0, 8),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (provider.currentStep == 2) {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                              } else {
                                provider.nextStep();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'NEXT',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                            },
                            child: Text(
                              'SKIP INTRODUCTION',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int index, int currentStep, BuildContext context) {
    bool isActive = index == currentStep;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 4,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label, BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.tertiary, size: 20),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
