import 'package:flutter/material.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';

class GameState with ChangeNotifier {
  late Partie partie;
  int currentManche = 0;
  List<List<int>> scores = [];
  final List<Player> team1Players;
  final List<Player> team2Players;

  GameState({
    required this.partie,
    required this.team1Players,
    required this.team2Players,
  }) {
    scores = List<List<int>>.generate(
      5,
      (index) => List<int>.generate(2, (index) => 0), // 2 for two teams
    );
  }

  void incrementScore(int teamIndex) {
    scores[currentManche][teamIndex]++;
    notifyListeners();
  }

  void nextManche() {
    if (currentManche < 4) {
      currentManche++;
      notifyListeners();
    }
  }

  void previousManche() {
    if (currentManche > 0) {
      currentManche--;
      notifyListeners();
    }
  }

  void setManche(int index) {
    if (index >= 0 && index < 5) {
      currentManche = index;
      notifyListeners();
    }
  }

  void saveGame() {
    // Logique pour sauvegarder l'état du jeu
  }
}
