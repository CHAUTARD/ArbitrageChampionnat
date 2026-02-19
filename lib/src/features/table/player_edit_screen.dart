
// lib/src/features/table/player_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:provider/provider.dart';

class PlayerEditScreen extends StatelessWidget {
  final Partie partie;

  const PlayerEditScreen({super.key, required this.partie});

  void _showEditPlayerNameDialog(
      BuildContext context, Player player, PartieProvider partieProvider) {
    final controller = TextEditingController(text: player.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le nom du joueur'),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                partieProvider.updatePlayerName(player.id, controller.text);
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
  Widget build(BuildContext context) {
    final partieProvider = Provider.of<PartieProvider>(context, listen: true);
    final theme = Theme.of(context);

    // Combine players from both teams into a single list
    final players = [...partie.team1Players, ...partie.team2Players];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Éditer les joueurs du match', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          ...players.map(
            (player) => ListTile(
              title: Text(player.name),
              subtitle: Text('Équipe ${player.id.startsWith('A') ? 'A' : 'B'}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    _showEditPlayerNameDialog(context, player, partieProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
