// lib/src/features/settings/settings_screen.dart
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
                // Corrected: Pass player.id (which is an int) and the new name
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
    // Corrected: Use the `allPlayers` getter, which is correctly defined in TeamProvider.
    // `listen: true` ensures the UI rebuilds when player names are updated.
    final teamProvider = Provider.of<TeamProvider>(context, listen: true);
    final allPlayers = teamProvider.allPlayers; // <-- CORRECTED HERE

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres des Joueurs'),
        backgroundColor: Colors.indigo,
      ),
      body: allPlayers.isEmpty
          ? const Center(child: Text('Aucun joueur à afficher.'))
          : ListView.builder(
              itemCount: allPlayers.length,
              itemBuilder: (context, index) {
                final player = allPlayers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(player.letter),
                    ),
                    title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                    onTap: () => _showEditPlayerNameDialog(context, player, teamProvider),
                  ),
                );
              },
            ),
    );
  }
}
