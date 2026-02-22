import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';
import 'package:myapp/src/features/match_management/presentation/add_match_screen.dart';

class MatchListScreen extends StatelessWidget {
  const MatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final matchService = Provider.of<MatchService>(context);
    final matchesStream = matchService.getMatches();

    return Scaffold(
      appBar: AppBar(title: const Text('Liste des rencontres')),
      body: StreamBuilder<List<Match>>(
        stream: matchesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune rencontre pour le moment.'));
          }

          final matches = snapshot.data!;

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return ListTile(
                title: Text('${match.equipe1.nom} vs ${match.equipe2.nom}'),
                subtitle: Text(
                  'Le ${match.date.day}/${match.date.month}/${match.date.year}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    matchService.deleteMatch(match.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddMatchScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
