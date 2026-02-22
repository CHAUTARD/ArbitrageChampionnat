import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/scoring/game_state.dart';

class MancheTable extends StatelessWidget {
  const MancheTable({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final partie = gameState.partie;
    final scores = gameState.scores[gameState.currentManche];
    final isDouble = partie.type == 'Double';

    final player1 = isDouble ? partie.equipeUnId : partie.joueurUnId;
    final player2 = isDouble ? partie.equipeDeuxId : partie.joueurDeuxId;

    return Column(
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Joueur')),
            DataColumn(label: Text('Score')),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(Text(player1)),
                DataCell(Text(scores[0].toString())),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text(player2)),
                DataCell(Text(scores[1].toString())),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => gameState.incrementScore(0),
              child: Text('+1 $player1'),
            ),
            ElevatedButton(
              onPressed: () => gameState.incrementScore(1),
              child: Text('+1 $player2'),
            ),
          ],
        ),
      ],
    );
  }
}
