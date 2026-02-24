import 'package:hive/hive.dart';
import 'package:myapp/models/partie_model.dart';

part 'rencontre_model.g.dart';

@HiveType(typeId: 6)
class Rencontre extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime dateTime;

  @HiveField(2)
  late String equipeA;

  @HiveField(3)
  late String equipeB;

  @HiveField(4)
  late List<String> joueursEquipeA;

  @HiveField(5)
  late List<String> joueursEquipeB;

  @HiveField(6)
  late List<Partie> parties;

  Rencontre({
    required this.id,
    required this.dateTime,
    required this.equipeA,
    required this.equipeB,
    required this.joueursEquipeA,
    required this.joueursEquipeB,
    required this.parties,
  });
}
