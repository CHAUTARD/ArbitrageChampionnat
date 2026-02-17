import 'package:myapp/src/features/match_selection/player_model.dart';

class Partie {
  final String id;
  final String name;
  final DateTime horaire;
  final String table;
  final List<Player> team1Players;
  final List<Player> team2Players;
  final Player? arbitre;
  final int manchesGagnantes;

  Partie({
    required this.id,
    required this.name,
    required this.horaire,
    required this.table,
    required this.team1Players,
    required this.team2Players,
    this.arbitre,
    required this.manchesGagnantes,
  });

  factory Partie.fromJson(Map<String, dynamic> json, List<Player> allPlayers) {
    return Partie(
      id: json['id'],
      name: json['name'],
      horaire: DateTime.parse(json['horaire']), // Correctly parse the datetime string
      table: json['table'],
      team1Players: (json['team1_players'] as List)
          .map((playerId) => allPlayers.firstWhere((p) => p.id == playerId))
          .toList(),
      team2Players: (json['team2_players'] as List)
          .map((playerId) => allPlayers.firstWhere((p) => p.id == playerId))
          .toList(),
      arbitre: json['arbitre'] != null
          ? allPlayers.firstWhere((p) => p.id == json['arbitre'])
          : null,
      manchesGagnantes: json['manches_gagnantes'] ?? 3, // Default to 3 if not specified
    );
  }
}
