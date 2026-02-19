import 'package:flutter/material.dart';
import 'package:myapp/src/features/core/data/database.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/rencontre/rencontre_model.dart';
import 'package:provider/provider.dart';

class EditRencontreScreen extends StatefulWidget {
  final RencontreAvecEquipes rencontre;

  const EditRencontreScreen({super.key, required this.rencontre});

  @override
  State<EditRencontreScreen> createState() => _EditRencontreScreenState();
}

class _EditRencontreScreenState extends State<EditRencontreScreen> {
  final _formKey = GlobalKey<FormState>();
  late Future<Map<String, List<Player>>> _playersFuture;
  final Map<int, TextEditingController> _playerControllers = {};

  @override
  void initState() {
    super.initState();
    final partieProvider = Provider.of<PartieProvider>(context, listen: false);
    _playersFuture = partieProvider.getPlayersForRencontre(widget.rencontre.rencontre.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier ${widget.rencontre.nomEquipe1} vs ${widget.rencontre.nomEquipe2}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () { /* TODO: Implement save logic */ },
            tooltip: 'Enregistrer',
          ),
        ],
      ),
      body: FutureBuilder<Map<String, List<Player>>>(
        future: _playersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!['equipe1']!.isEmpty) {
            return const Center(child: Text('Aucun joueur trouvé.'));
          }

          final equipe1Players = snapshot.data!['equipe1']!..sort((a, b) => a.id.compareTo(b.id));
          final equipe2Players = snapshot.data!['equipe2']!..sort((a, b) => a.id.compareTo(b.id));

          _initializeControllers(equipe1Players + equipe2Players);

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(widget.rencontre.nomEquipe1, style: Theme.of(context).textTheme.titleLarge),
                ...equipe1Players.map((p) => _buildPlayerTextField(p)),
                const SizedBox(height: 24),
                Text(widget.rencontre.nomEquipe2, style: Theme.of(context).textTheme.titleLarge),
                ...equipe2Players.map((p) => _buildPlayerTextField(p)),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () { /* TODO: Implement save logic */ },
                  child: const Text('Enregistrer les modifications'),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _initializeControllers(List<Player> players) {
    for (final player in players) {
      if (!_playerControllers.containsKey(player.id)) {
        _playerControllers[player.id] = TextEditingController(text: player.name);
      }
    }
  }

  Widget _buildPlayerTextField(Player player) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        controller: _playerControllers[player.id],
        decoration: InputDecoration(labelText: 'Joueur ${player.id}'), // Temporary label
        validator: (value) => value!.isEmpty ? 'Nom requis' : null,
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _playerControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
