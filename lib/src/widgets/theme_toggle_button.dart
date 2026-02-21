import 'package:flutter/material.dart';
import 'package:myapp/src/core/theme/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  final ThemeNotifier themeProvider;

  const ThemeToggleButton({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        themeProvider.themeMode == ThemeMode.dark
            ? Icons.light_mode
            : Icons.dark_mode,
      ),
      onPressed: () {
        final isDark = themeProvider.themeMode == ThemeMode.light;
        themeProvider.toggleTheme(isDark);
      },
      tooltip: 'Toggle Theme',
    );
  }
}
