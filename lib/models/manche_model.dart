import 'package:isar/isar.dart';
import 'package:myapp/models/partie_model.dart';

part 'manche_model.g.dart';

@collection
class Manche {
  Id id = Isar.autoIncrement; // Use auto-incrementing ID

  final int numeroManche;
  int scoreTeam1;
  int scoreTeam2;
  int? pointGagne1;
  int? pointGagne2;

  final partie = IsarLink<Partie>();

  Manche({
    required this.numeroManche,
    this.scoreTeam1 = 0,
    this.scoreTeam2 = 0,
    this.pointGagne1,
    this.pointGagne2,
  });
}
