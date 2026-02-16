
class Player {
  final String id;
  String name; // 'final' retiré pour permettre la modification
  final String letter;

  Player({required this.id, required this.name, required this.letter});
}
