import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/src/features/scoring/game_service.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
import 'package:myapp/src/features/scoring/manche_table.dart';

class ScoringScreen extends StatelessWidget {
  final Partie partie;

  const ScoringScreen({super.key, required this.partie});

  @override
  Widget build(BuildContext context) {
    final gameService = Provider.of<GameService>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => GameState(gameService: gameService, partie: partie),
      child: Scaffold(
        appBar: AppBar(title: const Text('Feuille de Match')),
        body: Consumer<GameState>(
          builder: (context, gameState, child) {
            return Column(
              children: [
                // Manches navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(gameState.game.manches.length, (index) {
                    return ElevatedButton(
                      onPressed: () => gameState.setManche(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gameState.currentMancheIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                      ),
                      child: Text('M${index + 1}'),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                // Current manche table
                const MancheTable(),
              ],
            );
          },
        ),
      ),
    );
  }
}
