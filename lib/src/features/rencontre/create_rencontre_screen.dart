import 'package:flutter/material.dart';
import 'package:myapp/src/features/rencontre/rencontre_provider.dart';
import 'package:provider/provider.dart';

class CreateRencontreScreen extends StatefulWidget {
  const CreateRencontreScreen({super.key});

  @override
  State<CreateRencontreScreen> createState() => _CreateRencontreScreenState();
}

class _CreateRencontreScreenState extends State<CreateRencontreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _equipe1Controller = TextEditingController();
  final _equipe2Controller = TextEditingController();
  final _joueurA1Controller = TextEditingController(text: 'Joueur A1');
  final _joueurA2Controller = TextEditingController(text: 'Joueur A2');
  final _joueurA3Controller = TextEditingController(text: 'Joueur A3');
  final _joueurA4Controller = TextEditingController(text: 'Joueur A4');
  final _joueurB1Controller = TextEditingController(text: 'Joueur B1');
  final _joueurB2Controller = TextEditingController(text: 'Joueur B2');
  final _joueurB3Controller = TextEditingController(text: 'Joueur B3');
  final _joueurB4Controller = TextEditingController(text: 'Joueur B4');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Rencontre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _equipe1Controller,
                decoration: const InputDecoration(labelText: 'Nom de l\'équipe 1'),
                validator: (value) => value!.isEmpty ? 'Nom requis' : null,
              ),
              TextFormField(
                controller: _equipe2Controller,
                decoration: const InputDecoration(labelText: 'Nom de l\'équipe 2'),
                validator: (value) => value!.isEmpty ? 'Nom requis' : null,
              ),
              const SizedBox(height: 24),
              Text('Joueurs de l\'équipe 1', style: Theme.of(context).textTheme.titleLarge),
              _buildPlayerTextField(_joueurA1Controller, 'Joueur 1'),
              _buildPlayerTextField(_joueurA2Controller, 'Joueur 2'),
              _buildPlayerTextField(_joueurA3Controller, 'Joueur 3'),
              _buildPlayerTextField(_joueurA4Controller, 'Joueur 4'),
              const SizedBox(height: 24),
              Text('Joueurs de l\'équipe 2', style: Theme.of(context).textTheme.titleLarge),
              _buildPlayerTextField(_joueurB1Controller, 'Joueur 1'),
              _buildPlayerTextField(_joueurB2Controller, 'Joueur 2'),
              _buildPlayerTextField(_joueurB3Controller, 'Joueur 3'),
              _buildPlayerTextField(_joueurB4Controller, 'Joueur 4'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _createRencontre,
                child: const Text('Créer la rencontre'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) => value!.isEmpty ? 'Nom du joueur requis' : null,
      ),
    );
  }

  void _createRencontre() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<RencontreProvider>(context, listen: false);
      final playerNames = {
        'A1': _joueurA1Controller.text,
        'A2': _joueurA2Controller.text,
        'A3': _joueurA3Controller.text,
        'A4': _joueurA4Controller.text,
        'B1': _joueurB1Controller.text,
        'B2': _joueurB2Controller.text,
        'B3': _joueurB3Controller.text,
        'B4': _joueurB4Controller.text,
      };

      await provider.createNewRencontre(
        _equipe1Controller.text,
        _equipe2Controller.text,
        playerNames,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _equipe1Controller.dispose();
    _equipe2Controller.dispose();
    _joueurA1Controller.dispose();
    _joueurA2Controller.dispose();
    _joueurA3Controller.dispose();
    _joueurA4Controller.dispose();
    _joueurB1Controller.dispose();
    _joueurB2Controller.dispose();
    _joueurB3Controller.dispose();
    _joueurB4Controller.dispose();
    super.dispose();
  }
}
