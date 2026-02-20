import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/partie_detail/partie_detail_screen.dart';
import 'package:myapp/src/features/rencontre/edit_rencontre_screen.dart';
import 'package:myapp/src/features/rencontre/rencontre_model.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart' as model;

class RencontreDetailScreen extends StatelessWidget {
  final RencontreAvecEquipes rencontreAvecEquipes;

  const RencontreDetailScreen({super.key, required this.rencontreAvecEquipes});

  @override
  Widget build(BuildContext context) {
    final partieProvider = Provider.of<PartieProvider>(context);
    final parties = partieProvider.getPartiesForRencontre(rencontreAvecEquipes.rencontre.id);
    parties.sort((a, b) => a.partie.partieNumber.compareTo(b.partie.partieNumber));

    final formattedDate = DateFormat('dd/MM/yyyy').format(rencontreAvecEquipes.date);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${rencontreAvecEquipes.nomEquipe1} vs ${rencontreAvecEquipes.nomEquipe2}'),
            Text('Le $formattedDate', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRencontreScreen(rencontre: rencontreAvecEquipes),
                ),
              );
            },
            tooltip: 'Modifier la feuille',
          ),
        ],
      ),
      body: partieProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: parties.length,
              itemBuilder: (context, index) {
                final partieDetails = parties[index];
                final isDouble = partieDetails.partie.joueur2Equipe1Id != null;

                String title;
                if (isDouble) {
                  title = 'Double: ${partieDetails.joueur1Equipe1Name ?? ''} & ${partieDetails.joueur2Equipe1Name ?? ''} vs ${partieDetails.joueur1Equipe2Name ?? ''} & ${partieDetails.joueur2Equipe2Name ?? ''}';
                } else {
                  title = 'Simple: ${partieDetails.joueur1Equipe1Name ?? ''} vs ${partieDetails.joueur1Equipe2Name ?? ''}';
                }

                String subtitle = 'Partie n°${partieDetails.partie.partieNumber}';
                if (!isDouble && partieDetails.arbitreName != null) {
                  subtitle += ' - Arbitre: ${partieDetails.arbitreName}';
                }

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(partieDetails.partie.partieNumber.toString()),
                    ),
                    title: Text(title),
                    subtitle: Text(subtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PartieDetailScreen(partie: partieDetails.partie as model.Partie),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
