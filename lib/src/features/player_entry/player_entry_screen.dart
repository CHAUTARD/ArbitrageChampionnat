import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/match_management/presentation/match_list_screen.dart';

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
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _savePlayers() async {
    if (_formKey.currentState!.validate()) {
      final playersBox = await Hive.openBox<Player>('players');

      final team1Letters = ['A', 'B', 'C', 'D'];
      final team2Letters = ['W', 'X', 'Y', 'Z'];

      for (var letter in team1Letters) {
        final player = Player(
          name: _controllers[letter]!.text,
          equipe: widget.match.equipeUn,
          lettre: letter,
        );
        await playersBox.add(player);
      }

      for (var letter in team2Letters) {
        final player = Player(
          name: _controllers[letter]!.text,
          equipe: widget.match.equipeDeux,
          lettre: letter,
        );
        await playersBox.add(player);
      }

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MatchListScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saisie des joueurs'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTeamSection(
                widget.match.equipeUn,
                ['A', 'B', 'C', 'D'],
              ),
              const SizedBox(height: 20),
              _buildTeamSection(
                widget.match.equipeDeux,
                ['W', 'X', 'Y', 'Z'],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _savePlayers,
                child: const Text('Enregistrer et continuer'),
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
        Table(
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          children: letters.map((letter) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 12.0),
                  child: Text(letter, style: Theme.of(context).textTheme.titleLarge),
                ),
                TextFormField(
                  controller: _controllers[letter],
                  decoration: const InputDecoration(labelText: 'Nom du joueur'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
