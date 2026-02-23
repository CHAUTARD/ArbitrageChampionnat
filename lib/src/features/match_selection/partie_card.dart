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
    final isDouble = partie.team1PlayerIds.length == 2;

    String getPlayerNames(List<Player> players) {
      if (players.isEmpty) return 'Composition incomplète';
      if (players.length == 1) return players.first.name;
      return '${players[0].name} & ${players[1].name}';
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDouble
                    ? 'Double Messieurs - Partie ${partie.numero}'
                    : 'Simple Messieurs - Partie ${partie.numero}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getPlayerNames(team1Players),
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Équipe 1',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'VS',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          getPlayerNames(team2Players),
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Équipe 2',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (arbitre != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sports, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Arbitre: ${arbitre!.name}',
                        style: Theme.of(context).textTheme.bodyMedium,
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
