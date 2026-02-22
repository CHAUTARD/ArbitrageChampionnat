import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/equipe_model.dart';
import 'package:myapp/src/features/team_management/application/team_service.dart';

class EditTeamScreen extends StatefulWidget {
  final Equipe team;

  const EditTeamScreen({super.key, required this.team});

  @override
  State<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends State<EditTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _teamName;

  @override
  void initState() {
    super.initState();
    _teamName = widget.team.nom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'équipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _teamName,
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
                    final updatedTeam = Equipe(
                      id: widget.team.id,
                      nom: _teamName,
                      joueurs: widget.team.joueurs,
                    );
                    context.read<TeamService>().updateTeam(updatedTeam);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Mettre à jour l\'équipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
