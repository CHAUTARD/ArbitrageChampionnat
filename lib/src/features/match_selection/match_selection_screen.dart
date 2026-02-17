import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:myapp/src/features/match_selection/partie_card.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';

class MatchSelectionScreen extends StatelessWidget {
  const MatchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sélection des Parties',
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        centerTitle: true,
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
                return PartieCard(partie: partieProvider.parties[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
