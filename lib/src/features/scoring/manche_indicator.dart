// Path: lib/src/features/scoring/manche_indicator.dart
// Rôle: Affiche un indicateur visuel du nombre de manches (sets) jouées.
// Ce widget affiche une rangée de cercles, où chaque cercle représente une manche.
// Les manches déjà jouées ou en cours sont colorées (par exemple, en vert), tandis que les manches futures sont grisées.
// Il s'abonne à `GameState` pour savoir combien de manches ont été commencées et met à jour son affichage en conséquence.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/scoring/game_state.dart';

class MancheIndicator extends StatelessWidget {
  const MancheIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: index < gameState.game.manches.length ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
