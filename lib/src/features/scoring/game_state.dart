import 'package:flutter/foundation.dart';
import 'package:myapp/models/jeu_model.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/partie_model.dart';

class GameState with ChangeNotifier {
  final Partie partie;
  final List<Manche> manches = [];
  int _currentMancheIndex = 0;

  GameState(this.partie) {
    _initializeManches();
  }

  int get currentMancheIndex => _currentMancheIndex;
  Manche get currentManche => manches[_currentMancheIndex];

  void _initializeManches() {
    final bool isDouble = partie.team1PlayerIds.length == 2;
    final int numberOfManches = isDouble ? 5 : 3;

    for (int i = 0; i < numberOfManches; i++) {
      manches.add(Manche(partie: partie, numeroManche: i + 1, jeux: []));
    }
    if (isDouble) {
      manches.add(Manche(partie: partie, numeroManche: 6, jeux: [], isTieBreak: true));
    }
  }

  void nextManche() {
    if (_currentMancheIndex < manches.length - 1) {
      _currentMancheIndex++;
      notifyListeners();
    }
  }

  void previousManche() {
    if (_currentMancheIndex > 0) {
      _currentMancheIndex--;
      notifyListeners();
    }
  }

  void setManche(int index) {
    if (index >= 0 && index < manches.length) {
      _currentMancheIndex = index;
      notifyListeners();
    }
  }

  void incrementScoreForTeam(int teamIndex) {
    final int scoreEquipeUn = teamIndex == 0 ? 1 : 0;
    final int scoreEquipeDeux = teamIndex == 1 ? 1 : 0;

    currentManche.jeux.add(
      Jeu(
        manche: currentManche,
        numero: currentManche.jeux.length + 1,
        scoreEquipeUn: scoreEquipeUn,
        scoreEquipeDeux: scoreEquipeDeux,
      ),
    );
    notifyListeners();
  }

  void decrementScoreForTeam(int teamIndex) {
    // This is a simplified implementation. A real app might need more robust logic
    // to find the last game won by a specific team.
    final lastGameIndex = currentManche.jeux.lastIndexWhere((jeu) => 
      (teamIndex == 0 && jeu.scoreEquipeUn == 1) || (teamIndex == 1 && jeu.scoreEquipeDeux == 1)
    );

    if (lastGameIndex != -1) {
      currentManche.jeux.removeAt(lastGameIndex);
      notifyListeners();
    }
  }
}
