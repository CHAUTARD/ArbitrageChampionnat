import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';
import 'package:myapp/src/features/player_entry/player_entry_screen.dart';

class AddMatchScreen extends StatefulWidget {
  const AddMatchScreen({super.key});

  @override
  State<AddMatchScreen> createState() => _AddMatchScreenState();
}

class _AddMatchScreenState extends State<AddMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _equipe1Controller = TextEditingController();
  final _equipe2Controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _equipe1Controller.dispose();
    _equipe2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une rencontre')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _equipe1Controller,
                decoration: const InputDecoration(labelText: 'Équipe 1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom de l\'équipe 1';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _equipe2Controller,
                decoration: const InputDecoration(labelText: 'Équipe 2'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom de l\'équipe 2';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text('Date : ${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                    locale: const Locale('fr', 'FR'),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final matchService = Provider.of<MatchService>(
                      context,
                      listen: false,
                    );
                    final newMatch = Match(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: 'Championnat',
                      status: 'A venir',
                      date: _selectedDate,
                      parties: [],
                      competitionId: 'your_competition_id', // Replace with actual competition ID
                      equipeUn: _equipe1Controller.text,
                      equipeDeux: _equipe2Controller.text,
                    );
                    matchService.addMatch(newMatch);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerEntryScreen(match: newMatch),
                      ),
                    );
                  }
                },
                child: const Text('Ajouter et saisir les joueurs'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
