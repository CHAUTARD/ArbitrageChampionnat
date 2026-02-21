// lib/src/features/doubles_composition/double_composition_screen.dart
//
// Écran permettant de composer les équipes pour les matchs de double.
// Les utilisateurs peuvent sélectionner deux joueurs pour chaque équipe
// parmi les joueurs disponibles pour la rencontre.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/core/data/database.dart' as db;
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';

class DoublesCompositionScreen extends ConsumerStatefulWidget {
  final Partie partie;
  const DoublesCompositionScreen({super.key, required this.partie});

  @override
  ConsumerState<DoublesCompositionScreen> createState() =>
      _DoublesCompositionScreenState();
}

class _DoublesCompositionScreenState
    extends ConsumerState<DoublesCompositionScreen> {
  late List<db.Player> _team1Selection;
  late List<db.Player> _team2Selection;
  late Future<Map<String, List<db.Player>>> _playersFuture;

  @override
  void initState() {
    super.initState();
    _team1Selection = [];
    _team2Selection = [];
    _playersFuture = ref
        .read(partieProvider.notifier)
        .getPlayersForRencontre(widget.partie.rencontreId);

    _playersFuture.then((players) {
      if (mounted) {
        final team1PlayersPool = players['equipe1'] ?? [];
        _team1Selection.addAll(
          team1PlayersPool.where(
            (p) => widget.partie.team1Players.any(
              (m) => m.id == p.id.toString(),
            ),
          ),
        );

        final team2PlayersPool = players['equipe2'] ?? [];
        _team2Selection.addAll(
          team2PlayersPool.where(
            (p) => widget.partie.team2Players.any(
              (m) => m.id == p.id.toString(),
            ),
          ),
        );
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final partieNotifier = ref.read(partieProvider.notifier);

    return FutureBuilder<Map<String, List<db.Player>>>(
      future: _playersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading players'));
        }
        final players = snapshot.data ?? {'equipe1': [], 'equipe2': []};
        final team1PlayersPool = players['equipe1']!;
        final team2PlayersPool = players['equipe2']!;

        return Scaffold(
          appBar: AppBar(title: const Text('Composition des doubles')),
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
                              partieNotifier.updateDoublesComposition(
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
                        'Vous ne pouvez sélectionner que 2 joueurs par équipe.',
                      ),
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
