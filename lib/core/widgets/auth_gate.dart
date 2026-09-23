import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../session/user_session.dart';
import 'main_shell.dart';
import '../../features/welcome/ui/welcome_screen.dart';

/// Root widget that shows [WelcomeScreen] or [MainShell] depending on
/// [UserSession]'s live Firebase Auth state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<UserSession>();
    switch (session.status) {
      case AuthStatus.loading:
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: const Center(child: CircularProgressIndicator()),
        );
      case AuthStatus.signedIn:
        return const MainShell();
      case AuthStatus.signedOut:
        return const WelcomeScreen();
    }
  }
}
