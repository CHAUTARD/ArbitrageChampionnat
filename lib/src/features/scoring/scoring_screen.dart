import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';

class ScoringScreen extends ConsumerWidget {
  final Partie partie;

  const ScoringScreen({super.key, required this.partie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchState = ref.watch(matchProvider);
    final matchNotifier = ref.read(matchProvider.notifier);

    if (matchState.currentPartie == null) {
      matchNotifier.startMatch(partie);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Partie #${partie.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => matchNotifier.swapSides(),
          ),
        ],
      ),
      body: Column(
        children: [
          Text(
              'Manche ${matchState.manche} - ${matchState.manchesGagneesTeam1} : ${matchState.manchesGagneesTeam2}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(partie.team1Players.map((p) => p.name).join(' & ')),
                  Text('${matchState.scoreTeam1}'),
                  ElevatedButton(
                    onPressed: () => matchNotifier.incrementScore(1),
                    child: const Text('+'),
                  ),
                  ElevatedButton(
                    onPressed: () => matchNotifier.decrementScore(1),
                    child: const Text('-'),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(partie.team2Players.map((p) => p.name).join(' & ')),
                  Text('${matchState.scoreTeam2}'),
                  ElevatedButton(
                    onPressed: () => matchNotifier.incrementScore(2),
                    child: const Text('+'),
                  ),
                  ElevatedButton(
                    onPressed: () => matchNotifier.decrementScore(2),
                    child: const Text('-'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
