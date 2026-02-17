// features/match_selection/partie_model.dart
import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';

class Partie {
  final int id;
  final List<Player> team1Players;
  final List<Player> team2Players;
  final Player? arbitre;
  bool isPlayed;
  String? score;

  Partie({
    required this.id,
    required this.team1Players,
    required this.team2Players,
    this.arbitre,
    this.isPlayed = false,
    this.score,
  });

  factory Partie.fromJson(Map<String, dynamic> json, List<Player> allPlayers) {
    final numero = json['numero'];

    Player? findPlayer(dynamic playerId) {
      if (playerId == null) return null;
      // Ensure the ID to find is a string for consistent comparison.
      final String idToFind = playerId;
      try {
        return allPlayers.firstWhere((p) => p.id == idToFind);
      } catch (e) {
        if (kDebugMode) {
          print('Player with ID $idToFind not found.');
        }
        return null;
      }
    }

    return Partie(
      id: numero,
      team1Players: (json['equipe1'] as List)
          .map(findPlayer)
          .whereType<Player>()
          .toList(),
      team2Players: (json['equipe2'] as List)
          .map(findPlayer)
          .whereType<Player>()
          .toList(),
      arbitre: findPlayer(json['arbitre']),
      isPlayed: json['isPlayed'] ?? false,
      score: json['score'],
    );
  }
}
