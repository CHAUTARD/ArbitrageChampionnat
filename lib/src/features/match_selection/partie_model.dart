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
  String? winner; // Vainqueur de la partie
  int? manchesGagneesTeam1;
  int? manchesGagneesTeam2;
  int? pointsGagnesTeam1;
  int? pointsGagnesTeam2;

  Partie({
    required this.id,
    required this.team1Players,
    required this.team2Players,
    this.arbitre,
    this.isPlayed = false,
    this.score,
    this.winner,
    this.manchesGagneesTeam1,
    this.manchesGagneesTeam2,
    this.pointsGagnesTeam1,
    this.pointsGagnesTeam2,
  });

  factory Partie.fromJson(Map<String, dynamic> json, List<Player> allPlayers) {
    final numero = json['numero'];

    Player? findPlayer(dynamic playerId) {
      if (playerId == null) return null;
      // Ensure the ID to find is a string for consistent comparison.
      final String idToFind = playerId.toString();
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
      winner: json['winner'],
      manchesGagneesTeam1: json['manchesGagneesTeam1'],
      manchesGagneesTeam2: json['manchesGagneesTeam2'],
      pointsGagnesTeam1: json['pointsGagnesTeam1'],
      pointsGagnesTeam2: json['pointsGagnesTeam2'],
    );
  }
}
