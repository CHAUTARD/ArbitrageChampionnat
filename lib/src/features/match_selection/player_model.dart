class Player {
  final String id;
  String name;

  Player({required this.id, required this.name});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
    );
  }
}
