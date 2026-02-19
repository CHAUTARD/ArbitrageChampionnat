// features/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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

  void _showResetConfirmationDialog(BuildContext context, PartieProvider partieProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser les données'),
        content: const Text(
            'Voulez-vous vraiment effacer l\'historique des parties et restaurer les noms des joueurs d\'origine ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              partieProvider.resetData();
              Navigator.pop(context);
            },
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final partieProvider = Provider.of<PartieProvider>(context, listen: true);
    final allPlayers = partieProvider.allPlayers;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Réinitialiser les données',
            onPressed: () => _showResetConfirmationDialog(context, partieProvider),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Liste des Joueurs', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          ...allPlayers.map(
            (player) => ListTile(
              title: Text(player.name),
              subtitle: Text('Équipe ${player.id.startsWith('A') ? 'A' : 'B'}'), // CORRECTION
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
