// lib/models/score_model.dart
// Modèle pour un point marqué.

class Score {
  final String team; // 'team1' or 'team2'
  final DateTime timestamp;

  Score({required this.team, required this.timestamp});
}
