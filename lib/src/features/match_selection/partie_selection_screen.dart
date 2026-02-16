// features/match_selection/partie_selection_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/features/doubles_composition/double_composition_screen.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:myapp/src/features/table/table_screen.dart';
import 'package:provider/provider.dart';

class PartieSelectionScreen extends StatelessWidget {
  const PartieSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parties = Provider.of<PartieProvider>(context).parties;
    final isLoading = Provider.of<PartieProvider>(context).isLoading;

    if (kDebugMode) {
      print(
          'PartieSelectionScreen: Reconstruit avec isLoading: $isLoading et ${parties.length} parties.');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélection de la partie'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.group_work),
            tooltip: 'Composition des doubles',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DoubleCompositionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : parties.isEmpty
              ? const Center(
                  child: Text(
                    'Aucune partie à afficher.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: parties.length,
                  itemBuilder: (context, index) {
                    final partie = parties[index];
                    final bool isDouble = partie.team1Players.length > 1;

                    String subtitleText;
                    if (isDouble) {
                      final team1 = partie.team1Players.map((p) => p.name).join(' & ');
                      final team2 = partie.team2Players.map((p) => p.name).join(' & ');
                      subtitleText = '$team1 vs $team2';
                    } else {
                      final player1 = partie.team1Players.isNotEmpty ? partie.team1Players[0].name : '';
                      final player2 = partie.team2Players.isNotEmpty ? partie.team2Players[0].name : '';
                      subtitleText = '$player1 vs $player2';
                      if (partie.arbitre != null) {
                        subtitleText += '\nArbitre: ${partie.arbitre!.name}';
                      }
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        isThreeLine: !isDouble && partie.arbitre != null || isDouble,
                        leading: CircleAvatar(
                          backgroundColor:
                              isDouble ? Colors.orangeAccent : Colors.blueAccent,
                          child: Text('${partie.numero}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        title: Text(partie.name,
                            style: Theme.of(context).textTheme.titleMedium),
                        subtitle: Text(subtitleText),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Initialise le match dans le MatchProvider
                          Provider.of<MatchProvider>(context, listen: false).startMatch(partie);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TableScreen(
                                partie: partie,
                              ),
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
