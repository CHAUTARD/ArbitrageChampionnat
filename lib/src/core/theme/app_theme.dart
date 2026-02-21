// lib/src/core/theme/app_theme.dart
//
// Définit les thèmes clair et sombre de l'application.
// Ce fichier centralise la configuration de l'apparence de l'interface utilisateur,
// y compris les couleurs, la typographie et les styles des composants.

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const Color primarySeedColor = Colors.deepPurple;

    final TextTheme appTextTheme = const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Oswald', fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontFamily: 'Roboto', fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontFamily: 'Oswald', fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        unselectedLabelColor: Colors.deepPurple,
        labelColor: Colors.white,
        labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 4.0, color: Colors.amberAccent),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const Color primarySeedColor = Colors.deepPurple;

    final TextTheme appTextTheme = const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Oswald', fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: TextStyle(fontFamily: 'Roboto', fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white70),
      bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.white60),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
      ),
      textTheme: appTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontFamily: 'Oswald', fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.deepPurple.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        unselectedLabelColor: Colors.grey.shade500,
        labelColor: Colors.deepPurple.shade200,
        labelStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 4.0, color: Colors.deepPurple.shade200),
        ),
      ),
    );
  }
}
