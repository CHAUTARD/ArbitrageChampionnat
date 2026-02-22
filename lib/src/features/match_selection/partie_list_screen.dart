import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/doubles_composition/double_composition_screen.dart';
import 'package:myapp/src/features/match_selection/partie_card.dart';
import 'package:myapp/src/features/scoring/table_screen.dart';

class PartieListScreen extends StatefulWidget {
  final Match match;

  const PartieListScreen({super.key, required this.match});

  @override
  State<PartieListScreen> createState() => _PartieListScreenState();
}

class _PartieListScreenState extends State<PartieListScreen> {
  late Future<List<Player>> _playersFuture;

  @override
  void initState() {
    super.initState();
    _playersFuture = _loadPlayers();
  }

  Future<List<Player>> _loadPlayers() async {
    final box = await Hive.openBox<Player>('players');
    return box.values.toList();
  }

  Player _findPlayerById(List<Player> players, String id) {
    return players.firstWhere(
      (player) => player.id == id,
      orElse: () => Player(id: '', name: 'Non assigné', equipe: '', lettre: ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feuille de match')), // Changed title
      body: FutureBuilder<List<Player>>(
        future: _playersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun joueur trouvé.'));
          }

          final players = snapshot.data!;
          return ListView.builder(
            itemCount: widget.match.parties.length,
            itemBuilder: (context, index) {
              final partie = widget.match.parties[index];
              final team1Players = partie.team1PlayerIds
                  .map((id) => _findPlayerById(players, id))
                  .toList();
              final team2Players = partie.team2PlayerIds
                  .map((id) => _findPlayerById(players, id))
                  .toList();
              final arbitre = partie.arbitreId != null
                  ? _findPlayerById(players, partie.arbitreId!)
                  : null;

              return PartieCard(
                partie: partie,
                team1Players: team1Players,
                team2Players: team2Players,
                arbitre: arbitre,
                onTap: () async {
                  if (partie.type == 'Double') {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoubleCompositionScreen(
                          partie: partie,
                          match: widget.match, // Pass the match object
                        ),
                      ),
                    );
                    if (result == true) {
                      // Refresh the list only if changes were saved
                      setState(() {
                        _playersFuture = _loadPlayers();
                      });
                    }
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TableScreen(partie: partie),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
