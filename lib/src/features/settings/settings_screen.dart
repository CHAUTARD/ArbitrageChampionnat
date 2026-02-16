// lib/src/features/settings/settings_screen.dart
// Écran des paramètres pour modifier les noms des joueurs.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/match_selection/team_provider.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showEditPlayerNameDialog(
      BuildContext context, Player player, TeamProvider teamProvider) {
    final controller = TextEditingController(text: player.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le nom de ${player.name}'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nouveau nom'),
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Enregistrer'),
              onPressed: () {
                // CORRECTION: Passer player.id (String) au lieu de l'objet player
                teamProvider.updatePlayerName(player.id, controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context, listen: true);
    final allPlayers = teamProvider.players;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView.builder(
        itemCount: allPlayers.length,
        itemBuilder: (context, index) {
          final player = allPlayers[index];
          return ListTile(
            title: Text(player.name),
            trailing: const Icon(Icons.edit),
            onTap: () =>
                _showEditPlayerNameDialog(context, player, teamProvider),
          );
        },
      ),
    );
  }
}
