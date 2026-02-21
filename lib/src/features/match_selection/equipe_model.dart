// lib/src/features/match_selection/equipe_model.dart
//
// Modèle de données pour une équipe.
// Contient le nom de l'équipe et la liste des joueurs qui la composent.

import 'package:myapp/src/features/match_selection/player_model.dart';

class Equipe {
  String name;
  final List<Player> players;

  Equipe({required this.name, required this.players});
}
