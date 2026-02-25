// Path: lib/src/features/doubles_composition/double_composition_screen.dart
// Rôle: Gère l'écran de composition des équipes pour une partie de double.
// Cet écran permet à l'utilisateur de sélectionner les deux joueurs de chaque équipe qui participeront à une partie de double spécifique.
// La sélection est validée pour s'assurer qu'un joueur n'est pas sélectionné deux fois dans la même équipe.
// La composition est ensuite sauvegardée dans la base de données locale.

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';

class DoubleCompositionScreen extends StatefulWidget {
  final Partie partie;
  final Match match;

  const DoubleCompositionScreen({
    super.key,
    required this.partie,
    required this.match,
  });

  @override
  State<DoubleCompositionScreen> createState() =>
      _DoubleCompositionScreenState();
}

class _DoubleCompositionScreenState extends State<DoubleCompositionScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Player> _team1Players = [];
  List<Player> _team2Players = [];

  String? _selectedT1P1;
  String? _selectedT1P2;
  String? _selectedT2P1;
  String? _selectedT2P2;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final playersBox = await Hive.openBox<Player>('players');
    if (!mounted) return;
    final allPlayers = playersBox.values.toList();

    setState(() {
      _team1Players = allPlayers
          .where((p) => p.equipe == widget.match.equipeUn)
          .toList();
      _team2Players = allPlayers
          .where((p) => p.equipe == widget.match.equipeDeux)
          .toList();

      if (widget.partie.team1PlayerIds.isNotEmpty) {
        _selectedT1P1 = widget.partie.team1PlayerIds[0];
      }
      if (widget.partie.team1PlayerIds.length > 1) {
        _selectedT1P2 = widget.partie.team1PlayerIds[1];
      }
      if (widget.partie.team2PlayerIds.isNotEmpty) {
        _selectedT2P1 = widget.partie.team2PlayerIds[0];
      }
      if (widget.partie.team2PlayerIds.length > 1) {
        _selectedT2P2 = widget.partie.team2PlayerIds[1];
      }

      _isLoading = false;
    });
  }

  Future<void> _saveComposition() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedT1P1 == null ||
          _selectedT1P2 == null ||
          _selectedT2P1 == null ||
          _selectedT2P2 == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner tous les joueurs.'),
          ),
        );
        return;
      }

      final updatedPartie = widget.partie.copyWith(
        team1PlayerIds: [_selectedT1P1!, _selectedT1P2!],
        team2PlayerIds: [_selectedT2P1!, _selectedT2P2!],
      );

      final partiesBox = Hive.box<Partie>('parties');
      await partiesBox.put(updatedPartie.id, updatedPartie);

      if (!mounted) return;

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chargement...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Composition des Équipes de Double')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTeamSelection(
              widget.match.equipeUn,
              _team1Players,
              _selectedT1P1,
              _selectedT1P2,
              (p1, p2) {
                setState(() {
                  _selectedT1P1 = p1;
                  _selectedT1P2 = p2;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildTeamSelection(
              widget.match.equipeDeux,
              _team2Players,
              _selectedT2P1,
              _selectedT2P2,
              (p1, p2) {
                setState(() {
                  _selectedT2P1 = p1;
                  _selectedT2P2 = p2;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveComposition,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSelection(
    String teamName,
    List<Player> players,
    String? selectedP1,
    String? selectedP2,
    void Function(String?, String?) onSelectionChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(teamName, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: selectedP1,
          decoration: const InputDecoration(
            labelText: 'Joueur 1',
            border: OutlineInputBorder(),
          ),
          items: players
              .map(
                (player) => DropdownMenuItem(
                  value: player.id,
                  child: Text('${player.name} (${player.lettre})'),
                ),
              )
              .toList(),
          onChanged: (value) {
            onSelectionChanged(value, selectedP2);
          },
          validator: (value) {
            if (value == null) {
              return 'Sélectionnez un joueur.';
            }
            if (value == selectedP2) {
              return 'Joueur déjà sélectionné.';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: selectedP2,
          decoration: const InputDecoration(
            labelText: 'Joueur 2',
            border: OutlineInputBorder(),
          ),
          items: players
              .map(
                (player) => DropdownMenuItem(
                  value: player.id,
                  child: Text('${player.name} (${player.lettre})'),
                ),
              )
              .toList(),
          onChanged: (value) {
            onSelectionChanged(selectedP1, value);
          },
          validator: (value) {
            if (value == null) {
              return 'Sélectionnez un joueur.';
            }
            if (value == selectedP1) {
              return 'Joueur déjà sélectionné.';
            }
            return null;
          },
        ),
      ],
    );
  }
}
