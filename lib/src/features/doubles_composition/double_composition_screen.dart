
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:myapp/src/features/match_selection/team_provider.dart';
import 'package:provider/provider.dart';

class DoubleCompositionScreen extends StatefulWidget {
  const DoubleCompositionScreen({super.key});

  @override
  State<DoubleCompositionScreen> createState() => _DoubleCompositionScreenState();
}

class _DoubleCompositionScreenState extends State<DoubleCompositionScreen> {
  late List<Player> _team1Selection;
  late List<Player> _team2Selection;

  @override
  void initState() {
    super.initState();
    final partieProvider = Provider.of<PartieProvider>(context, listen: false);
    final double1 = partieProvider.parties.firstWhere(
        (p) => p.name == 'Double N° 1',
        orElse: () => Partie(numero: 0, name: '', team1Players: [], team2Players: []), // Safe fallback
    );

    _team1Selection = List.from(double1.team1Players);
    _team2Selection = List.from(double1.team2Players);
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    final team1Players = teamProvider.equipe1;
    final team2Players = teamProvider.equipe2;
    final team1Name = teamProvider.teams.isNotEmpty ? teamProvider.teams[0].name : 'Équipe 1';
    final team2Name = teamProvider.teams.length > 1 ? teamProvider.teams[1].name : 'Équipe 2';


    return Scaffold(
      appBar: AppBar(
        title: const Text('Composition des Doubles'),
        backgroundColor: Colors.blue[800],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTeamColumn(context, team1Name, team1Players, _team1Selection),
                  ),
                  const VerticalDivider(width: 24, thickness: 1),
                  Expanded(
                    child: _buildTeamColumn(context, team2Name, team2Players, _team2Selection),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButtons(context),
          ],
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
        Text(teamName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue[800])),
        const Divider(),
        Text('Double N° 1', style: Theme.of(context).textTheme.titleLarge),
        ...allPlayers.map((player) {
          return CheckboxListTile(
            title: Text(player.name),
            value: selectedPlayers.contains(player),
            onChanged: (bool? value) {
              setState(() {
                 if (value == true) {
                  if (selectedPlayers.length < 2) {
                    selectedPlayers.add(player);
                  } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Décochez un joueur avant d\'en sélectionner un nouveau.'),
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
          );
        }),
        const SizedBox(height: 24),
        Text('Double N° 2 (Automatique)', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[700])),
        const SizedBox(height: 8),
        Text(
          _getRemainingPlayers(allPlayers, selectedPlayers),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic, fontSize: 16),
        ),
      ],
    );
  }

  String _getRemainingPlayers(List<Player> all, List<Player> selected) {
    if (selected.length != 2) return 'En attente de sélection...';
    final remaining = all.where((p) => !selected.contains(p)).map((p) => p.name).join(' & ');
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

    Provider.of<PartieProvider>(context, listen: false)
        .updateDoublesComposition(_team1Selection, _team2Selection);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Composition des doubles enregistrée !'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }
}
