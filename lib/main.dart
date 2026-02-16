
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/core/theme/app_theme.dart';
import 'package:myapp/src/core/theme/theme_provider.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/match_selection/partie_selection_screen.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:myapp/src/features/match_selection/team_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => MatchProvider()),
        
        ChangeNotifierProvider(create: (context) => TeamProvider()),

        ChangeNotifierProxyProvider<TeamProvider, PartieProvider>(
          create: (context) => PartieProvider(context.read<TeamProvider>()),
          update: (context, teamProvider, previousPartieProvider) {
            // La clé est de TOUJOURS retourner une NOUVELLE instance de PartieProvider.
            // Le `update` est appelé chaque fois que TeamProvider notifie un changement.
            // En créant une nouvelle instance, on s'assure que la logique du constructeur
            // de PartieProvider est correctement exécutée avec le dernier état de TeamProvider.
            // L'ancienne instance (`previousPartieProvider`) est automatiquement gérée et `disposed` par le ProxyProvider.
            return PartieProvider(teamProvider);
          },
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
          home: const PartieSelectionScreen(),
        );
      },
    );
  }
}
