
import 'package:myapp/src/features/match_selection/player_model.dart';

class Partie {
  final int numero;
  final String name;
  final List<Player> team1Players;
  final List<Player> team2Players;
  final Player? arbitre; // Added umpire

  Partie({
    required this.numero,
    required this.name,
    required this.team1Players,
    required this.team2Players,
    this.arbitre, // Make it optional
  });
}
