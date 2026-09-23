import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/session/user_session.dart';
import 'core/widgets/auth_gate.dart';
import 'features/welcome/provider/welcome_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SacredHeritageApp());
}

class SacredHeritageApp extends StatelessWidget {
  const SacredHeritageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSession()),
        ChangeNotifierProvider(create: (_) => WelcomeProvider()),
      ],
      child: MaterialApp(
        title: 'Darshana',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthGate(),
      ),
    );
  }
}
