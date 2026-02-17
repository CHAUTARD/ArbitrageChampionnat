import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'match_provider.dart';

class MancheTable extends StatelessWidget {
  const MancheTable({super.key});

  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);
    final games = matchProvider.games;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DataTable(
        columnSpacing: 12.0,
        horizontalMargin: 8.0,
        headingRowHeight: 40.0,
        dataRowMinHeight: 40.0,
        dataRowMaxHeight: 48.0,
        columns: const [
          DataColumn(label: Text('Joueurs/Manches')),
          DataColumn(label: Text('M1')),
          DataColumn(label: Text('M2')),
          DataColumn(label: Text('M3')),
          DataColumn(label: Text('M4')),
          DataColumn(label: Text('M5')),
        ],
        rows: [
          _buildPlayerScoreRow(
            context,
            matchProvider.player1Name,
            games,
            (game) => game.score1,
            (game) => game.score1 > game.score2,
          ),
          _buildPlayerScoreRow(
            context,
            matchProvider.player2Name,
            games,
            (game) => game.score2,
            (game) => game.score2 > game.score1,
          ),
        ],
      ),
    );
  }

  DataRow _buildPlayerScoreRow(
    BuildContext context,
    String playerName,
    List<Game> games,
    int Function(Game) getScore,
    bool Function(Game) isWinner,
  ) {
    // Determine the width for the first column based on screen size
    final double playerColumnWidth = MediaQuery.of(context).size.width * 0.25;

    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: playerColumnWidth,
            child: Text(
              playerName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, // Use ellipsis for long names
            ),
          ),
        ),
        ...List.generate(5, (index) {
          if (index < games.length) {
            final game = games[index];
            final score = getScore(game);
            final winner = isWinner(game);
            return DataCell(
              Center( // Center the content of the cell
                child: winner
                    ? Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                        child: Text(score.toString()),
                      )
                    : Text(score.toString()),
              ),
            );
          } else {
            return const DataCell(Center(child: Text('-'))); // Center the placeholder
          }
        }),
      ],
    );
  }
}
