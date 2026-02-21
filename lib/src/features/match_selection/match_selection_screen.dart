// lib/src/features/match_selection/match_selection_screen.dart
//
// Écran principal affichant la liste des feuilles de rencontre.
// Permet de créer, de visualiser et de supprimer des rencontres.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/core/constants/app_constants.dart';
import 'package:myapp/src/features/rencontre/create_rencontre_screen.dart';
import 'package:myapp/src/features/rencontre/rencontre_detail_screen.dart';
import 'package:myapp/src/features/rencontre/rencontre_provider.dart';
import 'package:intl/intl.dart';

class MatchSelectionScreen extends ConsumerWidget {
  const MatchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rencontreState = ref.watch(rencontreProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feuilles de rencontre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateRencontreScreen(),
                ),
              );
            },
            tooltip: 'Créer une nouvelle feuille de rencontre',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(rencontreProvider.notifier).resetAndCreateDefault(),
            tooltip: 'Réinitialiser les données et créer une rencontre par défaut',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: rencontreState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: rencontreState.rencontres.length,
                    itemBuilder: (context, index) {
                      final rencontre = rencontreState.rencontres[index];
                      final formattedDate = DateFormat(
                        'dd/MM/yyyy',
                      ).format(rencontre.date);
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icon/Raquette.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                          title: Text(
                            '${rencontre.nomEquipe1} vs ${rencontre.nomEquipe2}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text('Match du $formattedDate'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteConfirmationDialog(
                                  context,
                                  ref,
                                  rencontre.rencontre.id,
                                ),
                                tooltip: 'Supprimer la rencontre',
                              ),
                              const Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RencontreDetailScreen(
                                  rencontreAvecEquipes: rencontre,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
          _buildCopyright(),
        ],
      ),
    );
  }

  Widget _buildCopyright() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            AppConstants.copyright,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Version ${AppConstants.appVersion}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    int rencontreId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la rencontre ?'),
        content: const Text(
          'Cette action est irréversible et supprimera toutes les données associées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(rencontreProvider.notifier).deleteRencontre(rencontreId);
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
