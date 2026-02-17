import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:myapp/src/features/match_selection/team_model.dart';

class TeamProvider with ChangeNotifier {
  List<Team> _teams = [];
  bool _isLoading = true;

  List<Team> get teams => _teams;
  bool get isLoading => _isLoading;

  List<Player> get equipe1 => _teams.isNotEmpty ? _teams[0].players : [];
  List<Player> get equipe2 => _teams.length > 1 ? _teams[1].players : [];

  List<Player> get allPlayers => _teams.expand((team) => team.players).toList();

  TeamProvider() {
    // Schedule loadTeams to run after the current build cycle is complete.
    // This prevents the "setState() or markNeedsBuild() called during build" error.
    Future.microtask(() => loadTeams());
  }

  Future<void> loadTeams() async {
    // Set loading state without notifying, as the change will be picked up
    // in the next frame after this microtask is run.
    _isLoading = true;

    try {
      final playersJsonString =
          await rootBundle.loadString('assets/database/players.json');
      final playersData = json.decode(playersJsonString) as List;
      final allPlayersList = playersData.asMap().entries.map((entry) {
        int idx = entry.key;
        var playerData = entry.value;
        return Player(
          id: playerData['id'] as int? ?? idx,
          name: playerData['name'],
          letter: playerData['letter'],
        );
      }).toList();

      final teamsJsonString =
          await rootBundle.loadString('assets/database/teams.json');
      final teamsData = json.decode(teamsJsonString) as List;

      _teams = teamsData.map((teamData) {
        List<Player> teamPlayers = (teamData['players'] as List)
            .map((playerId) =>
                allPlayersList.firstWhere((p) => p.id == playerId, orElse: () {
                  throw Exception('Player with id $playerId not found');
                }))
            .toList();
        return Team(name: teamData['name'], players: teamPlayers);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load teams: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updatePlayerName(int playerId, String newName) {
    for (var team in _teams) {
      final playerIndex = team.players.indexWhere((p) => p.id == playerId);
      if (playerIndex != -1) {
        final oldPlayer = team.players[playerIndex];
        final updatedPlayer = Player(
          id: oldPlayer.id,
          name: newName,
          letter: oldPlayer.letter,
        );
        team.players[playerIndex] = updatedPlayer;
        notifyListeners();
        return;
      }
    }
  }
}
