import 'package:flutter/material.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';

class PartieCard extends StatelessWidget {
  final Partie partie;
  final String equipeUn;
  final String equipeDeux;
  final List<Player> team1Players;
  final List<Player> team2Players;
  final Player? arbitre;
  final VoidCallback onTap;

  const PartieCard({
    super.key,
    required this.partie,
    required this.equipeUn,
    required this.equipeDeux,
    required this.team1Players,
    required this.team2Players,
    this.arbitre,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Terminé':
        return Colors.green;
      case 'En cours':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDouble = partie.team1PlayerIds.length > 1;

    String getPlayerNames(List<Player> players) {
      if (players.any((p) => p.id.isEmpty)) return 'Composition incomplète';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isDouble
                        ? 'Partie ${partie.numero} - Double'
                        : 'Partie ${partie.numero}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(partie.status),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      partie.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
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
                          equipeUn,
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
                          equipeDeux,
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
