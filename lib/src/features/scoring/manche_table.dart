// Path: lib/src/features/scoring/manche_table.dart

// Rôle: Affiche un tableau récapitulatif des scores de chaque manche pour les deux équipes.
// Ce widget construit un `DataTable` qui présente les noms des joueurs de chaque équipe et les scores obtenus dans chaque manche (jusqu'à 5).
// Il écoute les changements de `GameState` pour mettre à jour les scores en temps réel.
// Si une manche n'a pas encore été jouée, il affiche un tiret '-' comme espace réservé.

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
    final compactTextStyle = Theme.of(context).textTheme.bodySmall;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 10,
        horizontalMargin: 8,
        headingRowHeight: 34,
        dataRowMinHeight: 34,
        dataRowMaxHeight: 38,
        columns: [
          DataColumn(label: Text('Nom', style: compactTextStyle)),
          DataColumn(label: Text('M1', style: compactTextStyle)),
          DataColumn(label: Text('M2', style: compactTextStyle)),
          DataColumn(label: Text('M3', style: compactTextStyle)),
          DataColumn(label: Text('M4', style: compactTextStyle)),
          DataColumn(label: Text('M5', style: compactTextStyle)),
        ],
        rows: [
          _buildPlayerScoreRow(team1Name, gameState, 1),
          _buildPlayerScoreRow(team2Name, gameState, 2),
        ],
      ),
    );
  }

  DataRow _buildPlayerScoreRow(String playerName, GameState gameState, int teamNumber) {
    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: 120,
            child: Text(
              playerName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        ...List.generate(5, (mancheIndex) {
          if (mancheIndex < gameState.game.manches.length) {
            final score = (teamNumber == 1)
                ? gameState.game.manches[mancheIndex].scoreTeam1
                : gameState.game.manches[mancheIndex].scoreTeam2;
            return DataCell(Center(child: Text(score.toString())));
          } else {
            return const DataCell(Center(child: Text('-'))); // Placeholder for future sets
          }
        }),
      ],
    );
  }
}
