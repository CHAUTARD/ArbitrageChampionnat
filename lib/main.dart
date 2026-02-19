import 'package:flutter/material.dart';
import 'package:myapp/src/core/theme/app_theme.dart';
import 'package:myapp/src/features/core/data/database.dart';
import 'package:myapp/src/features/match_selection/match_selection_screen.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/partie_detail/manche_provider.dart'; // <-- AJOUT
import 'package:myapp/src/features/rencontre/rencontre_provider.dart';
import 'package:provider/provider.dart';

void main() {
  final AppDatabase db = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PartieProvider>(
          create: (_) => PartieProvider(db: db),
        ),
        ChangeNotifierProvider<RencontreProvider>(
          create: (context) => RencontreProvider(
            db: db,
            partieProvider: context.read<PartieProvider>(),
          ),
        ),
        ChangeNotifierProvider<MancheProvider>( // <-- AJOUT
          create: (_) => MancheProvider(database: db),
        ),
        ChangeNotifierProvider<AppThemeProvider>( // Thème provider
          create: (_) => AppThemeProvider(),
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
    final themeProvider = Provider.of<AppThemeProvider>(context);
    return MaterialApp(
      title: 'Feuille de Match Ping-Pong',
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const MatchSelectionScreen(),
    );
  }
}
