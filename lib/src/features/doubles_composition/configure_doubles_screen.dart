import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/match_selection/partie_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';

class ConfigureDoublesScreen extends StatefulWidget {
  final Match match;

  const ConfigureDoublesScreen({super.key, required this.match});

  @override
  State<ConfigureDoublesScreen> createState() => _ConfigureDoublesScreenState();
}

class _ConfigureDoublesScreenState extends State<ConfigureDoublesScreen> {
  late List<Player> _team1Players;
  late List<Player> _team2Players;

  Player? _team1Player1;
  Player? _team1Player2;
  Player? _team2Player1;
  Player? _team2Player2;

  List<Player> _team1Remaining = [];
  List<Player> _team2Remaining = [];

  late Partie _double1;
  late Partie _double2;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final editableDoubles = widget.match.parties
        .where((p) => p.isEditable)
        .toList();
    // Ensure we have exactly two editable doubles, assuming they are 9 and 10
    _double1 = editableDoubles.firstWhere((p) => p.numero == 9);
    _double2 = editableDoubles.firstWhere((p) => p.numero == 10);
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final playersBox = await Hive.openBox<Player>('players');
    final allPlayers = playersBox.values.toList();
    setState(() {
      _team1Players = allPlayers
          .where((p) => p.equipe == widget.match.equipeUn)
          .toList();
      _team2Players = allPlayers
          .where((p) => p.equipe == widget.match.equipeDeux)
          .toList();

      // Pre-fill from double 1 if players are already assigned
      if (_double1.team1PlayerIds.length == 2) {
        _team1Player1 = _team1Players.firstWhere(
          (p) => p.id == _double1.team1PlayerIds[0],
        );
        _team1Player2 = _team1Players.firstWhere(
          (p) => p.id == _double1.team1PlayerIds[1],
        );
      }
      if (_double1.team2PlayerIds.length == 2) {
        _team2Player1 = _team2Players.firstWhere(
          (p) => p.id == _double1.team2PlayerIds[0],
        );
        _team2Player2 = _team2Players.firstWhere(
          (p) => p.id == _double1.team2PlayerIds[1],
        );
      }
      _updateRemainingPlayers();
      _isLoading = false;
    });
  }

  void _updateRemainingPlayers() {
    setState(() {
      final selectedTeam1 = [_team1Player1, _team1Player2];
      _team1Remaining = _team1Players
          .where((p) => !selectedTeam1.contains(p))
          .toList();

      final selectedTeam2 = [_team2Player1, _team2Player2];
      _team2Remaining = _team2Players
          .where((p) => !selectedTeam2.contains(p))
          .toList();
    });
  }

  void _saveComposition() {
    if (_team1Player1 == null ||
        _team1Player2 == null ||
        _team2Player1 == null ||
        _team2Player2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez sélectionner tous les joueurs pour le premier double.',
          ),
        ),
      );
      return;
    }

    // Update Double 1
    final updatedDouble1 = _double1.copyWith(
      team1PlayerIds: [_team1Player1!.id, _team1Player2!.id],
      team2PlayerIds: [_team2Player1!.id, _team2Player2!.id],
    );

    // Update Double 2
    final updatedDouble2 = _double2.copyWith(
      team1PlayerIds: _team1Remaining.map((p) => p.id).toList(),
      team2PlayerIds: _team2Remaining.map((p) => p.id).toList(),
    );

    final matchService = Provider.of<MatchService>(context, listen: false);
    final updatedParties = widget.match.parties.map((p) {
      if (p.numero == _double1.numero) return updatedDouble1;
      if (p.numero == _double2.numero) return updatedDouble2;
      return p;
    }).toList();

    final updatedMatch = widget.match.copyWith(parties: updatedParties);
    matchService.updateMatch(updatedMatch);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PartieListScreen(match: updatedMatch),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Composition des Doubles')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Composition des Doubles'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeamSection(
              title: 'Composition du Double 1 (Partie ${_double1.numero})',
              teamName: widget.match.equipeUn,
              players: _team1Players,
              selectedPlayer1: _team1Player1,
              selectedPlayer2: _team1Player2,
              onPlayer1Changed: (player) {
                setState(() {
                  _team1Player1 = player;
                  if (_team1Player1 == _team1Player2) _team1Player2 = null;
                  _updateRemainingPlayers();
                });
              },
              onPlayer2Changed: (player) {
                setState(() {
                  _team1Player2 = player;
                  if (_team1Player1 == _team1Player2) _team1Player1 = null;
                  _updateRemainingPlayers();
                });
              },
            ),
            const SizedBox(height: 16),
            _buildTeamSection(
              title: '',
              teamName: widget.match.equipeDeux,
              players: _team2Players,
              selectedPlayer1: _team2Player1,
              selectedPlayer2: _team2Player2,
              onPlayer1Changed: (player) {
                setState(() {
                  _team2Player1 = player;
                  if (_team2Player1 == _team2Player2) _team2Player2 = null;
                  _updateRemainingPlayers();
                });
              },
              onPlayer2Changed: (player) {
                setState(() {
                  _team2Player2 = player;
                  if (_team2Player1 == _team2Player2) _team2Player1 = null;
                  _updateRemainingPlayers();
                });
              },
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            _buildReadOnlySection(
              title: 'Composition du Double 2 (Partie ${_double2.numero})',
              teamName: widget.match.equipeUn,
              players: _team1Remaining,
            ),
            const SizedBox(height: 16),
            _buildReadOnlySection(
              title: '',
              teamName: widget.match.equipeDeux,
              players: _team2Remaining,
            ),

            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: _saveComposition,
                child: const Text('Enregistrer et Continuer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection({
    required String title,
    required String teamName,
    required List<Player> players,
    required Player? selectedPlayer1,
    required Player? selectedPlayer2,
    required ValueChanged<Player?> onPlayer1Changed,
    required ValueChanged<Player?> onPlayer2Changed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 8),
        Text(teamName, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _playerDropdown(
                players,
                selectedPlayer1,
                onPlayer1Changed,
                selectedPlayer2,
              ),
            ),
            const SizedBox(width: 8),
            const Text('&', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Expanded(
              child: _playerDropdown(
                players,
                selectedPlayer2,
                onPlayer2Changed,
                selectedPlayer1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _playerDropdown(
    List<Player> players,
    Player? selectedPlayer,
    ValueChanged<Player?> onChanged,
    Player? otherSelectedPlayer,
  ) {
    return DropdownButtonFormField<Player>(
      initialValue: selectedPlayer,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      items: players.map((player) {
        return DropdownMenuItem<Player>(
          value: player,
          // Disable selection if the player is already chosen in the other dropdown of the same team
          enabled: player != otherSelectedPlayer,
          child: Text(player.name),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Choisir' : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildReadOnlySection({
    required String title,
    required String teamName,
    required List<Player> players,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 8),
        Text(teamName, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          players.length == 2
              ? '${players[0].name} & ${players[1].name}'
              : 'En attente de la composition du double 1...',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }
}
