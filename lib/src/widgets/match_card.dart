import 'package:flutter/material.dart';
import 'package:myapp/models/match.dart';
import 'package:intl/intl.dart';

class MatchCard extends StatelessWidget {
  final Match match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(match.date);
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: const Icon(Icons.sports_tennis, size: 40),
        title: Text(
          '${match.player1} vs ${match.player2}',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Match du $formattedDate'),
        trailing: Text(
          '${match.score1} - ${match.score2}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
