import 'package:flutter/material.dart';
import 'package:myapp/models/partie_model.dart';

class GameState with ChangeNotifier {
  late Partie partie;
  int currentManche = 0;
  List<List<int>> scores = [];

  GameState({required this.partie}) {
    scores = List<List<int>>.generate(
      5,
      (index) => List<int>.generate(partie.nombreJoueurs, (index) => 0),
    );
  }

  void incrementScore(int playerIndex) {
    scores[currentManche][playerIndex]++;
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
