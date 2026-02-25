import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/scoring/game_state.dart';

class MancheIndicator extends StatelessWidget {
  const MancheIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: index < gameState.game.manches.length ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
