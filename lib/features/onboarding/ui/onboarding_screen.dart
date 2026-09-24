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

class _OnboardingStep {
  final String imageUrl;
  final String headline;
  final String headlineAccent;
  final String body;

  const _OnboardingStep({
    required this.imageUrl,
    required this.headline,
    required this.headlineAccent,
    required this.body,
  });
}

const _onboardingSteps = [
  _OnboardingStep(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCbP7jM-e7-ujGQJvIsJM25AJpvxPSxuxEZwl6nHM3L9soC6qtIMOLPdzCG_-ucOaaW96-dIhTwq_2P4n9xWT9eXClhZ6H-r0kgyBCAVih5-syKf8C38Fw_zAGL11Rk37Lqab-uWqMBNOn-dHdVNmGcUwcgQXkSTyn2XY1ux7U3_mEPZAROPTsrklbOi3Qi7SVOCXbG60CAqNVh0MlaW6peT0VuJ0ZW4oJJVS162rMwFKx-qTrL9JYG4wy05dSRgG8nHHGFfdfPFAs',
    headline: 'Discover Sacred\n',
    headlineAccent: 'Sanctuaries',
    body: 'Explore the living history of timeless monuments and uncover hidden traditions.',
  ),
  _OnboardingStep(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAdfhQvhLaA6RCxWiMBr5WGMj45NMtcXqh5pCqRAbDUwP82kWQOdBKvuGuVH-17ofDfeBL5xkHxSC2tVdHI4-kV9vuAIZjpJRq5v9PQ30dMZdu5G2qJouof4ozjEsMKBi4nRIWujx1YN4kUzCKDIgLg8yLx23henCcOjssPwd5RaFCxUmowLuGjiWYqSM0HdwcGy2zerbjscMUvNy6zuNdLEXWkB_TL8D-scncSf0JnI3MKjah47UjAgSiRoTU2DRoK9ob667-h5Ro',
    headline: 'Join Sacred\n',
    headlineAccent: 'Gatherings',
    body: 'Find and reserve your place at temple festivals and cultural events near you.',
  ),
  _OnboardingStep(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuB4TCv2GLI-N3uZgpDitEt2sbyt3FqRpAn0lVu0RvqduamDW2PR176nnlqsrOnEbrutRHoLNR-aQ1Wz8h_beSjtWokPrY7h0V3zJogzN_JBo9p7zp35cyXyqoJOWlPsfNvDqPw3ylx9zIY0AMXd2OuE5jp3c-3SHwnWAMyKEoUfacP--HaVMuQOzcTWOW-_WayOram9CoSoMcEM5iGIw7AK2OWS-Lj76bXAMinjaM7IF2UXe0_1x3lRnr_aRf2bI4_Go-mFPjZg38A',
    headline: 'Walk Your Own\n',
    headlineAccent: 'Sacred Path',
    body: 'Get a personalized itinerary and an AI companion for your journey.',
  ),
];

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final isShort = size.height < 700;
    final heroHeight = (size.height * (isShort ? 0.4 : 0.5)).clamp(200.0, 420.0);
    final horizontalPad = isSmall ? 20.0 : 32.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          final step = _onboardingSteps[provider.currentStep];
          return SafeArea(
            child: Column(
              children: [
                // Hero Section
                SizedBox(
                  height: heroHeight,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: CachedNetworkImage(
                          key: ValueKey(step.imageUrl),
                          imageUrl: step.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: horizontalPad,
                        child: Text(
                          'Darshana',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Section
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(horizontalPad, 20, horizontalPad, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
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
                            SizedBox(height: isShort ? 12 : 20),

                            // Headline
                            Text.rich(
                              TextSpan(
                                text: step.headline,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                      fontSize: isSmall ? 24 : null,
                                    ),
                                children: [
                                  TextSpan(
                                    text: step.headlineAccent,
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Body Text
                            Text(
                              step.body,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                            ),
                          ],
                        ),

                        // Buttons
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                                    );
                                  } else {
                                    provider.nextStep();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: isShort ? 14 : 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      provider.currentStep == 2 ? 'GET STARTED' : 'NEXT',
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
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                                  );
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
}
