import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
import 'package:myapp/src/features/scoring/scoring_screen.dart';

class SimpleTableScreen extends StatelessWidget {
  final Partie partie;
  final Player joueurUn;
  final Player joueurDeux;
  final Player? arbitre;

  const SimpleTableScreen({
    super.key,
    required this.partie,
    required this.joueurUn,
    required this.joueurDeux,
    this.arbitre,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(partie),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${joueurUn.name} vs ${joueurDeux.name}'),
          actions: [
            if (arbitre != null)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(child: Text('Arbitre: ${arbitre!.name}')),
              ),
          ],
        ),
        body: ScoringScreen(partie: partie),
      ),
    );
  }
}
