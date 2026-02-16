
// lib/src/features/match_selection/team_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:myapp/src/features/match_selection/team_model.dart'; // Assurez-vous que ce modèle existe

class TeamProvider with ChangeNotifier {
  List<Team> _teams = [];
  bool _isLoading = true;

  List<Team> get teams => _teams;
  List<Player> get players => _teams.expand((team) => team.players).toList();
  bool get isLoading => _isLoading;

  TeamProvider() {
    loadTeams();
  }

  Future<void> loadTeams() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/players.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<dynamic> teamsJson = data['teams'];

      _teams = teamsJson.map((teamJson) {
        final List<dynamic> playersJson = teamJson['players'];
        final players = playersJson.map((playerJson) {
          final name = playerJson['nom'] as String;
          final letter = playerJson['lettre'] as String;
          return Player(id: letter, name: name, letter: letter);
        }).toList();
        return Team(name: teamJson['nom'], players: players);
      }).toList();

    } catch (e) {
      if (kDebugMode) {
        print('Error loading teams: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updatePlayerName(String playerId, String newName) {
    for (var team in _teams) {
      final playerIndex = team.players.indexWhere((p) => p.id == playerId);
      if (playerIndex != -1) {
        team.players[playerIndex].name = newName;
        notifyListeners();
        return;
      }
    }
  }
}
