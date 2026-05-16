import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../provider/login_provider.dart';
import '../../home/ui/home_screen.dart';

const String _googleSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"></path>
  <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"></path>
  <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" fill="#FBBC05"></path>
  <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"></path>
</svg>
''';

const String _appleSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M17.05 20.28c-.98.95-2.05 1.61-3.15 1.61-1.06 0-1.63-.57-2.81-.57-1.16 0-1.85.55-2.76.57-1.12.02-2.1-.64-3.12-1.61-2.12-2.01-3.11-6.1-1.03-9.5 1.04-1.71 2.92-2.76 4.54-2.76 1.25 0 2.22.65 3.04.65.77 0 2-.75 3.35-.75 1.44 0 3.1 1 4 2.37-3 1.63-2.51 5.37.5 6.75-.76 1.83-1.66 3.24-2.56 4.24zm-3.1-17.78c-.01 0-.02 0-.03 0-1.61.05-3.04 1.14-3.79 2.58-.33.62-.51 1.29-.51 1.95 0 .04.01.08.01.12.01.01.02.01.02.02 1.72-.07 3.1-1.22 3.82-2.71.32-.67.49-1.38.48-1.96z" fill="currentColor"></path>
</svg>
''';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatelessWidget {
  const _LoginScreenContent();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isSmall = size.width < 360;
    final formPadding = isDesktop ? 64.0 : (isSmall ? 20.0 : 32.0);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 48.0 : (isSmall ? 12.0 : 24.0),
              vertical: isSmall ? 12.0 : 24.0,
            ),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 1024),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 32,
                    offset: const Offset(0, 16),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left Image Side (Desktop only)
                      if (isDesktop)
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCVhiEPerncZbnjwK5505irLBxgws9ek-c1ZR2M0ADexQMwAhctLUaNhx71q9oDxsqe8kP0y3L6coHfVYXThnKNvdC3oBDknw49OBGBdqv3sg4pvyngauY4tHQirFRU5xmFwRU0-1ijFTJln_lkSiNWeL4OlRYvFKsFYsuhwhSo39YMvmTep8EDzn8SkPlNH8UmoSvyQusticzx3N77hwOxWyNYDMyjnbx-mfkkd-c3-1ER1xhCpHxiULWvv8MAM9JaVYynkFYy9g0',
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black87,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 48,
                                left: 48,
                                right: 48,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '"Truth is not something found in the books, but something lived in the heart."',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                            height: 1.5,
                                          ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 1,
                                          color: AppColors.secondaryLight,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'ANCIENT WISDOM',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                color: AppColors.secondaryLight,
                                                letterSpacing: 2.0,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      // Right Login Form Side
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(formPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sanctuary',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Welcome back, seeker. Your path awaits.',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                              const SizedBox(height: 48),
                              
                              // Email Field
                              Text(
                                'EMAIL ADDRESS',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'email@temple.org',
                                  prefixIcon: const Icon(Icons.mail_outline),
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              // Password Field
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'PASSWORD',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Consumer<LoginProvider>(
                                builder: (context, provider, child) {
                                  return TextField(
                                    obscureText: !provider.isPasswordVisible,
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          provider.isPasswordVisible
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                        onPressed: provider.togglePasswordVisibility,
                                      ),
                                      filled: true,
                                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 32),
                              
                              // Login Button
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppColors.ctaGradientStart, AppColors.ctaGradientEnd],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
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
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ENTER THE SANCTUARY',
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
                              
                              const SizedBox(height: 40),
                              
                              // Divider
                              Row(
                                children: [
                                  Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'or continue with',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.outline,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
                                ],
                              ),
                              const SizedBox(height: 32),
                              
                              // Social Logins
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: SvgPicture.string(_googleSvg, width: 20, height: 20),
                                      label: Text(
                                        'GOOGLE',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        side: BorderSide(
                                          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: SvgPicture.string(
                                        _appleSvg,
                                        width: 20,
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context).colorScheme.onSurface,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      label: Text(
                                        'APPLE',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        side: BorderSide(
                                          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 48),
                              
                              // Sign Up Link
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'New seeker? ',
                                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                    children: [
                                      TextSpan(
                                        text: 'Create an account',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 8,
            children: [
              _buildFooterLink('Privacy', context),
              _buildFooterLink('Terms', context),
              _buildFooterLink('Community Guidelines', context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text, BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
      ),
    );
  }
}

// Ensure the BoxConstraints is wrapped around the row if we want to limit size. 
// However, since it's inside a Container with maxConstraints, that's already handled.
