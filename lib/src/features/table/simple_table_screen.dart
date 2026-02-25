// Path: lib/src/features/table/simple_table_screen.dart
// Rôle: Écran d'affichage de la table de jeu pour un match en simple.
// Similaire à `DoubleTableScreen`, ce widget est actuellement un placeholder.
// Il est conçu pour afficher la disposition d'une table de ping-pong pour un match en simple.
// Il initialise également un `GameState` pour une future intégration avec la logique de jeu.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';

class SimpleTableScreen extends StatelessWidget {
  final Partie partie;
  final List<Player> team1;
  final List<Player> team2;

  const SimpleTableScreen({
    super.key,
    required this.partie,
    required this.team1,
    required this.team2,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(context.read()),
      child: Scaffold(
        appBar: AppBar(title: Text(partie.type)),
        body: Center(
          child: Text('Table for ${partie.type}'),
        ),
      ),
    );
  }
}
