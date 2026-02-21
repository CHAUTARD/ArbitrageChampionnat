import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';
import 'package:myapp/models/match.dart';

class AddMatchScreen extends ConsumerStatefulWidget {
  const AddMatchScreen({super.key});

  @override
  ConsumerState<AddMatchScreen> createState() => AddMatchScreenState();
}

class AddMatchScreenState extends ConsumerState<AddMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();
  final _score1Controller = TextEditingController();
  final _score2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Match')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _player1Controller,
                decoration: const InputDecoration(labelText: 'Player 1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a player name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _player2Controller,
                decoration: const InputDecoration(labelText: 'Player 2'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a player name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _score1Controller,
                decoration: const InputDecoration(labelText: 'Score 1'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _score2Controller,
                decoration: const InputDecoration(labelText: 'Score 2'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final match = Match(
                      player1: _player1Controller.text,
                      player2: _player2Controller.text,
                      score1: int.tryParse(_score1Controller.text) ?? 0,
                      score2: int.tryParse(_score2Controller.text) ?? 0,
                      date: DateTime.now(),
                    );
                    ref.read(matchServiceProvider).addMatch(match);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Match'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
