// features/table/double_table_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/src/features/scoring/scoring_screen.dart';

class DoubleTableScreen extends StatelessWidget {
  final Partie partie;

  const DoubleTableScreen({super.key, required this.partie});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${partie.equipeUnId} vs ${partie.equipeDeuxId}'),
          bottom: const TabBar(tabs: [Tab(text: 'Tableau des scores')]),
        ),
        body: TabBarView(children: [ScoringScreen(partie: partie)]),
      ),
    );
  }
}
