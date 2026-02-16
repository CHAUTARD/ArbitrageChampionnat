// lib/src/features/match_selection/partie_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/table/table_screen.dart';
import 'package:provider/provider.dart';

class PartieSelectionScreen extends StatelessWidget {
  const PartieSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parties = Provider.of<PartieProvider>(context).parties;
    final isLoading = Provider.of<PartieProvider>(context).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélection de la partie'),
        backgroundColor: Colors.blue[800],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: parties.length,
              itemBuilder: (context, index) {
                final partie = parties[index];
                final bool isDouble = partie.team1Players.length > 1;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isDouble ? Colors.orangeAccent : Colors.blueAccent,
                      child: Text('${partie.numero}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(partie.name, style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text(isDouble ? 'Double' : 'Simple'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
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
