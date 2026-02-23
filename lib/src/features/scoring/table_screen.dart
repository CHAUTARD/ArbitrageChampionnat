import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/table/double_table_screen.dart';
import 'package:myapp/src/features/table/simple_table_screen.dart';

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
    final String response = await rootBundle.loadString('assets/data/players.json');
    final data = await json.decode(response) as List;
    return data.map((player) => Player.fromJson(player)).toList();
  }

  Player _findPlayerById(List<Player> players, String id) {
    return players.firstWhere((player) => player.id == id,
        orElse: () => Player(id: '', name: 'Unknown', equipe: '', lettre: ''));
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
          return const Scaffold(
            body: Center(child: Text('No players found.')),
          );
        }

        final players = snapshot.data!;
        final team1Players = widget.partie.team1PlayerIds
            .map((id) => _findPlayerById(players, id))
            .toList();
        final team2Players = widget.partie.team2PlayerIds
            .map((id) => _findPlayerById(players, id))
            .toList();
        final arbitre = widget.partie.arbitreId != null
            ? _findPlayerById(players, widget.partie.arbitreId!)
            : null;

        // Correction: Utiliser la taille de la liste des joueurs pour déterminer le type de partie
        final isDouble = widget.partie.team1PlayerIds.length == 2;
        return isDouble
            ? DoubleTableScreen(
                partie: widget.partie,
                team1Players: team1Players,
                team2Players: team2Players,
              )
            : SimpleTableScreen(
                partie: widget.partie,
                joueurUn: team1Players.first,
                joueurDeux: team2Players.first,
                arbitre: arbitre,
              );
      },
    );
  }
}
