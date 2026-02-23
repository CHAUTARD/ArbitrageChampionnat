import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';

class MancheTable extends StatelessWidget {
  const MancheTable({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final Manche currentManche = gameState.currentManche;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildScoreColumn(context, 'Équipe 1', currentManche.scoreTeam1,
                  () => gameState.incrementScore(1), () => gameState.decrementScore(1)),
              _buildScoreColumn(context, 'Équipe 2', currentManche.scoreTeam2,
                  () => gameState.incrementScore(2), () => gameState.decrementScore(2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(BuildContext context, String title, int score,
      VoidCallback onIncrement, VoidCallback onDecrement) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 10),
        Text(score.toString(), style: Theme.of(context).textTheme.headlineMedium),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: onDecrement,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}
