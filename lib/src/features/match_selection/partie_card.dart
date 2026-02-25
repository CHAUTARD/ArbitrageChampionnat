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
    final isDouble = partie.isDouble;

    String getPlayerNames(List<Player> players) {
      if (players.isEmpty || players.any((p) => p.id.isEmpty)) {
        return 'Composition incomplète';
      }
      if (players.length == 1) return players.first.name;
      return '${players[0].name} & ${players[1].name}';
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      isDouble
                          ? 'Partie ${partie.numero} - Double'
                          : 'Partie ${partie.numero}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (arbitre != null)
                    Row(
                      children: [
                        const Icon(Icons.sports, size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          'Arbitre: ${arbitre!.name}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.black54,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(flex: 3, child: _buildTeamColumn(context, getPlayerNames(team1Players), CrossAxisAlignment.start)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      partie.validated && partie.scoreEquipeUn != null && partie.scoreEquipeDeux != null
                        ? '${partie.scoreEquipeUn} - ${partie.scoreEquipeDeux}'
                        : 'VS',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                   Expanded(flex: 3, child: _buildTeamColumn(context, getPlayerNames(team2Players), CrossAxisAlignment.end)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamColumn(BuildContext context, String playerNames, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          playerNames,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: alignment == CrossAxisAlignment.start ? TextAlign.left : TextAlign.right,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
