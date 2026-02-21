// lib/src/core/theme/theme_provider.dart
//
// Fournit un [ChangeNotifierProvider] pour gérer le thème de l'application.
// Le [ThemeNotifier] permet de basculer entre les modes clair, sombre et système.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = ChangeNotifierProvider((ref) => ThemeNotifier());

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
