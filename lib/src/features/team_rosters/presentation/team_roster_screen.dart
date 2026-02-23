import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/players/player_service.dart';

class TeamRosterScreen extends StatelessWidget {
  const TeamRosterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<PlayerService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Composition des équipes'),
      ),
      body: FutureBuilder<List<Player>>(
        future: playerService.getPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No players found.'));
          }

          final players = snapshot.data!;
          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return ListTile(
                title: Text(player.name),
                subtitle: Text(player.equipe),
              );
            },
          );
        },
      ),
    );
  }
}
