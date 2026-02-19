import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/partie_detail/manche_provider.dart';
import 'package:provider/provider.dart';

class PartieDetailScreen extends StatefulWidget {
  final Partie partie;

  const PartieDetailScreen({super.key, required this.partie});

  @override
  State<PartieDetailScreen> createState() => _PartieDetailScreenState();
}

class _PartieDetailScreenState extends State<PartieDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les manches au démarrage de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MancheProvider>(context, listen: false)
          .loadManches(int.parse(widget.partie.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final mancheProvider = Provider.of<MancheProvider>(context);
    final partie = widget.partie;
    final isDouble = partie.team1Players.length > 1;

    String title = isDouble
        ? '${partie.team1Players[0].name} & ${partie.team1Players[1].name} \nvs\n ${partie.team2Players[0].name} & ${partie.team2Players[1].name}'
        : '${partie.team1Players[0].name} vs ${partie.team2Players[0].name}';

    return Scaffold(
      appBar: AppBar(
        title: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
      ),
      body: mancheProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: mancheProvider.manches.length,
                    itemBuilder: (context, index) {
                      final manche = mancheProvider.manches[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text(manche.numeroManche.toString())),
                        title: Text('Score: ${manche.scoreTeam1} - ${manche.scoreTeam2}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditScoreDialog(manche),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Ajouter une manche'),
                    onPressed: () => _showAddMancheDialog(),
                  ),
                )
              ],
            ),
    );
  }

  void _showAddMancheDialog() {
    final score1Controller = TextEditingController();
    final score2Controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle manche'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: score1Controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Score Équipe 1')),
            TextField(controller: score2Controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Score Équipe 2')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              final score1 = int.parse(score1Controller.text);
              final score2 = int.parse(score2Controller.text);
              final mancheProvider = Provider.of<MancheProvider>(context, listen: false);
              mancheProvider.addManche(int.parse(widget.partie.id), mancheProvider.manches.length + 1, score1, score2);
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

    void _showEditScoreDialog(manche) {
    final score1Controller = TextEditingController(text: manche.scoreTeam1.toString());
    final score2Controller = TextEditingController(text: manche.scoreTeam2.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier Manche ${manche.numeroManche}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: score1Controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Score Équipe 1')),
            TextField(controller: score2Controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Score Équipe 2')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              manche.scoreTeam1 = int.parse(score1Controller.text);
              manche.scoreTeam2 = int.parse(score2Controller.text);
              Provider.of<MancheProvider>(context, listen: false).updateManche(manche);
              Navigator.pop(context);
            },
            child: const Text('Mettre à jour'),
          ),
        ],
      ),
    );
  }
}
