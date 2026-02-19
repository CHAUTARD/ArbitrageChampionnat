import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:myapp/src/features/table/double_table_screen.dart';
import 'package:myapp/src/features/table/simple_table_screen.dart';
import 'package:provider/provider.dart';

class MatchCard extends StatelessWidget {
  final Partie partie;
  final bool isDraggable;

  const MatchCard({super.key, required this.partie, this.isDraggable = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDouble = partie.team1Players.length > 1;
    final cardColor = isDouble ? Colors.blue.withAlpha(26) : Colors.green.withAlpha(26);

    final cardContent = Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        onTap: () {
          final matchProvider = Provider.of<MatchProvider>(context, listen: false);
          matchProvider.startMatch(partie);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => isDouble
                  ? DoubleTableScreen(partie: partie)
                  : SimpleTableScreen(partie: partie),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(color: theme.primaryColor.withAlpha(77)),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Partie #${partie.id}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildTeamRow(context, 'Équipe 1', partie.team1Players, theme.colorScheme.primary),
              const SizedBox(height: 4),
              _buildTeamRow(context, 'Équipe 2', partie.team2Players, theme.colorScheme.secondary),
            ],
          ),
        ),
      ),
    );

    if (isDraggable) {
      return LongPressDraggable<Partie>(
        data: partie,
        feedback: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
          child: cardContent,
        ),
        child: cardContent,
      );
    } else {
      return cardContent;
    }
  }

  Widget _buildTeamRow(BuildContext context, String teamName, List<dynamic> players, Color color) {
    final playerNames = players.map((p) => p.name).join(' & ');
    return Row(
      children: [
        Container(width: 4, height: 16, color: color, margin: const EdgeInsets.only(right: 8)),
        Expanded(
            child: Text(playerNames,
                style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
