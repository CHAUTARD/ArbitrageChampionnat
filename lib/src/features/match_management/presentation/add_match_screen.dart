// lib/src/features/match_management/presentation/add_match_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/equipe_model.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/src/features/team_management/application/team_service.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';

class AddMatchScreen extends StatefulWidget {
  const AddMatchScreen({super.key});

  @override
  State<AddMatchScreen> createState() => _AddMatchScreenState();
}

class _AddMatchScreenState extends State<AddMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  Equipe? _selectedEquipe1;
  Equipe? _selectedEquipe2;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final teamService = Provider.of<TeamService>(context);
    final teamsStream = teamService.getTeams();

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une rencontre')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              StreamBuilder<List<Equipe>>(
                stream: teamsStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final teams = snapshot.data!;
                  return DropdownButtonFormField<Equipe>(
                    decoration: const InputDecoration(labelText: 'Équipe 1'),
                    items: teams.map((equipe) {
                      return DropdownMenuItem(
                        value: equipe,
                        child: Text(equipe.nom),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEquipe1 = value;
                      });
                    },
                    validator: (value) => value == null
                        ? 'Veuillez sélectionner une équipe'
                        : null,
                  );
                },
              ),
              StreamBuilder<List<Equipe>>(
                stream: teamsStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final teams = snapshot.data!;
                  return DropdownButtonFormField<Equipe>(
                    decoration: const InputDecoration(labelText: 'Équipe 2'),
                    items: teams.map((equipe) {
                      return DropdownMenuItem(
                        value: equipe,
                        child: Text(equipe.nom),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEquipe2 = value;
                      });
                    },
                    validator: (value) => value == null
                        ? 'Veuillez sélectionner une équipe'
                        : null,
                  );
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
                    _formKey.currentState!.save();
                    if (_selectedEquipe1 != null && _selectedEquipe2 != null) {
                      final matchService = Provider.of<MatchService>(
                        context,
                        listen: false,
                      );
                      final newMatch = Match(
                        equipe1: _selectedEquipe1!,
                        equipe2: _selectedEquipe2!,
                        date: _selectedDate,
                      );
                      matchService.addMatch(newMatch);
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text('Ajouter une rencontre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
