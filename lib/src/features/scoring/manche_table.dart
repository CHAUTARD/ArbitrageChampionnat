import 'package:flutter/material.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
import 'package:provider/provider.dart';

class MancheTable extends StatelessWidget {
  const MancheTable({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Manche')),
          DataColumn(label: Text('Équipe 1')),
          DataColumn(label: Text('Équipe 2')),
          DataColumn(label: Text('Actions')),
        ],
        rows: List<DataRow>.generate(
          gameState.game.manches.length,
          (index) => DataRow(
            cells: [
              DataCell(Text('Manche ${index + 1}')),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        final currentScore = gameState.game.manches[index].scoreTeam1;
                        if (currentScore > 0) {
                          gameState.updateMancheScore(index, 1, currentScore - 1);
                        }
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: gameState.game.manches[index].scoreTeam1.toString(),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          final score = int.tryParse(value) ?? 0;
                          gameState.updateMancheScore(index, 1, score);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final currentScore = gameState.game.manches[index].scoreTeam1;
                        gameState.updateMancheScore(index, 1, currentScore + 1);
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        final currentScore = gameState.game.manches[index].scoreTeam2;
                        if (currentScore > 0) {
                          gameState.updateMancheScore(index, 2, currentScore - 1);
                        }
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: gameState.game.manches[index].scoreTeam2.toString(),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          final score = int.tryParse(value) ?? 0;
                          gameState.updateMancheScore(index, 2, score);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final currentScore = gameState.game.manches[index].scoreTeam2;
                        gameState.updateMancheScore(index, 2, currentScore + 1);
                      },
                    ),
                  ],
                ),
              ),
              DataCell(IconButton(
                icon: Icon(Icons.delete,
                    color: Theme.of(context).colorScheme.error),
                onPressed: () => gameState.removeManche(index),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
