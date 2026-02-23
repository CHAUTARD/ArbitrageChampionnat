import 'package:hive/hive.dart';
import 'package:myapp/models/partie_model.dart';

part 'manche_model.g.dart';

@HiveType(typeId: 4)
class Manche extends HiveObject {
  @HiveField(0)
  late Partie partie;

  @HiveField(1)
  late int numeroManche;

  @HiveField(2)
  late int scoreTeam1;

  @HiveField(3)
  late int scoreTeam2;

  Manche({
    required this.partie,
    required this.numeroManche,
    this.scoreTeam1 = 0,
    this.scoreTeam2 = 0,
  });
}
