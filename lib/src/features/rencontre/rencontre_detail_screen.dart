// lib/src/features/rencontre/rencontre_detail_screen.dart
//
// Écran affichant les détails d'une rencontre, y compris la liste des parties.
// Permet de naviguer vers les détails de chaque partie et de modifier ou supprimer la rencontre.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/partie_detail/partie_detail_screen.dart';
import 'package:myapp/src/features/rencontre/edit_rencontre_screen.dart';
import 'package:myapp/src/features/rencontre/rencontre_model.dart';
import 'package:myapp/src/features/rencontre/rencontre_provider.dart';

class RencontreDetailScreen extends ConsumerStatefulWidget {
  final RencontreAvecEquipes rencontreAvecEquipes;

  const RencontreDetailScreen({super.key, required this.rencontreAvecEquipes});

  @override
  ConsumerState<RencontreDetailScreen> createState() =>
      _RencontreDetailScreenState();
}

class _RencontreDetailScreenState extends ConsumerState<RencontreDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(partieProvider.notifier)
        .getPartiesForRencontre(widget.rencontreAvecEquipes.rencontre.id));
  }

  Future<void> _deleteRencontre() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
              'Êtes-vous sûr de vouloir supprimer cette rencontre ? Cette action est irréversible.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await ref
          .read(rencontreProvider.notifier)
          .deleteRencontre(widget.rencontreAvecEquipes.rencontre.id);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final partiesUnsorted = ref.watch(partieProvider);
    final parties = [...partiesUnsorted]
      ..sort((a, b) => a.numeroPartie.compareTo(b.numeroPartie));

    final formattedDate =
        DateFormat('dd/MM/yyyy').format(widget.rencontreAvecEquipes.date);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${widget.rencontreAvecEquipes.nomEquipe1} vs ${widget.rencontreAvecEquipes.nomEquipe2}'),
            Text('Le $formattedDate',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditRencontreScreen(rencontre: widget.rencontreAvecEquipes),
                ),
              );
            },
            tooltip: 'Modifier la feuille',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteRencontre,
            tooltip: 'Supprimer la rencontre',
          ),
        ],
      ),
      body: parties.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: parties.length,
              itemBuilder: (context, index) {
                final partieDetails = parties[index];
                final isDouble =
                    partieDetails.team1Players.length > 1 &&
                        partieDetails.team2Players.length > 1;

                String title;
                if (isDouble) {
                  title =
                      'Double: ${partieDetails.team1Players[0].name} & ${partieDetails.team1Players[1].name} vs ${partieDetails.team2Players[0].name} & ${partieDetails.team2Players[1].name}';
                } else {
                  title =
                      'Simple: ${partieDetails.team1Players[0].name} vs ${partieDetails.team2Players[0].name}';
                }

                String subtitle = 'Partie n°${partieDetails.numeroPartie}';
                if (!isDouble && partieDetails.arbitreName != null) {
                  subtitle += ' - Arbitre: ${partieDetails.arbitreName}';
                }

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(partieDetails.numeroPartie.toString()),
                    ),
                    title: Text(title),
                    subtitle: Text(subtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PartieDetailScreen(partie: partieDetails),
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
