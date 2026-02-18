// features/match_selection/partie_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/doubles_composition/double_composition_screen.dart';
import 'package:provider/provider.dart';

import 'package:myapp/src/features/match_selection/partie_card.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';

class MatchSelectionScreen extends StatelessWidget {
  const MatchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sélection des Parties',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Modification du nom des joueurs et composition des doubles
                  builder: (context) => const DoubleCompositionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<PartieProvider>(
        builder: (context, partieProvider, child) {
          if (partieProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (partieProvider.parties.isEmpty) {
            return const Center(
              child: Text(
                'Aucune partie trouvée.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => Future.value(null), // Handled by provider
            child: ListView.builder(
              itemCount: partieProvider.parties.length,
              itemBuilder: (context, index) {
                final partie = partieProvider.parties[index];
                return PartieCard(
                  partie: partie,
                  isPlayed: partie.isPlayed,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
