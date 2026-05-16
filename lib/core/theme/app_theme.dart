import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryLight,
        brightness: Brightness.light,
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        tertiary: AppColors.tertiaryLight,
        background: AppColors.backgroundLight,
        surface: AppColors.surfaceLight,
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryDark,
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        tertiary: AppColors.tertiaryDark,
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
      ),
      textTheme: _buildTextTheme(ThemeData.dark().textTheme),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: GoogleFonts.notoSerif(textStyle: base.displayLarge),
      displayMedium: GoogleFonts.notoSerif(textStyle: base.displayMedium),
      displaySmall: GoogleFonts.notoSerif(textStyle: base.displaySmall),
      headlineLarge: GoogleFonts.notoSerif(textStyle: base.headlineLarge),
      headlineMedium: GoogleFonts.notoSerif(textStyle: base.headlineMedium),
      headlineSmall: GoogleFonts.notoSerif(textStyle: base.headlineSmall),
      titleLarge: GoogleFonts.manrope(textStyle: base.titleLarge),
      titleMedium: GoogleFonts.manrope(textStyle: base.titleMedium),
      titleSmall: GoogleFonts.manrope(textStyle: base.titleSmall),
      bodyLarge: GoogleFonts.manrope(textStyle: base.bodyLarge),
      bodyMedium: GoogleFonts.manrope(textStyle: base.bodyMedium),
      bodySmall: GoogleFonts.manrope(textStyle: base.bodySmall),
      labelLarge: GoogleFonts.manrope(textStyle: base.labelLarge),
      labelMedium: GoogleFonts.manrope(textStyle: base.labelMedium),
      labelSmall: GoogleFonts.manrope(textStyle: base.labelSmall),
    );
  }
}
