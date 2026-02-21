import 'package:flutter/material.dart';
import 'package:myapp/models/partie_model.dart';

class MatchCard extends StatelessWidget {
  final Partie partie;

  const MatchCard({super.key, required this.partie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          '${partie.team1Players.first.name} vs ${partie.team2Players.first.name}',
        ),
        subtitle: Text('Match de simple'),
        onTap: () {
          // Navigate to a placeholder screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text('Détails du match')),
                body: Center(
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
