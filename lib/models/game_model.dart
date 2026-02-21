import 'package:isar/isar.dart';
import 'package:myapp/models/manche_model.dart';

part 'game_model.g.dart';

@collection
class Game {
  Id id = Isar.autoIncrement;

  final int scoreTeam1;
  final int scoreTeam2;

  final manche = IsarLink<Manche>();

  Game({required this.scoreTeam1, required this.scoreTeam2});
}
