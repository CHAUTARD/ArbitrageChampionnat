import 'package:hive/hive.dart';
import 'package:myapp/models/manche_model.dart';

part 'jeu_model.g.dart';

@HiveType(typeId: 3)
class Jeu extends HiveObject {
  @HiveField(0)
  late Manche manche;

  @HiveField(1)
  late int numero;

  @HiveField(2)
  late int scoreEquipeUn;

  @HiveField(3)
  late int scoreEquipeDeux;

  Jeu({
    required this.manche,
    required this.numero,
    required this.scoreEquipeUn,
    required this.scoreEquipeDeux,
  });
}
