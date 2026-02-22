import 'package:flutter/material.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
import 'package:myapp/src/features/scoring/manche_indicator.dart';
import 'package:myapp/src/features/scoring/manche_table.dart';
import 'package:provider/provider.dart';

class ScoringScreen extends StatelessWidget {
  final Partie partie;

  const ScoringScreen({super.key, required this.partie});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: MancheIndicator(),
          ),
          const Expanded(
            child: MancheTable(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: gameState.previousManche,
                child: const Text('Manche précédente'),
              ),
              ElevatedButton(
                onPressed: gameState.nextManche,
                child: const Text('Manche suivante'),
              ),
            ],
          ),
        ],
      );
    });
  }
}
