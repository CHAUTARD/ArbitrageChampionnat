import 'package:flutter/material.dart';
import 'package:myapp/models/match.dart';

class MatchCard extends StatelessWidget {
  final Match match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final scoreUn = match.parties.fold<int>(
        0, (previousValue, element) => previousValue + element.scoreEquipeUn);
    final scoreDeux = match.parties.fold<int>(
        0, (previousValue, element) => previousValue + element.scoreEquipeDeux);

    return Card(
      child: ListTile(
        title: Text('${match.equipeUn} vs ${match.equipeDeux}'),
        subtitle: Text('Score: $scoreUn - $scoreDeux'),
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
