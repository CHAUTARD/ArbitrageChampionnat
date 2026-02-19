// features/match_selection/player_model.dart
class Player {
  final String id;
  final String name;

  Player({required this.id, required this.name});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}
