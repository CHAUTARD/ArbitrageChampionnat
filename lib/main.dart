// Path: lib/main.dart
// Rôle: Point d'entrée principal de l'application Flutter.
// Ce fichier initialise l'application, configure les services (comme Hive pour la base de données locale
// et les providers pour la gestion d'état), et définit le thème global ainsi que la route initiale.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/models/game_model.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';
import 'package:myapp/src/features/match_management/presentation/match_list_screen.dart';
import 'package:myapp/src/features/players/player_service.dart';
import 'package:myapp/src/features/scoring/game_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() async {
  await Hive.initFlutter();

  // Registering adapters
  Hive.registerAdapter(MatchAdapter());
  Hive.registerAdapter(PartieAdapter());
  Hive.registerAdapter(PlayerAdapter());
  Hive.registerAdapter(MancheAdapter());
  Hive.registerAdapter(GameAdapter());

  // Opening boxes
  await Hive.openBox<Match>('matches');
  await Hive.openBox<Player>('players');
  await Hive.openBox<Game>('games');

  final playerService = PlayerService();
  await playerService.initializeDatabase();

  runApp(MyApp(playerService: playerService));
}

class MyApp extends StatelessWidget {
  final PlayerService playerService;
  const MyApp({super.key, required this.playerService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MatchService>(
          create: (_) => MatchService(Hive.box<Match>('matches')),
        ),
        Provider<PlayerService>.value(value: playerService),
        Provider<GameService>(
          create: (_) => GameService(
            gameBox: Hive.box<Game>('games'),
            uuid: const Uuid(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Feuilles de rencontre',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr', 'FR')],
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const MatchListScreen(),
      ),
    );
  }
}
