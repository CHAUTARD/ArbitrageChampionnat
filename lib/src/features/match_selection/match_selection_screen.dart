import 'package:flutter/material.dart';
import 'package:myapp/src/features/rencontre/create_rencontre_screen.dart'; // <-- AJOUT
import 'package:myapp/src/features/rencontre/rencontre_detail_screen.dart';
import 'package:myapp/src/features/rencontre/rencontre_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MatchSelectionScreen extends StatelessWidget {
  const MatchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rencontreProvider = Provider.of<RencontreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélection de la feuille de match'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateRencontreScreen()),
              );
            }, // <-- MODIFICATION
            tooltip: 'Nouvelle rencontre',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => rencontreProvider.resetAndCreateDefault(),
            tooltip: 'Réinitialiser les données',
          ),
        ],
      ),
      body: rencontreProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: rencontreProvider.rencontres.length,
              itemBuilder: (context, index) {
                final rencontre = rencontreProvider.rencontres[index];
                final formattedDate = DateFormat('dd/MM/yyyy').format(rencontre.date);
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.sports_tennis, size: 40),
                    title: Text('${rencontre.nomEquipe1} vs ${rencontre.nomEquipe2}'),
                    subtitle: Text('Match du $formattedDate'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _showDeleteConfirmationDialog(context, rencontreProvider, rencontre.rencontre.id),
                          tooltip: 'Supprimer la rencontre',
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RencontreDetailScreen(rencontreAvecEquipes: rencontre),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, RencontreProvider provider, int rencontreId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la rencontre ?'),
        content: const Text('Cette action est irréversible et supprimera toutes les données associées.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteRencontre(rencontreId);
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
