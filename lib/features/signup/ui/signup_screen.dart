import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user_role.dart';
import '../../../core/session/user_session.dart';
import '../../../core/theme/app_colors.dart';
import '../provider/signup_provider.dart';

/// Account creation screen. The key new requirement: the seeker picks whether
/// they are joining as a **Temple** (institution) or a **Devotee** (explorer),
/// which the rest of the app uses to gate its UI.
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: const _SignupContent(),
    );
  }
}

class _SignupContent extends StatefulWidget {
  const _SignupContent();

  @override
  State<_SignupContent> createState() => _SignupContentState();
}

class _SignupContentState extends State<_SignupContent> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount(SignupProvider provider) async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final session = context.read<UserSession>();
    final ok = await session.signUp(
      email: email,
      password: password,
      displayName: name,
      role: provider.role,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (session.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(session.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 800;
    final isSmall = size.width < 360;
    final horizontalPad = isWide ? 48.0 : (isSmall ? 16.0 : 24.0);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.primary,
        title: Text(
          'Create account',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Consumer<SignupProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPad,
                8,
                horizontalPad,
                24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Join Darshana',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'First, tell us how you want to walk this path.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Role selection
                      _RoleSelector(provider: provider),
                      const SizedBox(height: 32),

                      // Name
                      _FieldLabel('FULL NAME'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: _fieldDecoration(
                          context,
                          hint: provider.role == UserRole.temple
                              ? 'e.g. Sri Ananda Temple'
                              : 'Your name',
                          icon: Icons.person_outline,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _FieldLabel('EMAIL ADDRESS'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: _fieldDecoration(
                          context,
                          hint: 'email@example.com',
                          icon: Icons.mail_outline,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _FieldLabel('PASSWORD'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordController,
                        obscureText: !provider.passwordVisible,
                        decoration: _fieldDecoration(
                          context,
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(
                              provider.passwordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: provider.togglePasswordVisibility,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Submit
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.ctaGradientStart,
                              AppColors.ctaGradientEnd,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary
                                  .withOpacity(0.25),
                              offset: const Offset(0, 8),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Consumer<UserSession>(
                          builder: (context, session, _) {
                            return ElevatedButton(
                              onPressed: session.isBusy ? null : () => _createAccount(provider),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: session.isBusy
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(
                                      'CREATE ${provider.role.title.toUpperCase()} ACCOUNT',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    final theme = Theme.of(context);
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  final SignupProvider provider;
  const _RoleSelector({required this.provider});

  @override
  Widget build(BuildContext context) {
    // Two cards side-by-side on roomy widths, stacked on narrow phones.
    final isNarrow = MediaQuery.of(context).size.width < 420;
    final cards = [
      _RoleCard(
        role: UserRole.devotee,
        selected: provider.role == UserRole.devotee,
        onTap: () => provider.selectRole(UserRole.devotee),
      ),
      _RoleCard(
        role: UserRole.temple,
        selected: provider.role == UserRole.temple,
        onTap: () => provider.selectRole(UserRole.temple),
      ),
    ];

    if (isNarrow) {
      return Column(
        children: [
          cards[0],
          const SizedBox(height: 12),
          cards[1],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: 12),
        Expanded(child: cards[1]),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withOpacity(0.10)
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withOpacity(0.4),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    role.icon,
                    color: selected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                if (selected)
                  Icon(Icons.check_circle,
                      color: theme.colorScheme.primary, size: 22),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              role.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              role.tagline,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
