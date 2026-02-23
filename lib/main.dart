import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/models/game_model.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/match_management/presentation/match_list_screen.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';
import 'package:myapp/src/features/players/player_service.dart';
import 'package:myapp/src/features/scoring/game_service.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await initializeDateFormatting('fr_FR', null);

  Hive
    ..registerAdapter(GameAdapter())
    ..registerAdapter(MancheAdapter())
    ..registerAdapter(MatchAdapter())
    ..registerAdapter(PartieAdapter())
    ..registerAdapter(PlayerAdapter());

  await Hive.openBox<Game>('games');
  await Hive.openBox<Manche>('manches');
  await Hive.openBox<Match>('matches');
  await Hive.openBox<Partie>('parties');

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
          create: (_) => GameService(Hive.box<Game>('games')),
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
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
        home: const MatchListScreen(),
      ),
    );
  }
}
