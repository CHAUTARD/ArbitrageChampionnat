import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/equipe_model.dart';
import 'package:myapp/src/features/team_management/application/team_service.dart';

class AddTeamScreen extends StatefulWidget {
  const AddTeamScreen({super.key});

  @override
  State<AddTeamScreen> createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends State<AddTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  String _teamName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une équipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom de l\'équipe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'équipe';
                  }
                  return null;
                },
                onSaved: (value) {
                  _teamName = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final teamService = Provider.of<TeamService>(context, listen: false);
                    final newTeam = Equipe(nom: _teamName, joueurs: []);
                    teamService.addTeam(newTeam);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Ajouter l\'équipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
