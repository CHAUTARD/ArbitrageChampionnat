import 'package:flutter/material.dart';
import 'package:myapp/models/match.dart';

class PartieListScreen extends StatelessWidget {
  final Match match;

  const PartieListScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parties de la rencontre')),
      body: ListView.builder(
        itemCount: match.parties.length,
        itemBuilder: (context, index) {
          final partie = match.parties[index];
          return ListTile(
            title: Text('Partie ${index + 1}: ${partie.type}'),
            subtitle: Text('Score: ${partie.scoreEquipeUn} - ${partie.scoreEquipeDeux}'),
          );
        },
      ),
    );
  }
}
