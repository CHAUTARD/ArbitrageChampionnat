import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:provider/provider.dart';

class DoubleCompositionScreen extends StatefulWidget {
  const DoubleCompositionScreen({super.key});

  @override
  State<DoubleCompositionScreen> createState() =>
      _DoubleCompositionScreenState();
}

class _DoubleCompositionScreenState extends State<DoubleCompositionScreen> {
  late List<Player> _team1Selection;
  late List<Player> _team2Selection;
  final Map<String, String> _updatedPlayerNames = {};

  @override
  void initState() {
    super.initState();
    final partieProvider = Provider.of<PartieProvider>(context, listen: false);

    final doubles = partieProvider.parties
        .where((p) => p.team1Players.length > 1)
        .toList();

    doubles.sort((a, b) => a.id.compareTo(b.id));

    final Partie double1;
    if (doubles.isNotEmpty) {
      double1 = doubles.first;
    } else {
      double1 = Partie(
        id: 9,
        team1Players: [],
        team2Players: [],
      );
    }

    _team1Selection = List.from(double1.team1Players);
    _team2Selection = List.from(double1.team2Players);
  }

  void _showEditPlayerNameDialog(BuildContext context, Player player) {
    final TextEditingController nameController =
        TextEditingController(text: _updatedPlayerNames[player.id] ?? player.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le nom du joueur'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nom du joueur'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                final newName = nameController.text;
                if (newName.isNotEmpty) {
                  setState(() {
                    _updatedPlayerNames[player.id] = newName;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final partieProvider = Provider.of<PartieProvider>(context);
    final team1Players = partieProvider.equipe1;
    final team2Players = partieProvider.equipe2;
    const team1Name = 'Équipe 1';
    const team2Name = 'Équipe 2';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Composition des Doubles'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              _buildTeamColumn(context, team1Name, team1Players, _team1Selection),
              const SizedBox(height: 12),
              const Divider(thickness: 1),
              const SizedBox(height: 12),
              _buildTeamColumn(context, team2Name, team2Players, _team2Selection),
              const SizedBox(height: 16),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamColumn(
    BuildContext context,
    String teamName,
    List<Player> allPlayers,
    List<Player> selectedPlayers,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$teamName / Double 1',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, color: Colors.blue[800])),
        const Divider(height: 4),
        ...allPlayers.map((player) {
          final playerName = _updatedPlayerNames[player.id] ?? player.name;
          return CheckboxListTile(
            title: Text(playerName),
            value: selectedPlayers.contains(player),
            secondary: IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditPlayerNameDialog(context, player),
            ),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  if (selectedPlayers.length < 2) {
                    selectedPlayers.add(player);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Décochez un joueur avant d\'en sélectionner un nouveau.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } else {
                  selectedPlayers.remove(player);
                }
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
          );
        }),
        const SizedBox(height: 12),
        Text('$teamName / Double 2 (Automatique)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey[700], fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          _getRemainingPlayers(allPlayers, selectedPlayers),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  String _getRemainingPlayers(List<Player> all, List<Player> selected) {
    if (selected.length != 2) return 'En attente de sélection...';
    final remaining = all
        .where((p) => !selected.contains(p))
        .map((p) => _updatedPlayerNames[p.id] ?? p.name)
        .join(' & ');
    return remaining.isNotEmpty ? remaining : 'Aucun';
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.cancel),
          label: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey[700],
            side: BorderSide(color: Colors.grey[400]!),
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.check_circle),
          label: const Text('Valider'),
          onPressed: _validateAndSaveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _validateAndSaveChanges() {
    if (_team1Selection.length != 2 || _team2Selection.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner 2 joueurs pour chaque équipe.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final partieProvider = Provider.of<PartieProvider>(context, listen: false);

    _updatedPlayerNames.forEach((id, newName) {
      partieProvider.updatePlayerName(id, newName);
    });

    partieProvider.updateDoublesComposition(_team1Selection, _team2Selection);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Composition des doubles et noms des joueurs enregistrés !'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }
}
