// lib/src/features/match_selection/player_model.dart
//
// Modèle de données pour un joueur.
// Contient l'identifiant, le nom et l'identifiant de l'équipe du joueur.

class Player {
  final String id;
  final String name;
  final String equipeId;

  Player({required this.id, required this.name, required this.equipeId});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'].toString(),
      name: json['name'],
      equipeId: json['equipeId'].toString(),
    );
  }
}
