// features/match_selection/partie_card.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';

class PartieCard extends StatelessWidget {
  final Partie partie;
  final VoidCallback onTap;

  const PartieCard({super.key, required this.partie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDouble = partie.team1Players.length > 1;
    final title = isDouble
        ? 'Double ${partie.id == '9' ? '1' : '2'}'
        : '${partie.team1Players.first.name} vs ${partie.team2Players.first.name}';

    String getPlayerNames(List<dynamic> players) {
      if (players.length > 1) {
        return '${players[0].name} & ${players[1].name}';
      }
      return 'Composition incomplète';
    }

    final subtitle = isDouble
        ? '${getPlayerNames(partie.team1Players)} vs ${getPlayerNames(partie.team2Players)}'
        : 'Simple';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap, // CORRECTION : Utilisation du onTap fourni
      ),
    );
  }
}
