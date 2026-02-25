import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';

class MancheTable extends StatelessWidget {
  final List<Player> team1Players;
  final List<Player> team2Players;

  const MancheTable(
      {super.key, required this.team1Players, required this.team2Players});

  String getPlayerNames(List<Player> players) {
    if (players.isEmpty || players.any((p) => p.id.isEmpty)) {
      return 'Composition incomplète';
    }
    if (players.length == 1) return players.first.name;
    return players.map((p) => p.name).join(' & ');
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildScoreColumn(
                    context,
                    getPlayerNames(team1Players),
                    currentManche.scoreTeam1,
                    () => gameState.incrementScore(0, team1Players.first.id),
                    () => gameState.decrementScore(0, team1Players.first.id)),
              ),
              Expanded(
                child: _buildScoreColumn(
                    context,
                    getPlayerNames(team2Players),
                    currentManche.scoreTeam2,
                    () => gameState.incrementScore(1, team2Players.first.id),
                    () => gameState.decrementScore(1, team2Players.first.id)),
              ),
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
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        Text(score.toString(),
            style: Theme.of(context).textTheme.headlineMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
