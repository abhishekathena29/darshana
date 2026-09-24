import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/temple_repository.dart';
import '../../../core/session/user_session.dart';
import '../../temple_profile/ui/temple_profile_screen.dart';
import '../../temple_profile/ui/edit_temple_screen.dart';
import '../../saved_temples/ui/saved_temples_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

/// Role-aware profile / account screen hosted inside the main shell.
///
/// Renders below the morphing top nav (see [topInset]). For a temple account
/// it surfaces a "Manage temple" action; for a devotee it shows their seeker
/// stats and saved items.
class ProfileScreen extends StatelessWidget {
  /// Space reserved at the top for the floating glass navigation.
  final double topInset;

  const ProfileScreen({super.key, this.topInset = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = context.watch<UserSession>();
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 800;
    final isSmall = size.width < 360;
    final horizontalPad = isWide ? 48.0 : (isSmall ? 16.0 : 24.0);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: topInset + 16,
        left: horizontalPad,
        right: horizontalPad,
        bottom: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProfileHeader(session: session, theme: theme),
              const SizedBox(height: 24),
              if (session.isTemple)
                _ActionCard(
                  icon: Icons.temple_hindu,
                  title: 'Manage temple',
                  subtitle: 'Edit your sanctuary profile, photos & timings.',
                  onTap: () => _openManageTemple(context, session),
                ),
              if (!session.isTemple)
                _ActionCard(
                  icon: Icons.bookmark_outline,
                  title: 'Saved temples',
                  subtitle: 'Sacred spaces you want to visit.',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SavedTemplesScreen()),
                  ),
                ),
              _ActionCard(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Festival reminders and ritual timings.',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                ),
              ),
              _ActionCard(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Account, language and appearance.',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.read<UserSession>().signOut(),
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(
                    color: theme.colorScheme.error.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openManageTemple(BuildContext context, UserSession session) async {
    final uid = session.uid;
    if (uid == null) return;
    final owned = await TempleRepository().watchOwnedBy(uid).first;
    if (!context.mounted) return;
    if (owned.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TempleProfileScreen(templeId: owned.first.id)),
      );
      return;
    }
    final newId = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const EditTempleScreen()),
    );
    if (newId != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TempleProfileScreen(templeId: newId)),
      );
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserSession session;
  final ThemeData theme;

  const _ProfileHeader({required this.session, required this.theme});

  @override
  Widget build(BuildContext context) {
    final role = session.role;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.12),
            theme.colorScheme.tertiary.withOpacity(0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: theme.colorScheme.primary,
            child: Icon(role.icon, color: theme.colorScheme.onPrimary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${role.title} account',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
