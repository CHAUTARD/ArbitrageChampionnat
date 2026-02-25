// Path: lib/src/features/table/double_table_screen.dart
// Rôle: Écran d'affichage de la table de jeu pour un match en double.
// Pour l'instant, ce widget est un placeholder. Il est destiné à afficher la disposition spécifique d'une table de ping-pong pour un match en double, potentiellement avec le positionnement des joueurs, les zones de service, etc.
// Il initialise un `GameState` pour pouvoir, à terme, interagir avec l'état de la partie.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';

class DoubleTableScreen extends StatelessWidget {
  final Partie partie;
  final List<Player> team1;
  final List<Player> team2;

  const DoubleTableScreen({
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
