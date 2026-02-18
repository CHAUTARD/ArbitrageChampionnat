// feature/match_selection/partie_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';

class PartieProvider with ChangeNotifier {
  List<Partie> _parties = [];
  bool _isLoading = true;

  List<Player> _allPlayers = [];
  List<Player> get allPlayers => _allPlayers;

  List<Player> get equipe1 => _allPlayers.length >= 4 ? _allPlayers.sublist(0, 4) : [];
  List<Player> get equipe2 => _allPlayers.length >= 8 ? _allPlayers.sublist(4, 8) : [];

  List<Partie> get parties => _parties;
  bool get isLoading => _isLoading;

  PartieProvider() {
    _loadParties();
  }

  Future<void> _loadParties() async {
    _isLoading = true;
    notifyListeners();

    try {
      final playersJsonString = await rootBundle.loadString('assets/data/players.json');
      final playersJson = json.decode(playersJsonString) as List;
      _allPlayers = playersJson.map((playerJson) => Player.fromJson(playerJson)).toList();

      final partiesJsonString = await rootBundle.loadString('assets/data/parties.json');
      final partiesJson = json.decode(partiesJsonString) as List;
      _parties = partiesJson.map((partieJson) => Partie.fromJson(partieJson, _allPlayers)).toList();

      await _loadMatchResults();

    } catch (e) {
      if (kDebugMode) {
        print("Error loading parties: $e");
      }
      _parties = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadMatchResults() async {
    try {
      final resultsJsonString = await rootBundle.loadString('assets/data/match_results.json');
      final resultsJson = json.decode(resultsJsonString) as List;

      for (var result in resultsJson) {
        final partie = _parties.firstWhere((p) => p.id == result['id']);
        partie.isPlayed = result['isPlayed'];
        partie.score = result['score'];
        partie.winner = result['winner'];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading match results: $e");
      }
    }
  }

  Future<void> saveMatchResult(Partie partie) async {
    try {
      final resultsJsonString = await rootBundle.loadString('assets/data/match_results.json');
      final resultsJson = json.decode(resultsJsonString) as List;

      resultsJson.removeWhere((r) => r['id'] == partie.id);
      resultsJson.add({
        'id': partie.id,
        'isPlayed': partie.isPlayed,
        'score': partie.score,
        'winner': partie.winner,
      });

      // This is not a good practice to write directly to the assets folder.
      // In a real application, you should use a proper storage solution.
      // For this example, we will just print the JSON to the console.
      if (kDebugMode) {
        print(json.encode(resultsJson));
      }

    } catch (e) {
      if (kDebugMode) {
        print("Error saving match result: $e");
      }
    }
  }

  void updatePlayerName(String playerId, String newName) {
    final playerIndex = _allPlayers.indexWhere((p) => p.id == playerId);
    if (playerIndex != -1) {
      _allPlayers[playerIndex].name = newName;
      notifyListeners();
    }
  }

  void updateDoublesComposition(
      List<Player> team1Double1, List<Player> team2Double1) {
    final allTeam1Players = equipe1;
    final allTeam2Players = equipe2;

    final team1Double2 =
        allTeam1Players.where((p) => !team1Double1.contains(p)).toList();
    final team2Double2 =
        allTeam2Players.where((p) => !team2Double1.contains(p)).toList();

    _parties.removeWhere((p) => p.id == 9 || p.id == 10);

    _parties.addAll([
      Partie(
        id: 9,
        team1Players: team1Double1,
        team2Players: team2Double1,
        winner: null,
      ),
      Partie(
        id: 10,
        team1Players: team1Double2,
        team2Players: team2Double2,
        winner: null,
      ),
    ]);

    notifyListeners();
  }
}
