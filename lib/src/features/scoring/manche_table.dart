import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';

class MancheTable extends StatelessWidget {
  final List<Player> team1Players;
  final List<Player> team2Players;

  const MancheTable({
    super.key,
    required this.team1Players,
    required this.team2Players,
  });

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final team1Name = team1Players.map((p) => p.name).join(' & ');
    final team2Name = team2Players.map((p) => p.name).join(' & ');

    return DataTable(
      columns: const [
        DataColumn(label: Text('Nom')),
        DataColumn(label: Text('M1')),
        DataColumn(label: Text('M2')),
        DataColumn(label: Text('M3')),
        DataColumn(label: Text('M4')),
        DataColumn(label: Text('M5')),
      ],
      rows: [
        _buildPlayerScoreRow(team1Name, gameState, 1),
        _buildPlayerScoreRow(team2Name, gameState, 2),
      ],
    );
  }

  DataRow _buildPlayerScoreRow(String playerName, GameState gameState, int teamNumber) {
    return DataRow(
      cells: [
        DataCell(Text(playerName)),
        ...List.generate(5, (mancheIndex) {
          if (mancheIndex < gameState.game.manches.length) {
            final score = (teamNumber == 1)
                ? gameState.game.manches[mancheIndex].scoreTeam1
                : gameState.game.manches[mancheIndex].scoreTeam2;
            return DataCell(Text(score.toString()));
          } else {
            return const DataCell(Text('-')); // Placeholder for future sets
          }
        }),
      ],
    );
  }
}
