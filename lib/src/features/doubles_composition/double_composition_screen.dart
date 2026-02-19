// features/doubles_composition/double_composition_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:provider/provider.dart';

class DoublesCompositionScreen extends StatefulWidget {
  final Partie partie;
  const DoublesCompositionScreen({super.key, required this.partie});

  @override
  State<DoublesCompositionScreen> createState() =>
      _DoublesCompositionScreenState();
}

class _DoublesCompositionScreenState extends State<DoublesCompositionScreen> {
  late List<Player> _team1Selection;
  late List<Player> _team2Selection;

  @override
  void initState() {
    super.initState();
    _team1Selection = List.from(widget.partie.team1Players);
    _team2Selection = List.from(widget.partie.team2Players);
  }

  @override
  Widget build(BuildContext context) {
    final partieProvider = Provider.of<PartieProvider>(context, listen: false);
    final allPlayers = partieProvider.allPlayers;

    final team1PlayersPool = allPlayers.where((p) => p.id.startsWith('A')).toList();
    final team2PlayersPool = allPlayers.where((p) => p.id.startsWith('B')).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTeamSection(
                'Équipe 1',
                team1PlayersPool,
                _team1Selection,
                (player, isSelected) {
                  setState(() {
                    if (isSelected) {
                      if (_team1Selection.length < 2) {
                        _team1Selection.add(player);
                      }
                    } else {
                      _team1Selection.removeWhere((p) => p.id == player.id);
                    }
                  });
                },
              ),
              const SizedBox(height: 24),
              _buildTeamSection(
                'Équipe 2',
                team2PlayersPool,
                _team2Selection,
                (player, isSelected) {
                  setState(() {
                    if (isSelected) {
                      if (_team2Selection.length < 2) {
                        _team2Selection.add(player);
                      }
                    } else {
                      _team2Selection.removeWhere((p) => p.id == player.id);
                    }
                  });
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: (_team1Selection.length == 2 &&
                          _team2Selection.length == 2)
                      ? () {
                          partieProvider.updateDoublesComposition(
                            widget.partie.id,
                            _team1Selection,
                            _team2Selection,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Composition mise à jour !'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      : null,
                  child: const Text('Valider la Composition'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CORRECTION: Simplification de la signature de la méthode
  Widget _buildTeamSection(
    String title,
    List<Player> teamPlayersPool,
    List<Player> selectedPlayers,
    void Function(Player, bool) onSelectionChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: teamPlayersPool.map((player) {
            final isSelected = selectedPlayers.any((p) => p.id == player.id);
            return FilterChip(
              label: Text(player.name),
              selected: isSelected,
              onSelected: (selected) {
                // Empêche de sélectionner plus de 2 joueurs
                if (selected && selectedPlayers.length >= 2) return;
                onSelectionChanged(player, selected);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text('Joueurs sélectionnés : ${selectedPlayers.length} / 2'),
      ],
    );
  }
}
