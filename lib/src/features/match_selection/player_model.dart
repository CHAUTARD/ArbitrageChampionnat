class Player {
  final int id;
  final String name;
  final String letter;

  Player({required this.id, required this.name, required this.letter});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      letter: json['letter'],
    );
  }
}
