// features/match_selection/player_model.dart
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
