import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/session/user_session.dart';
import '../provider/login_provider.dart';
import '../../signup/ui/signup_screen.dart';

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

class _LoginScreenContent extends StatefulWidget {
  const _LoginScreenContent();

  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password.')),
      );
      return;
    }
    final session = context.read<UserSession>();
    final ok = await session.signIn(email: email, password: password);
    if (!context.mounted) return;
    if (ok) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (session.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(session.errorMessage!)),
      );
    }
  }

  Future<void> _forgotPassword(BuildContext context) async {
    final controller = TextEditingController(text: _emailController.text.trim());
    final email = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset your password'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Email address',
            hintText: 'email@temple.org',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('Send link'),
          ),
        ],
      ),
    );
    if (email == null || email.isEmpty || !context.mounted) return;

    final session = context.read<UserSession>();
    final ok = await session.sendPasswordReset(email);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Password reset link sent to $email.'
              : session.errorMessage ?? 'Could not send the reset link.',
        ),
      ),
    );
  }

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
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
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
                                      onPressed: () => _forgotPassword(context),
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
                                    controller: _passwordController,
                                    obscureText: !provider.isPasswordVisible,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) => _signIn(context),
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
                              Consumer<UserSession>(
                                builder: (context, session, child) {
                                  return Container(
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
                                      onPressed: session.isBusy ? null : () => _signIn(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: session.isBusy
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                            )
                                          : Row(
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
                                  );
                                },
                              ),

                              const SizedBox(height: 48),

                              // Sign Up Link
                              Center(
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignupScreen(),
                                    ),
                                  ),
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
