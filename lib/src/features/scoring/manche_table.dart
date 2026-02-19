// features/scoring/manche_table.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:provider/provider.dart';

class MancheTable extends StatelessWidget {
  const MancheTable({super.key});

  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text('Manches', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${matchProvider.manchesGagneesTeam1}',
                  style: theme.textTheme.headlineSmall,
                ),
                Text(
                  '-',
                  style: theme.textTheme.headlineSmall,
                ),
                Text(
                  '${matchProvider.manchesGagneesTeam2}',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
