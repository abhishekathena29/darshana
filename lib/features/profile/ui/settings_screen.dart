import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/session/user_session.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<UserSession>();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'ACCOUNT',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(session.displayName),
                  subtitle: Text(session.email ?? 'No email on file'),
                ),
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('Role'),
                  subtitle: Text('${session.role.title} account'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'SECURITY',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.lock_reset_outlined),
              title: const Text('Send password reset email'),
              subtitle: Text(session.email ?? ''),
              onTap: () async {
                final email = session.email;
                final messenger = ScaffoldMessenger.of(context);
                if (email == null) return;
                final ok = await session.sendPasswordReset(email);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      ok ? 'Password reset email sent to $email.' : (session.errorMessage ?? 'Could not send reset email.'),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text('Sign out', style: TextStyle(color: theme.colorScheme.error)),
              onTap: () {
                // Settings is a pushed route; pop back to the root first so
                // AuthGate's post-sign-out screen (which replaces the root
                // content, not the navigation stack) is what the user sees.
                Navigator.of(context).popUntil((route) => route.isFirst);
                context.read<UserSession>().signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
