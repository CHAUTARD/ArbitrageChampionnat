// Path: lib/src/features/scoring/game_state.dart
// Rôle: Gère l'état de la partie en cours (`Game`).
// Cette classe, utilisée avec `ChangeNotifier` et `Provider`, est le cœur de la logique de scoring.
// Elle charge une partie existante ou en crée une nouvelle via `GameService`.
// Elle expose des méthodes pour manipuler l'état du jeu, telles que :
// - `addManche`: Ajoute une nouvelle manche (set).
// - `updateMancheScore`: Met à jour le score d'une manche spécifique.
// - `removeManche`: Supprime la dernière manche.
// - `_updateScores`: Recalcule les scores globaux de la partie (nombre de manches gagnées par chaque équipe).
// Après chaque modification, elle notifie les widgets qui l'écoutent pour qu'ils se reconstruisent, et persiste les changements via `GameService`.

import 'package:flutter/material.dart';
import 'package:myapp/models/game_model.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/src/features/scoring/game_service.dart';

class GameState with ChangeNotifier {
  final GameService _gameService;
  late Game _game;
  bool _isLoading = true;
  String? _error;

  GameState(this._gameService);

  Game get game => _game;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadGame(Partie partie) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      Game? existingGame = _gameService.getGame(partie.id!);
      if (existingGame != null) {
        _game = existingGame;
      } else {
        _game = _gameService.createGame(partie);
      }
    } catch (e) {
      _error = "Erreur lors du chargement de la partie: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addManche() {
    _game.manches.add(Manche(partie: _game.partie, scoreTeam1: 0, scoreTeam2: 0));
    _updateScores();
    _gameService.updateGame(_game);
    notifyListeners();
  }

  void updateMancheScore(int mancheIndex, int team, int score) {
    if (team == 1) {
      _game.manches[mancheIndex].scoreTeam1 = score;
    } else {
      _game.manches[mancheIndex].scoreTeam2 = score;
    }
    _updateScores();
    _gameService.updateGame(_game);
    notifyListeners();
  }

  void removeManche(int mancheIndex) {
    if (_game.manches.length > 1) {
      _game.manches.removeAt(mancheIndex);
      _updateScores();
      _gameService.updateGame(_game);
      notifyListeners();
    }
  }

  void _updateScores() {
    int score1 = 0;
    int score2 = 0;
    int manchesGagnees1 = 0;
    int manchesGagnees2 = 0;

    for (var manche in _game.manches) {
      if (manche.scoreTeam1 > manche.scoreTeam2) {
        score1++;
        manchesGagnees1++;
      } else if (manche.scoreTeam2 > manche.scoreTeam1) {
        score2++;
        manchesGagnees2++;
      }
    }
    _game.scores = [score1, score2];
    _game.manchesGagneesTeam1 = manchesGagnees1;
    _game.manchesGagneesTeam2 = manchesGagnees2;
  }

  void setGameResult(int score1, int score2) {
    _gameService.updateGame(_game);
    notifyListeners();
  }
}
