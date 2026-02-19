// lib/src/features/match_selection/equipe_model.dart
import 'package:myapp/src/features/match_selection/player_model.dart';

class Equipe {
  String name;
  final List<Player> players;

  Equipe({required this.name, required this.players});
}
