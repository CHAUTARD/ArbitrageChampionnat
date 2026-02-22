// lib/src/features/match_selection/match_card.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/match.dart';

class MatchCard extends StatelessWidget {
  final Match match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${match.equipe1.nom} vs ${match.equipe2.nom}'),
        subtitle: Text('Score: ${match.score1} - ${match.score2}'),
        onTap: () {
          // Navigate to a placeholder screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Détails du match')),
                body: const Center(
                  child: Text(
                    'La fonctionnalité de détails du match n\'est plus disponible.',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
