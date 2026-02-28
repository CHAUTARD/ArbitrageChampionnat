// Path: lib/src/features/scoring/table_screen.dart

// Rôle: Aiguille vers l'écran de table de jeu approprié (simple ou double).
// Ce widget agit comme un routeur.
// En fonction du nombre de joueurs dans la `Partie` (un ou deux par équipe), 
// il charge les données des joueurs depuis Hive, puis affiche soit `SimpleTableScreen` pour les matchs en simple, 
// soit `DoubleTableScreen` pour les matchs en double.

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/scoring_screen.dart';
// simple_table_screen is no longer used for navigation (placeholder only)

class TableScreen extends StatefulWidget {
  final Partie partie;

  const TableScreen({super.key, required this.partie});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
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
      orElse: () => Player(id: '', name: 'Unknown', equipe: '', lettre: ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Player>>(
      future: _playersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(body: Center(child: Text('No players found.')));
        }

        final players = snapshot.data!;
        final team1Players = widget.partie.team1PlayerIds
            .map((id) => _findPlayerById(players, id))
            .toList();
        final team2Players = widget.partie.team2PlayerIds
            .map((id) => _findPlayerById(players, id))
            .toList();
        final String arbitreName = widget.partie.arbitreId == null
          ? ''
          : _findPlayerById(players, widget.partie.arbitreId!).name;

        final isDouble = widget.partie.team1PlayerIds.length == 2;
        if (isDouble) {
          /*
          @TODO: Implement DoubleTableScreen and replace ScoringScreen with it for double matches.
          
          return DoubleTableScreen(
            partie: widget.partie,
            team1: team1Players,
            team2: team2Players,
          );
          */
          return ScoringScreen(
            partie: widget.partie,
            team1Players: team1Players,
            team2Players: team2Players,
            arbitreName: arbitreName,
          );
        } else {
          // for a simple game we go directly to the scoring UI
          return ScoringScreen(
            partie: widget.partie,
            team1Players: team1Players,
            team2Players: team2Players,
            arbitreName: arbitreName,
          );
        }
      },
    );
  }
}
