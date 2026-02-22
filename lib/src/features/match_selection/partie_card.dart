import 'package:flutter/material.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';

class PartieCard extends StatelessWidget {
  final Partie partie;
  final List<Player> team1Players;
  final List<Player> team2Players;
  final Player? arbitre;
  final VoidCallback onTap;

  const PartieCard({
    super.key,
    required this.partie,
    required this.team1Players,
    required this.team2Players,
    this.arbitre,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDouble = partie.type == 'Double';

    String getPlayerNames(List<Player> players) {
      if (players.isEmpty) return 'Composition incomplète';
      if (players.length == 1) return players.first.name;
      return '${players[0].name} & ${players[1].name}';
    }

    final title = isDouble
        ? 'Double ${partie.id == '9' ? '1' : '2'}'
        : (team1Players.isNotEmpty && team2Players.isNotEmpty
            ? '${team1Players.first.name} vs ${team2Players.first.name}'
            : 'Simple');

    final subtitle = isDouble
        ? '${getPlayerNames(team1Players)} vs ${getPlayerNames(team2Players)}'
        : 'Arbitre: ${arbitre?.name ?? 'Non défini'}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
