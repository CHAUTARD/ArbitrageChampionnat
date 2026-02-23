import 'package:hive/hive.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/jeu_model.dart';

part 'manche_model.g.dart';

@HiveType(typeId: 2)
class Manche extends HiveObject {
  @HiveField(0)
  late Partie partie;

  @HiveField(1)
  late int numeroManche;

  @HiveField(2)
  late List<Jeu> jeux;

  @HiveField(3)
  late bool isTieBreak;

  Manche({
    required this.partie,
    required this.numeroManche,
    required this.jeux,
    this.isTieBreak = false,
  });

  int get scoreTeam1 => jeux.fold(0, (previousValue, element) => previousValue + element.scoreEquipeUn);
  int get scoreTeam2 => jeux.fold(0, (previousValue, element) => previousValue + element.scoreEquipeDeux);
}
