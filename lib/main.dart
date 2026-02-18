
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/core/theme/app_theme.dart';
import 'package:myapp/src/core/theme/theme_provider.dart';
import 'package:myapp/src/features/match_selection/match_selection_screen.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // GoogleFonts.config.allowRuntimeFetching = false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PartieProvider()),
        ChangeNotifierProxyProvider<PartieProvider, MatchProvider>(
          create: (context) => MatchProvider(context.read<PartieProvider>()),
          update: (context, partieProvider, matchProvider) =>
              MatchProvider(partieProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Pétanque Scoreboard',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const MatchSelectionScreen(),
        );
      },
    );
  }
}
