// Path: lib/models/game_model.dart
// Rôle: Définit le modèle de données pour un "Game" (jeu).
// Ce modèle représente l'état d'un jeu de pointage en cours, incluant l'identifiant, 
// la partie associée, les scores, la liste des manches, et le nombre de manches gagnées par chaque équipe.
// Il est persisté dans la base de données locale à l'aide de Hive.

import 'package:hive/hive.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/partie_model.dart';

part 'game_model.g.dart';

@HiveType(typeId: 0)
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
