import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_service.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
import 'package:myapp/src/features/scoring/scoring_screen.dart';

class DoubleTableScreen extends StatelessWidget {
  final Partie partie;
  final List<Player> team1Players;
  final List<Player> team2Players;

  const DoubleTableScreen({
    super.key,
    required this.partie,
    required this.team1Players,
    required this.team2Players,
  });

  @override
  Widget build(BuildContext context) {
    final gameService = Provider.of<GameService>(context, listen: false);

    return FutureBuilder<GameState>(
      future: GameState.create(gameService: gameService, partie: partie),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Erreur: ${snapshot.error}')),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("Impossible de charger l'état du jeu.")),
          );
        }

        final gameState = snapshot.data!;

        return ChangeNotifierProvider.value(
          value: gameState,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '${team1Players.map((p) => p.name).join(' & ')} vs ${team2Players.map((p) => p.name).join(' & ')}',
              ),
            ),
            body: ScoringScreen(
              partie: partie,
              team1Players: team1Players,
              team2Players: team2Players,
            ),
          ),
        );
      },
    );
  }
}
