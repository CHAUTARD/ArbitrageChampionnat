import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/scoring/game_state.dart';

class MancheIndicator extends StatelessWidget {
  const MancheIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(gameState.manches.length, (index) {
        return GestureDetector(
          onTap: () => gameState.setManche(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: gameState.currentMancheIndex == index
                  ? Colors.blue
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Manche ${index + 1}',
              style: TextStyle(
                color: gameState.currentMancheIndex == index
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}
