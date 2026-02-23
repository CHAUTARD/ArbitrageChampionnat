import 'package:hive/hive.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/partie_model.dart';

part 'game_model.g.dart';

@HiveType(typeId: 5)
class Game extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late Partie partie;

  @HiveField(2)
  late List<Manche> manches;

  Game({
    required this.id,
    required this.partie,
    required this.manches,
  });
}
