import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/src/core/constants/app_constants.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';
import 'package:myapp/src/features/match_management/presentation/add_match_screen.dart';
import 'package:myapp/src/features/match_management/presentation/edit_match_screen.dart';
import 'package:myapp/src/features/match_selection/partie_list_screen.dart';
import 'package:myapp/src/features/settings/settings_screen.dart';

class MatchListScreen extends StatelessWidget {
  const MatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final matchService = Provider.of<MatchService>(context);
    final matchesStream = matchService.getMatches();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des rencontres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Paramètres',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Match>>(
        stream: matchesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucune rencontre pour le moment.'),
            );
          }

          final matches = snapshot.data!;

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return ListTile(
                title: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(text: match.equipeUn),
                      TextSpan(
                        text: ' vs ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      TextSpan(text: match.equipeDeux),
                    ],
                  ),
                ),
                subtitle: Text(
                  'Le ${DateFormat.yMMMMEEEEd('fr_FR').format(match.date)}',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PartieListScreen(match: match),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditMatchScreen(match: match),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmer la suppression'),
                            content: const Text(
                                'Voulez-vous vraiment supprimer cette rencontre ?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Supprimer'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          matchService.deleteMatch(match.id);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddMatchScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          alignment: Alignment.center,
          child: const Text(
            AppConstants.copyright,
            style: TextStyle(fontSize: 12.0),
          ),
        ),
      ),
    );
  }
}
