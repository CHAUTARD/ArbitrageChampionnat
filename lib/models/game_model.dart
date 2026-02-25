import 'package:hive/hive.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/partie_model.dart';

part 'game_model.g.dart';

@HiveType(typeId: 4)
class Game extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Partie partie;

  @HiveField(2)
  List<int> scores;

  @HiveField(3)
  List<Manche> manches;

  @HiveField(4)
  int manchesGagneesTeam1;

  @HiveField(5)
  int manchesGagneesTeam2;

  Game({
    required this.id,
    required this.partie,
    required this.scores,
    required this.manches,
    this.manchesGagneesTeam1 = 0,
    this.manchesGagneesTeam2 = 0,
  });
}
