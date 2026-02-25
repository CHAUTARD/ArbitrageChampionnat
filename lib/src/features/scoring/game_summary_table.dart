import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';

class GameSummaryTable extends StatelessWidget {
  final List<Player> team1Players;
  final List<Player> team2Players;

  const GameSummaryTable({
    super.key,
    required this.team1Players,
    required this.team2Players,
  });

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

    return Column(
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Joueur')),
            DataColumn(label: Text('M1')),
            DataColumn(label: Text('M2')),
            DataColumn(label: Text('M3')),
            DataColumn(label: Text('M4')),
            DataColumn(label: Text('M5')),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(Text(getPlayerNames(team1Players))),
                for (int i = 0; i < 5; i++)
                  DataCell(Text(i < gameState.game.manches.length
                      ? gameState.game.manches[i].scoreTeam1.toString()
                      : '-')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text(getPlayerNames(team2Players))),
                for (int i = 0; i < 5; i++)
                  DataCell(Text(i < gameState.game.manches.length
                      ? gameState.game.manches[i].scoreTeam2.toString()
                      : '-')),
              ],
            ),
          ],
        ),
        if (gameState.isGameFinished)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${gameState.team1ManchesWon >= 3 ? getPlayerNames(team1Players) : getPlayerNames(team2Players)} a gagné la partie !',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.green),
            ),
          ),
      ],
    );
  }
}
