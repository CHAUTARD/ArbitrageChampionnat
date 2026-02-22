import 'package:hive/hive.dart';
import 'package:myapp/models/manche_model.dart';

part 'game_model.g.dart';

@HiveType(typeId: 1)
class Game extends HiveObject {
  @HiveField(0)
  final int scoreTeam1;

  @HiveField(1)
  final int scoreTeam2;

  @HiveField(2)
  final HiveList<Manche> manche;

  Game({
    required this.scoreTeam1,
    required this.scoreTeam2,
    required this.manche,
  });
}
