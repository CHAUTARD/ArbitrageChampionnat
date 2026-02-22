import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
import 'package:myapp/models/player_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MancheTable extends StatefulWidget {
  const MancheTable({super.key});

  @override
  State<MancheTable> createState() => _MancheTableState();
}

class _MancheTableState extends State<MancheTable> {
  late Future<List<Player>> _playersFuture;

  @override
  void initState() {
    super.initState();
    _playersFuture = _loadPlayers();
  }

  Future<List<Player>> _loadPlayers() async {
    final String response =
        await rootBundle.loadString('assets/data/players.json');
    final data = await json.decode(response) as List;
    return data.map((player) => Player.fromJson(player)).toList();
  }

  Player _findPlayerById(List<Player> players, String id) {
    return players.firstWhere((player) => player.id == id,
        orElse: () => Player(id: '', name: 'Unknown', equipe: '', lettre: ''));
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final partie = gameState.partie;
    final scores = gameState.scores[gameState.currentManche];

    return FutureBuilder<List<Player>>(
      future: _playersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No players found.'));
        }

        final players = snapshot.data!;
        final team1Players = partie.team1PlayerIds
            .map((id) => _findPlayerById(players, id))
            .toList();
        final team2Players = partie.team2PlayerIds
            .map((id) => _findPlayerById(players, id))
            .toList();

        String getPlayerNames(List<Player> playerList) {
          if (playerList.isEmpty) return 'Composition incomplète';
          if (playerList.length == 1) return playerList.first.name;
          return '${playerList[0].name} & ${playerList[1].name}';
        }

        final team1Name = getPlayerNames(team1Players);
        final team2Name = getPlayerNames(team2Players);

        return Column(
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text('Équipe')),
                DataColumn(label: Text('Score')),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(team1Name)),
                    DataCell(Text(scores[0].toString())),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(team2Name)),
                    DataCell(Text(scores[1].toString())),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => gameState.incrementScore(0),
                  child: Text('+1 $team1Name'),
                ),
                ElevatedButton(
                  onPressed: () => gameState.incrementScore(1),
                  child: Text('+1 $team2Name'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
