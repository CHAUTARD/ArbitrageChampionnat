// lib/src/core/theme/app_theme.dart
// Définit les thèmes visuels de l'application (clair et sombre).

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final Color _primarySeedColor = Colors.blue.shade800;

  static final TextTheme _appTextTheme = TextTheme(
    displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.oswald(fontSize: 45, fontWeight: FontWeight.bold),
    displaySmall: GoogleFonts.oswald(fontSize: 36, fontWeight: FontWeight.bold),
    headlineLarge: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold),
    headlineSmall: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w500),
    titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: GoogleFonts.openSans(fontSize: 16),
    bodyMedium: GoogleFonts.openSans(fontSize: 14),
    bodySmall: GoogleFonts.openSans(fontSize: 12),
    labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
    labelMedium: GoogleFonts.roboto(fontSize: 12),
    labelSmall: GoogleFonts.roboto(fontSize: 11),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primarySeedColor,
      brightness: Brightness.light,
    ),
    textTheme: _appTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: _primarySeedColor,
      foregroundColor: Colors.white,
      titleTextStyle: _appTextTheme.titleLarge?.copyWith(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _primarySeedColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: _appTextTheme.labelLarge,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primarySeedColor,
      brightness: Brightness.dark,
    ),
    textTheme: _appTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      titleTextStyle: _appTextTheme.titleLarge?.copyWith(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: _primarySeedColor.withAlpha(128),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: _appTextTheme.labelLarge?.copyWith(color: Colors.black),
      ),
    ),
  );
}
