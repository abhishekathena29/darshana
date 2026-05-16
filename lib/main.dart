import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/welcome/provider/welcome_provider.dart';
import 'features/welcome/ui/welcome_screen.dart';

void main() {
  runApp(const SacredHeritageApp());
}

class SacredHeritageApp extends StatelessWidget {
  const SacredHeritageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WelcomeProvider()),
      ],
      child: MaterialApp(
        title: 'Sudarshan',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const WelcomeScreen(),
      ),
    );
  }
}
