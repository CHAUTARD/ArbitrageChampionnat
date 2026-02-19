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
}
