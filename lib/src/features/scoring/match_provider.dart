
// lib/src/features/scoring/match_provider.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'game_model.dart';

class MatchProvider with ChangeNotifier {
  Partie? _currentMatch;
  List<GameModel> _games = [];

  Partie? get currentMatch => _currentMatch;
  List<GameModel> get games => _games;

  void startMatch(Partie match) {
    _currentMatch = match;
    _games = []; // Initialise la liste des manches à vide
    notifyListeners();
  }
}
