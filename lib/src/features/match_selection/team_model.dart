
// lib/src/features/match_selection/team_model.dart
import 'package:myapp/src/features/match_selection/player_model.dart';

class Team {
  final String name;
  final List<Player> players;

  Team({required this.name, required this.players});
}
