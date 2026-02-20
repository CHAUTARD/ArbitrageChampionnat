import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:provider/provider.dart';

class ScoringScreen extends StatelessWidget {
  final Partie partie;

  const ScoringScreen({super.key, required this.partie});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MatchProvider(5, 11, partieProvider: Provider.of<PartieProvider>(context, listen: false)),
      child: Consumer<MatchProvider>(
        builder: (context, matchProvider, child) {
          // Start the match when the provider is first created
          if (matchProvider.currentPartie == null) {
            matchProvider.startMatch(partie);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Partie #${partie.id}'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: () => matchProvider.swapSides(),
                ),
              ],
            ),
            body: Column(
              children: [
                Text(
                    'Manche ${matchProvider.manche} - ${matchProvider.manchesGagneesTeam1} : ${matchProvider.manchesGagneesTeam2}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(partie.team1Players.map((p) => p.name).join(' & ')),
                        Text('${matchProvider.scoreTeam1}'),
                        ElevatedButton(
                          onPressed: () => matchProvider.incrementScore(1),
                          child: const Text('+'),
                        ),
                        ElevatedButton(
                          onPressed: () => matchProvider.decrementScore(1),
                          child: const Text('-'),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(partie.team2Players.map((p) => p.name).join(' & ')),
                        Text('${matchProvider.scoreTeam2}'),
                        ElevatedButton(
                          onPressed: () => matchProvider.incrementScore(2),
                          child: const Text('+'),
                        ),
                        ElevatedButton(
                          onPressed: () => matchProvider.decrementScore(2),
                          child: const Text('-'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
