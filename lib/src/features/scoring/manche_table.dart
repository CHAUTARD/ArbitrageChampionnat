// features/scoring/manche_table.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';

class MancheTable extends ConsumerWidget {
  const MancheTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchState = ref.watch(matchProvider);
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
                  '${matchState.manchesGagneesTeam1}',
                  style: theme.textTheme.headlineSmall,
                ),
                Text(
                  '-',
                  style: theme.textTheme.headlineSmall,
                ),
                Text(
                  '${matchState.manchesGagneesTeam2}',
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
