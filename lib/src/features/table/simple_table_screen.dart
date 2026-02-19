// features/table/simple_table_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/scoring/scoring_screen.dart';
import 'package:myapp/src/features/table/player_edit_screen.dart';

class SimpleTableScreen extends StatelessWidget {
  final Partie partie;

  const SimpleTableScreen({super.key, required this.partie});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              '${partie.team1Players.first.name} vs ${partie.team2Players.first.name}'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tableau des scores'),
              Tab(text: 'Édition des joueurs'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ScoringScreen(partie: partie), // CORRECTION
            PlayerEditScreen(partie: partie),
          ],
        ),
      ),
    );
  }
}
