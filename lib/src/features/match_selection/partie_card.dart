// features/match_selection/partie_card.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:myapp/src/features/table/double_table_screen.dart';
import 'package:myapp/src/features/table/table_screen.dart';
import 'package:provider/provider.dart';

class PartieCard extends StatelessWidget {
  final Partie partie;
  final bool isPlayed;

  const PartieCard({super.key, required this.partie, this.isPlayed = false});

  void _navigateToTableScreen(BuildContext context) {
    if (isPlayed) {
      // The card is disabled, so this should not be called.
    } else {
      final matchProvider = Provider.of<MatchProvider>(context, listen: false);
      matchProvider.startMatch(partie);

      final isDouble = partie.team1Players.length > 1;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => isDouble
              ? DoubleTableScreen(partie: partie)
              : TableScreen(partie: partie),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final team1Name = partie.team1Players.map((p) => p.name).join(' & ');
    final team2Name = partie.team2Players.map((p) => p.name).join(' & ');
    final isDouble = partie.team1Players.length > 1;

    final Color cardColor;
    if (isPlayed) {
      cardColor = Colors.grey.shade400;
    } else if (isDouble) {
      cardColor = Colors.blue.shade100;
    } else {
      cardColor = Colors.green.shade100;
    }

    return Card(
      color: cardColor,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: !isPlayed ? () => _navigateToTableScreen(context) : null,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Partie ${partie.id}',
                style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'Oswald'),
              ),
              const SizedBox(height: 8.0),
              Text(
                '$team1Name vs $team2Name',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
              if (partie.arbitre != null && !isPlayed)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Arbitre : ${partie.arbitre!.name}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              if (isPlayed)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      Text(
                        'Vainqueur: ${partie.winner ?? ''}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // Text(
                      //   'Score : ${partie.score}',
                      //   style: theme.textTheme.bodyMedium?.copyWith(
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(team1Name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Points: ${partie.pointsGagnesTeam1 ?? 0}'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(team2Name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Points: ${partie.pointsGagnesTeam2 ?? 0}'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
