import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/match_selection/partie_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';

class PlayerEntryScreen extends StatefulWidget {
  final Match match;

  const PlayerEntryScreen({super.key, required this.match});

  @override
  State<PlayerEntryScreen> createState() => _PlayerEntryScreenState();
}

class _PlayerEntryScreenState extends State<PlayerEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'A': TextEditingController(),
    'B': TextEditingController(),
    'C': TextEditingController(),
    'D': TextEditingController(),
    'W': TextEditingController(),
    'X': TextEditingController(),
    'Y': TextEditingController(),
    'Z': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _controllers['A']!.text = 'Alain';
      _controllers['B']!.text = 'Bernard';
      _controllers['C']!.text = 'Claude';
      _controllers['D']!.text = 'Didier';
      _controllers['W']!.text = 'Williams';
      _controllers['X']!.text = 'Xavier';
      _controllers['Y']!.text = 'Yves';
      _controllers['Z']!.text = 'Zoé';
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _savePlayersAndCreateParties() async {
    if (_formKey.currentState!.validate()) {
      final matchService = Provider.of<MatchService>(context, listen: false);
      final navigator = Navigator.of(context);

      final playersBox = await Hive.openBox<Player>('players');

      // Clear existing players for this match to avoid duplicates
      final oldPlayers = playersBox.values.where(
        (p) => p.id.startsWith(widget.match.id),
      );
      for (var player in oldPlayers) {
        await playersBox.delete(player.id);
      }

      final players = <Player>[];
      final Map<String, Player> playerMap = {};

      final team1Letters = ['A', 'B', 'C', 'D'];
      for (var letter in team1Letters) {
        final player = Player(
          id: '${widget.match.id}-$letter',
          name: _controllers[letter]!.text,
          equipe: widget.match.equipeUn,
          lettre: letter,
        );
        players.add(player);
        playerMap[letter] = player;
      }

      final team2Letters = ['W', 'X', 'Y', 'Z'];
      for (var letter in team2Letters) {
        final player = Player(
          id: '${widget.match.id}-$letter',
          name: _controllers[letter]!.text,
          equipe: widget.match.equipeDeux,
          lettre: letter,
        );
        players.add(player);
        playerMap[letter] = player;
      }

      for (var player in players) {
        await playersBox.put(player.id, player);
      }

      final parties = _createMatchParties(playerMap);
      final updatedMatch = widget.match.copyWith(parties: parties);
      await matchService.updateMatch(updatedMatch);

      if (!mounted) return;

      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => PartieListScreen(match: updatedMatch),
        ),
      );
    }
  }

  List<Partie> _createMatchParties(Map<String, Player> players) {
    const defaultStatus = 'À venir';

    return [
      // Simples
      Partie(
        numero: 1,
        team1PlayerIds: [players['A']!.id],
        team2PlayerIds: [players['W']!.id],
        arbitreId: players['D']!.id,
        status: defaultStatus,
        isEditable: false,
      ),
      Partie(
        numero: 2,
        team1PlayerIds: [players['B']!.id],
        team2PlayerIds: [players['X']!.id],
        arbitreId: players['Z']!.id,
        status: defaultStatus,
        isEditable: false,
      ),
      Partie(
        numero: 3,
        team1PlayerIds: [players['C']!.id],
        team2PlayerIds: [players['Y']!.id],
        arbitreId: players['B']!.id,
        status: defaultStatus,
        isEditable: false,
      ),
      Partie(
        numero: 4,
        team1PlayerIds: [players['D']!.id],
        team2PlayerIds: [players['Z']!.id],
        arbitreId: players['W']!.id,
        status: defaultStatus,
        isEditable: false,
      ),
      Partie(
        numero: 5,
        team1PlayerIds: [players['A']!.id],
        team2PlayerIds: [players['X']!.id],
        arbitreId: players['X']!.id,
        status: defaultStatus,
        isEditable: false,
      ),
      Partie(
        numero: 6,
        team1PlayerIds: [players['B']!.id],
        team2PlayerIds: [players['W']!.id],
        arbitreId: players['Y']!.id,
        status: defaultStatus,
        isEditable: false,
      ),
      Partie(
        numero: 7,
        team1PlayerIds: [players['D']!.id],
        team2PlayerIds: [players['Y']!.id],
        arbitreId: players['Z']!.id,
        status: defaultStatus,
        isEditable: false,
      ),
      Partie(
        numero: 8,
        team1PlayerIds: [players['C']!.id],
        team2PlayerIds: [players['Z']!.id],
        arbitreId: players['W']!.id,
        status: defaultStatus,
        isEditable: false,
      ),

      // Doubles - No referee assigned
      Partie(
        numero: 9,
        team1PlayerIds: [],
        team2PlayerIds: [],
        status: defaultStatus,
        isEditable: true,
      ),
      Partie(
        numero: 10,
        team1PlayerIds: [],
        team2PlayerIds: [],
        status: defaultStatus,
        isEditable: true,
      ),

      // Simples after doubles
      Partie(
        numero: 11,
        team1PlayerIds: [players['A']!.id],
        team2PlayerIds: [players['Y']!.id],
        arbitreId: players['Z']!.id,
        status: defaultStatus,
        isEditable: false,
      ),
      Partie(
        numero: 12,
        team1PlayerIds: [players['C']!.id],
        team2PlayerIds: [players['W']!.id],
        arbitreId: players['B']!.id,
        status: defaultStatus,
        isEditable: false,
      ),
      Partie(
        numero: 13,
        team1PlayerIds: [players['D']!.id],
        team2PlayerIds: [players['X']!.id],
        arbitreId: players['W']!.id,
        status: defaultStatus,
        isEditable: false,
      ),
      Partie(
        numero: 14,
        team1PlayerIds: [players['B']!.id],
        team2PlayerIds: [players['Z']!.id],
        arbitreId: players['C']!.id,
        status: defaultStatus,
        isEditable: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saisie des joueurs')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTeamSection(widget.match.equipeUn, ['A', 'B', 'C', 'D']),
              const SizedBox(height: 20),
              _buildTeamSection(widget.match.equipeDeux, ['W', 'X', 'Y', 'Z']),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _savePlayersAndCreateParties,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Enregistrer et voir les parties'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSection(String teamName, List<String> letters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(teamName, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ...letters.map((letter) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: TextFormField(
              controller: _controllers[letter],
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Joueur $letter',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le nom ne peut pas être vide';
                }
                return null;
              },
            ),
          );
        }),
      ],
    );
  }
}
