import 'package:flutter/material.dart';
import 'package:myapp/models/game_model.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/src/features/scoring/game_service.dart';
import 'package:myapp/src/utils/app_constants.dart';

class GameState with ChangeNotifier {
  final GameService gameService;
  late Game game;
  int _currentMancheIndex = 0;

  GameState._({required this.gameService});

  static Future<GameState> create({
    required GameService gameService,
    required Partie partie,
  }) async {
    final gameState = GameState._(gameService: gameService);
    await gameState._loadOrCreateGame(partie);
    return gameState;
  }

  int get currentMancheIndex => _currentMancheIndex;
  Manche get currentManche => game.manches[_currentMancheIndex];
  List<String> get team1PlayerIds => game.partie.team1PlayerIds;
  List<String> get team2PlayerIds => game.partie.team2PlayerIds;

  bool get isMancheFinished {
    if (game.partie.validated) return true;
    final score1 = currentManche.scoreTeam1;
    final score2 = currentManche.scoreTeam2;
    final hasWinningScore = score1 >= AppConstants.winningScore || score2 >= AppConstants.winningScore;
    final hasPointDifference = (score1 - score2).abs() >= AppConstants.pointDifference;
    return hasWinningScore && hasPointDifference;
  }

  int get team1ManchesWon {
    int wins = 0;
    for (final manche in game.manches) {
      if (manche.scoreTeam1 > manche.scoreTeam2) {
        wins++;
      }
    }
    return wins;
  }

  int get team2ManchesWon {
    int wins = 0;
    for (final manche in game.manches) {
      if (manche.scoreTeam2 > manche.scoreTeam1) {
        wins++;
      }
    }
    return wins;
  }

  bool get isGameFinished => team1ManchesWon >= 3 || team2ManchesWon >= 3 || game.partie.validated;

  Future<void> _loadOrCreateGame(Partie partie) async {
    if (partie.id == null) {
      game = await gameService.createGame(partie);
    } else {
      final existingGame = await gameService.getGame(partie.id!);
      if (existingGame != null) {
        game = existingGame;
      } else {
        game = await gameService.createGame(partie);
      }
    }
    notifyListeners();
  }

  void setManche(int index) {
    if (game.partie.validated) return;
    _currentMancheIndex = index;
    notifyListeners();
  }

  void nextManche() {
    if (isGameFinished) return;
    if (_currentMancheIndex < game.manches.length - 1) {
      _currentMancheIndex++;
    } else {
      game.manches.add(Manche(partie: game.partie));
      _currentMancheIndex++;
    }
    notifyListeners();
  }

  int getScore(int teamIndex) {
    if (teamIndex == 0) {
      return currentManche.scoreTeam1;
    } else {
      return currentManche.scoreTeam2;
    }
  }

  void incrementScore(int teamIndex, String playerId) {
    if (isMancheFinished || game.partie.validated) return;
    if (teamIndex == 0) {
      currentManche.scoreTeam1++;
    } else {
      currentManche.scoreTeam2++;
    }
    gameService.updateGame(game);
    notifyListeners();
  }

  void decrementScore(int teamIndex, String playerId) {
    if (game.partie.validated) return;
    if (teamIndex == 0) {
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

  Future<void> validateGame() async {
    if (!isGameFinished || game.partie.validated) return;

    final String winnerId = team1ManchesWon > team2ManchesWon
        ? game.partie.team1PlayerIds.join('_')
        : game.partie.team2PlayerIds.join('_');

    game.partie.scoreEquipeUn = team1ManchesWon;
    game.partie.scoreEquipeDeux = team2ManchesWon;
    game.partie.winnerId = winnerId;
    game.partie.validated = true;
    game.partie.status = 'Terminé';

    await gameService.updateGame(game);
    notifyListeners();
  }
}
