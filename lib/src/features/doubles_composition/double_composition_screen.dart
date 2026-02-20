import 'package:flutter/material.dart';
import 'package:myapp/src/features/core/data/database.dart' as db;
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:provider/provider.dart';

class DoublesCompositionScreen extends StatefulWidget {
  final Partie partie;
  const DoublesCompositionScreen({super.key, required this.partie});

  @override
  State<DoublesCompositionScreen> createState() =>
      _DoublesCompositionScreenState();
}

class _DoublesCompositionScreenState extends State<DoublesCompositionScreen> {
  late List<db.Player> _team1Selection;
  late List<db.Player> _team2Selection;

  @override
  void initState() {
    super.initState();
    _team1Selection = [];
    _team2Selection = [];
  }

  @override
  Widget build(BuildContext context) {
    final partieProvider = Provider.of<PartieProvider>(context, listen: false);

    return FutureBuilder<List<db.Player>>(
      future: partieProvider.allPlayers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading players'));
        }
        final players = snapshot.data ?? [];
        final team1PlayersPool =
            players.where((p) => p.equipeId == 1).toList();
        final team2PlayersPool =
            players.where((p) => p.equipeId == 2).toList();

        if (_team1Selection.isEmpty) {
          _team1Selection.addAll(players.where((p) =>
              widget.partie.team1Players.any((m) => m.id == p.id.toString())));
        }
        if (_team2Selection.isEmpty) {
          _team2Selection.addAll(players.where((p) =>
              widget.partie.team2Players.any((m) => m.id == p.id.toString())));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Composition des doubles'),
          ),
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
                                int.parse(widget.partie.id),
                                _team1Selection[0].id,
                                _team1Selection[1].id,
                                _team2Selection[0].id,
                                _team2Selection[1].id,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Composition mise à jour !'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(context).pop();
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
      },
    );
  }

  Widget _buildTeamSection(
    String title,
    List<db.Player> teamPlayersPool,
    List<db.Player> selectedPlayers,
    void Function(db.Player, bool) onSelectionChanged,
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
                if (selected && selectedPlayers.length >= 2 && !isSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Vous ne pouvez sélectionner que 2 joueurs par équipe.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
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
