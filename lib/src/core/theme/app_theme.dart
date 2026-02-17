
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const Color primarySeedColor = Colors.deepPurple;

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.openSans(fontSize: 14),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        unselectedLabelColor: Colors.deepPurple.shade100,
        labelColor: Colors.white,
        labelStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.roboto(fontSize: 16),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 4.0, color: Colors.amberAccent),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const Color primarySeedColor = Colors.deepPurple;

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white70),
      bodyMedium: GoogleFonts.openSans(fontSize: 14, color: Colors.white60),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.deepPurple.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        unselectedLabelColor: Colors.grey.shade500,
        labelColor: Colors.deepPurple.shade200,
        labelStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.roboto(fontSize: 16),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 4.0, color: Colors.deepPurple.shade200),
        ),
      ),
    );
  }
}
