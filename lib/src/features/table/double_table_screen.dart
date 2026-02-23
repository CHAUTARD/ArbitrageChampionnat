import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
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
    return ChangeNotifierProvider(
      create: (context) => GameState(partie),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${team1Players.map((p) => p.name).join(' & ')} vs ${team2Players.map((p) => p.name).join(' & ')}'),
        ),
        body: ScoringScreen(partie: partie),
      ),
    );
  }
}
