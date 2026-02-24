// game_state.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/game_model.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/src/features/scoring/game_service.dart';

class GameState with ChangeNotifier {
  final GameService gameService;
  late Game game;
  int _currentMancheIndex = 0;

  GameState({required this.gameService, required Partie partie}) {
    _loadOrCreateGame(partie);
  }

  int get currentMancheIndex => _currentMancheIndex;
  Manche get currentManche => game.manches[_currentMancheIndex];

  void _loadOrCreateGame(Partie partie) async {
    if (partie.id == null) {
      game = await gameService.createGame(partie);
    } else {
      Game? existingGame = await gameService.getGame(partie.id!);
      if (existingGame != null) {
        game = existingGame;
      } else {
        game = await gameService.createGame(partie);
      }
    }
    notifyListeners();
  }

  void setManche(int index) {
    _currentMancheIndex = index;
    notifyListeners();
  }

  void incrementScore(int team) {
    if (team == 1) {
      currentManche.scoreTeam1++;
    } else {
      currentManche.scoreTeam2++;
    }
    gameService.updateGame(game);
    notifyListeners();
  }

  void decrementScore(int team) {
    if (team == 1) {
      if (currentManche.scoreTeam1 > 0) {
        currentManche.scoreTeam1--;
      }
    } else {
      if (currentManche.scoreTeam2 > 0) {
        currentManche.scoreTeam2--;
      }
    }
    gameService.updateGame(game);
    notifyListeners();
  }
}
