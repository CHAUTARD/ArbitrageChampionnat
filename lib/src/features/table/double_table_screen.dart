import 'package:flutter/material.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/scoring_screen.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
import 'package:provider/provider.dart';

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
      create: (_) => GameState(
        partie: partie,
        team1Players: team1Players,
        team2Players: team2Players,
      ),
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Partie de Double'),
            bottom: const TabBar(tabs: [Tab(text: 'Tableau des scores')]),
          ),
          body: TabBarView(
            children: [ScoringScreen(partie: partie)],
          ),
        ),
      ),
    );
  }
}
