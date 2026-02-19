import 'package:myapp/src/features/match_selection/player_model.dart';

class Partie {
  final String id;
  final int rencontreId;
  final int numeroPartie; // <-- AJOUT
  final List<Player> team1Players;
  final List<Player> team2Players;
  final String? arbitreId; // <-- AJOUT
  final String? arbitreName; // <-- AJOUT
  bool isFinished;

  Partie({
    required this.id,
    required this.rencontreId,
    required this.numeroPartie, // <-- AJOUT
    required this.team1Players,
    required this.team2Players,
    this.arbitreId,
    this.arbitreName,
    this.isFinished = false,
  });

  Partie copyWith({
    String? id,
    int? rencontreId,
    int? numeroPartie,
    List<Player>? team1Players,
    List<Player>? team2Players,
    String? arbitreId,
    String? arbitreName,
    bool? isFinished,
  }) {
    return Partie(
      id: id ?? this.id,
      rencontreId: rencontreId ?? this.rencontreId,
      numeroPartie: numeroPartie ?? this.numeroPartie,
      team1Players: team1Players ?? this.team1Players,
      team2Players: team2Players ?? this.team2Players,
      arbitreId: arbitreId ?? this.arbitreId,
      arbitreName: arbitreName ?? this.arbitreName,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}
