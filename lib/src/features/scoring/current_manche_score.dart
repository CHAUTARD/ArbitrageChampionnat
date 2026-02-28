// Path: lib/src/features/scoring/current_manche_score.dart
// Rôle: Gère l'affichage et la mise à jour du score pour la manche en cours.
// Ce widget affiche les scores actuels de chaque équipe pour la manche en cours et permet de les incrémenter ou de les décrémenter via des boutons.
// Il prend en compte l'inversion des côtés (`areSidesSwapped`) pour afficher les scores du bon côté de l'écran.
// Il interagit avec `GameState` (via Provider) pour lire et mettre à jour l'état du jeu.

import 'package:flutter/material.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
import 'package:provider/provider.dart';

class CurrentMancheScore extends StatelessWidget {
  final bool areSidesSwapped;
  const CurrentMancheScore({super.key, required this.areSidesSwapped});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    if (gameState.game.manches.isEmpty) {
      return const SizedBox.shrink(); // Don't show if no sets have been started
    }

    final mancheIndex = gameState.game.manches.length - 1;
    final currentManche = gameState.game.manches.last;

    final score1 = areSidesSwapped ? currentManche.scoreTeam2 : currentManche.scoreTeam1;
    final score2 = areSidesSwapped ? currentManche.scoreTeam1 : currentManche.scoreTeam2;
    final bool isCurrentMancheWon = _isMancheWon(currentManche.scoreTeam1, currentManche.scoreTeam2);

    final teamNumber1 = areSidesSwapped ? 2 : 1;
    final teamNumber2 = areSidesSwapped ? 1 : 2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildScoreControl(context, gameState, teamNumber1, score1, mancheIndex, isCurrentMancheWon),
          const Text('-', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          _buildScoreControl(context, gameState, teamNumber2, score2, mancheIndex, isCurrentMancheWon),
        ],
      ),
    );
  }

  Widget _buildScoreControl(
    BuildContext context,
    GameState gameState,
    int teamNumber,
    int score,
    int mancheIndex,
    bool isCurrentMancheWon,
  ) {
    final bool canEdit = !isCurrentMancheWon;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
                onPressed: canEdit
                    ? () {
                        if (score > 0) {
                          gameState.updateMancheScore(mancheIndex, teamNumber, score - 1);
                        }
                      }
                    : null,
                child: const Text(
                  '-',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              score.toString(),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 48,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
                onPressed: canEdit
                    ? () {
                        gameState.updateMancheScore(mancheIndex, teamNumber, score + 1);
                      }
                    : null,
                child: const Text(
                  '+',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _isMancheWon(int scoreTeam1, int scoreTeam2) {
    final bool team1WinsSet = scoreTeam1 > 10 && (scoreTeam1 - scoreTeam2) >= 2;
    final bool team2WinsSet = scoreTeam2 > 10 && (scoreTeam2 - scoreTeam1) >= 2;
    return team1WinsSet || team2WinsSet;
  }
}
