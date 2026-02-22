// lib/src/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/src/features/match_management/presentation/match_list_screen.dart';
import 'package:myapp/src/features/team_management/presentation/team_management_screen.dart';
import 'package:myapp/src/features/match_selection/match_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final matchService = Provider.of<MatchService>(context);
    final matchesStream = matchService.getMatches();

    return Scaffold(
      appBar: AppBar(title: const Text('Arbitrage championnat')),
      body: StreamBuilder<List<Match>>(
        stream: matchesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun match trouvé.'));
          }

          final matches = snapshot.data!;
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return MatchCard(match: matches[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MatchListScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeamManagementScreen(),
                  ),
                );
              },
              child: const Text('Equipes'),
            ),
            const Text('© 2026 Patrick CHAUTARD'),
          ],
        ),
      ),
    );
  }
}
