class Manche {
  final int id;
  final int partieId;
  final int numeroManche;
  int scoreTeam1;
  int scoreTeam2;
  int? pointGagne1;
  int? pointGagne2;

  Manche({
    required this.id,
    required this.partieId,
    required this.numeroManche,
    required this.scoreTeam1,
    required this.scoreTeam2,
    this.pointGagne1,
    this.pointGagne2,
  });

  Manche copyWith({
    int? id,
    int? partieId,
    int? numeroManche,
    int? scoreTeam1,
    int? scoreTeam2,
    int? pointGagne1,
    int? pointGagne2,
  }) {
    return Manche(
      id: id ?? this.id,
      partieId: partieId ?? this.partieId,
      numeroManche: numeroManche ?? this.numeroManche,
      scoreTeam1: scoreTeam1 ?? this.scoreTeam1,
      scoreTeam2: scoreTeam2 ?? this.scoreTeam2,
      pointGagne1: pointGagne1 ?? this.pointGagne1,
      pointGagne2: pointGagne2 ?? this.pointGagne2,
    );
  }
}
