import 'package:hive/hive.dart';
import 'package:myapp/models/partie_model.dart';

part 'manche_model.g.dart';

@HiveType(typeId: 2)
class Manche extends HiveObject {
  @HiveField(0)
  final int numeroManche;

  @HiveField(1)
  int scoreTeam1;

  @HiveField(2)
  int scoreTeam2;

  @HiveField(3)
  int? pointGagne1;

  @HiveField(4)
  int? pointGagne2;

  @HiveField(5)
  final HiveList<Partie> partie;

  Manche({
    required this.numeroManche,
    this.scoreTeam1 = 0,
    this.scoreTeam2 = 0,
    this.pointGagne1,
    this.pointGagne2,
    required this.partie,
  });
}
