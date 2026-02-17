import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:myapp/src/features/match_selection/team_provider.dart';

class PartieProvider with ChangeNotifier {
  final TeamProvider _teamProvider;
  List<Partie> _parties = [];
  bool _isLoading = true;

  List<Partie> get parties => _parties;
  bool get isLoading => _isLoading;

  PartieProvider(this._teamProvider) {
    // Schedule _loadParties to run after the current build cycle is complete.
    Future.microtask(() => _loadParties());
  }

  Future<void> _loadParties() async {
    _isLoading = true;

    try {
      // Wait for the TeamProvider to finish loading if it hasn't already.
      if (_teamProvider.isLoading) {
        // This creates a temporary listener to await the change.
        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 10)); // Prevent busy-waiting
          return _teamProvider.isLoading;
        });
      }

      if (_teamProvider.teams.isEmpty) {
        // Handle case where team loading might have failed.
        throw Exception("Teams could not be loaded, so parties cannot be determined.");
      }

      final playersJsonString =
          await rootBundle.loadString('assets/database/players.json');
      final playersJson = json.decode(playersJsonString) as List;
      final List<Player> allPlayers = playersJson.asMap().entries.map((entry) {
        int idx = entry.key;
        Map<String, dynamic> playerJson = entry.value;
        return Player(
          id: playerJson['id'] as int? ?? idx,
          name: playerJson['name'],
          letter: playerJson['letter'],
        );
      }).toList();

      final partiesJsonString =
          await rootBundle.loadString('assets/database/parties.json');
      final partiesJson = json.decode(partiesJsonString) as List;
      _parties = partiesJson
          .map((partieJson) => Partie.fromJson(partieJson, allPlayers))
          .toList();
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

  void updateDoublesComposition(
      List<Player> team1Double1, List<Player> team2Double1) {
    final allTeam1Players = _teamProvider.equipe1;
    final allTeam2Players = _teamProvider.equipe2;

    final team1Double2 =
        allTeam1Players.where((p) => !team1Double1.contains(p)).toList();
    final team2Double2 =
        allTeam2Players.where((p) => !team2Double1.contains(p)).toList();

    _parties.removeWhere((p) => p.name == 'Double N° 1' || p.name == 'Double N° 2');

    _parties.addAll([
      Partie(
        id: 'double1',
        name: 'Double N° 1',
        horaire: DateTime.now(),
        table: 'A définir',
        team1Players: team1Double1,
        team2Players: team2Double1,
        manchesGagnantes: 3,
      ),
      Partie(
        id: 'double2',
        name: 'Double N° 2',
        horaire: DateTime.now(),
        table: 'A définir',
        team1Players: team1Double2,
        team2Players: team2Double2,
        manchesGagnantes: 3,
      ),
    ]);

    notifyListeners();
  }
}
