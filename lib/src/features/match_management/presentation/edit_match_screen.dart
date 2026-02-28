import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';

class EditMatchScreen extends StatefulWidget {
  final Match match;

  const EditMatchScreen({super.key, required this.match});

  @override
  EditMatchScreenState createState() => EditMatchScreenState();
}

class EditMatchScreenState extends State<EditMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _playerControllers = {
    'A': TextEditingController(),
    'B': TextEditingController(),
    'C': TextEditingController(),
    'D': TextEditingController(),
    'W': TextEditingController(),
    'X': TextEditingController(),
    'Y': TextEditingController(),
    'Z': TextEditingController(),
  };
  late String _equipeUn;
  late String _equipeDeux;
  late DateTime _date;
  bool _isLoadingPlayers = true;

  @override
  void initState() {
    super.initState();
    _equipeUn = widget.match.equipeUn;
    _equipeDeux = widget.match.equipeDeux;
    _date = widget.match.date;
    _loadPlayers();
  }

  @override
  void dispose() {
    for (final controller in _playerControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadPlayers() async {
    final playersBox = await Hive.openBox<Player>('players');

    for (final entry in _playerControllers.entries) {
      final player = playersBox.get('${widget.match.id}-${entry.key}');
      entry.value.text = player?.name ?? '';
    }

    if (!mounted) return;
    setState(() {
      _isLoadingPlayers = false;
    });
  }

  Future<void> _saveMatchAndPlayers() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final matchService = Provider.of<MatchService>(context, listen: false);

    _formKey.currentState!.save();

    final playersBox = await Hive.openBox<Player>('players');
    const team1Letters = ['A', 'B', 'C', 'D'];
    const team2Letters = ['W', 'X', 'Y', 'Z'];

    for (final letter in team1Letters) {
      final playerId = '${widget.match.id}-$letter';
      await playersBox.put(
        playerId,
        Player(
          id: playerId,
          name: _playerControllers[letter]!.text.trim(),
          equipe: _equipeUn,
          lettre: letter,
        ),
      );
    }

    for (final letter in team2Letters) {
      final playerId = '${widget.match.id}-$letter';
      await playersBox.put(
        playerId,
        Player(
          id: playerId,
          name: _playerControllers[letter]!.text.trim(),
          equipe: _equipeDeux,
          lettre: letter,
        ),
      );
    }

    final updatedMatch = Match(
      id: widget.match.id,
      equipeUn: _equipeUn,
      equipeDeux: _equipeDeux,
      date: _date,
      parties: widget.match.parties,
      type: widget.match.type,
      status: widget.match.status,
      competitionId: widget.match.competitionId,
    );

    await matchService.updateMatch(updatedMatch);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Widget _buildPlayerNameField(String letter) {
    return TextFormField(
      controller: _playerControllers[letter],
      decoration: InputDecoration(labelText: 'Joueur $letter'),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Veuillez entrer le nom du joueur $letter';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier la rencontre')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoadingPlayers
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _equipeUn,
                        decoration: const InputDecoration(labelText: 'Équipe 1'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nom de l\'équipe 1';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _equipeUn = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _equipeDeux,
                        decoration: const InputDecoration(labelText: 'Équipe 2'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nom de l\'équipe 2';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _equipeDeux = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Date: ${_date.day}/${_date.month}/${_date.year}'),
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null && pickedDate != _date) {
                                setState(() {
                                  _date = pickedDate;
                                });
                              }
                            },
                            child: const Text('Choisir une date'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Joueurs équipe 1',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      _buildPlayerNameField('A'),
                      _buildPlayerNameField('B'),
                      _buildPlayerNameField('C'),
                      _buildPlayerNameField('D'),
                      const SizedBox(height: 16),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Joueurs équipe 2',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      _buildPlayerNameField('W'),
                      _buildPlayerNameField('X'),
                      _buildPlayerNameField('Y'),
                      _buildPlayerNameField('Z'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveMatchAndPlayers,
                        child: const Text('Enregister et Mise à jour des joueurs'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
