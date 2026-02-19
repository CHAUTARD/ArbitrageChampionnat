// features/table/double_table_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/doubles_composition/double_composition_screen.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/scoring/scoring_screen.dart';

class DoubleTableScreen extends StatelessWidget {
  final Partie partie;

  const DoubleTableScreen({super.key, required this.partie});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Partie de Double'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tableau des scores'),
              Tab(text: 'Composition des équipes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ScoringScreen(partie: partie),
            DoublesCompositionScreen(partie: partie),
          ],
        ),
      ),
    );
  }
}
