import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/partie_detail/partie_detail_screen.dart';
import 'package:myapp/src/features/rencontre/edit_rencontre_screen.dart';
import 'package:myapp/src/features/rencontre/rencontre_model.dart';
import 'package:provider/provider.dart';

class RencontreDetailScreen extends StatelessWidget {
  final RencontreAvecEquipes rencontreAvecEquipes;

  const RencontreDetailScreen({super.key, required this.rencontreAvecEquipes});

  @override
  Widget build(BuildContext context) {
    final partieProvider = Provider.of<PartieProvider>(context);
    final parties = partieProvider.getPartiesForRencontre(rencontreAvecEquipes.rencontre.id);
    parties.sort((a, b) => a.numeroPartie.compareTo(b.numeroPartie));

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
                final partie = parties[index];
                final isDouble = partie.team1Players.length > 1;

                String title = isDouble
                    ? 'Double: ${partie.team1Players[0].name} & ${partie.team1Players[1].name} vs ${partie.team2Players[0].name} & ${partie.team2Players[1].name}'
                    : 'Simple: ${partie.team1Players[0].name} vs ${partie.team2Players[0].name}';

                String subtitle = 'Partie n°${partie.numeroPartie}';
                if (!isDouble && partie.arbitreName != null) {
                  subtitle += ' - Arbitre: ${partie.arbitreName}';
                }

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(partie.numeroPartie.toString()),
                    ),
                    title: Text(title),
                    subtitle: Text(subtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PartieDetailScreen(partie: partie),
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
