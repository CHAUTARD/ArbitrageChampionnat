import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/core/data/database.dart' as db;
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/rencontre/rencontre_provider.dart';

class PlayerEditScreen extends ConsumerWidget {
  final Partie partie;

  const PlayerEditScreen({super.key, required this.partie});

  void _showEditPlayerNameDialog(
    BuildContext context,
    db.Player player, // Use the database player model
    WidgetRef ref,
  ) {
    final controller = TextEditingController(text: player.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le nom du joueur'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nom du joueur'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(rencontreProvider.notifier).updatePlayerNames({player.id: controller.text});
                Navigator.pop(context);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rencontreState = ref.watch(rencontreProvider);
    final theme = Theme.of(context);

    if (rencontreState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final allDbPlayers = rencontreState.rencontres.fold<List<db.Player>>([], (prev, element) {
      return prev;
    });

    // Create a map for easy lookup: letter ('A1', 'B2') -> db.Player
    final playerMap = {for (var p in allDbPlayers) p.letter: p};

    // Get the letters of the players involved in this 'partie' from the old model
    final playerLetters = [
      ...partie.team1Players.map((p) => p.id),
      ...partie.team2Players.map((p) => p.id),
    ];

    // Get the full, up-to-date db.Player objects for this 'partie'
    final playersInPartie = playerLetters
        .map((letter) => playerMap[letter])
        .whereType<db.Player>() // Filter out nulls and cast
        .toList();

    // Sort players for consistent display order (e.g., A1, A2, B1, B2)
    playersInPartie.sort((a, b) => a.letter.compareTo(b.letter));

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Éditer les joueurs du match', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          ...playersInPartie.map(
            (player) => ListTile(
              title: Text(player.name),
              // Use the 'letter' property which is guaranteed to exist and be correct
              subtitle: Text('Équipe ${player.letter.startsWith('A') ? 'A' : 'B'}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    _showEditPlayerNameDialog(context, player, ref),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
