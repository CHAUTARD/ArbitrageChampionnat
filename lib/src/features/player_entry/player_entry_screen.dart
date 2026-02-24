// lib/src/features/player_entry/player_entry_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/doubles_composition/configure_doubles_screen.dart';

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

  Future<void> _savePlayersAndConfigureDoubles() async {
    if (_formKey.currentState!.validate()) {
      final playersBox = await Hive.openBox<Player>('players');
      await playersBox.clear(); // Clear existing players before adding new ones

      final playersToSave = <Player>[];

      // Team 1
      final team1Letters = ['A', 'B', 'C', 'D'];
      for (var letter in team1Letters) {
        playersToSave.add(
          Player(
            id: '${widget.match.id}-$letter',
            name: _controllers[letter]!.text,
            equipe: widget.match.equipeUn,
            lettre: letter,
          ),
        );
      }

      // Team 2
      final team2Letters = ['W', 'X', 'Y', 'Z'];
      for (var letter in team2Letters) {
        playersToSave.add(
          Player(
            id: '${widget.match.id}-$letter',
            name: _controllers[letter]!.text,
            equipe: widget.match.equipeDeux,
            lettre: letter,
          ),
        );
      }

      // Save all players to Hive
      for (var player in playersToSave) {
        await playersBox.put(player.id, player);
      }

      if (!mounted) return;

      // Navigate to the doubles configuration screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConfigureDoublesScreen(match: widget.match),
        ),
      );
    }
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
                onPressed: _savePlayersAndConfigureDoubles,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                child: const Text('Enregistrer et Configurer les Doubles'),
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
                border: const OutlineInputBorder(),
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
