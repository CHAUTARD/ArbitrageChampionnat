import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';

class MatchProvider with ChangeNotifier {
  late Partie _partie;
  int _scoreTeam1 = 0;
  int _scoreTeam2 = 0;
  int _manche = 1;
  int _manchesGagneesTeam1 = 0;
  int _manchesGagneesTeam2 = 0;
  bool _isSideSwapped = false;
  String? _joueurAuService;
  String? _joueurReceveur;
  final List<Game> _games = [];
  final Map<int, Carton> _cartons = {};
  bool _tempsMortTeam1Utilise = false;
  bool _tempsMortTeam2Utilise = false;

  // Getters
  int get scoreTeam1 => _scoreTeam1;
  int get scoreTeam2 => _scoreTeam2;
  int get manche => _manche;
  int get manchesGagneesTeam1 => _manchesGagneesTeam1;
  int get manchesGagneesTeam2 => _manchesGagneesTeam2;
  bool get isSideSwapped => _isSideSwapped;
  String? get joueurAuService => _joueurAuService;
  String? get joueurReceveur => _joueurReceveur;
  List<Game> get games => _games;
  bool get tempsMortTeam1Utilise => _tempsMortTeam1Utilise;
  bool get tempsMortTeam2Utilise => _tempsMortTeam2Utilise;

  String get player1Name => _partie.team1Players.map((p) => p.name).join(' & ');
  String get player2Name => _partie.team2Players.map((p) => p.name).join(' & ');

  bool get isMatchFinished =>
      _manchesGagneesTeam1 >= _partie.manchesGagnantes ||
      _manchesGagneesTeam2 >= _partie.manchesGagnantes;

  int? get winnerTeam {
    if (!isMatchFinished) return null;
    return _manchesGagneesTeam1 > _manchesGagneesTeam2 ? 1 : 2;
  }

  void startMatch(Partie partie) {
    _partie = partie;
    _scoreTeam1 = 0;
    _scoreTeam2 = 0;
    _manche = 1;
    _manchesGagneesTeam1 = 0;
    _manchesGagneesTeam2 = 0;
    _isSideSwapped = false;
    _games.clear();
    _cartons.clear();
    _tempsMortTeam1Utilise = false;
    _tempsMortTeam2Utilise = false;
    // Initial server/receiver setup can be done here if needed
    _joueurAuService = _partie.team1Players.first.name;
    _joueurReceveur = _partie.team2Players.first.name;
    notifyListeners();
  }

  void incrementScore(int team) {
    if (isMatchFinished) return;

    if (team == 1) {
      _scoreTeam1++;
    } else {
      _scoreTeam2++;
    }
    _checkMancheEnd();
    _updateService();
    notifyListeners();
  }

  void decrementScore(int team) {
    if (isMatchFinished) return;

    if (team == 1 && _scoreTeam1 > 0) {
      _scoreTeam1--;
    } else if (team == 2 && _scoreTeam2 > 0) {
      _scoreTeam2--;
    }
    _updateService(); // Re-evaluate server on score change
    notifyListeners();
  }

  void _checkMancheEnd() {
    bool isMancheFinished = false;
    if (_scoreTeam1 >= 11 && _scoreTeam1 >= _scoreTeam2 + 2) {
      _manchesGagneesTeam1++;
      isMancheFinished = true;
    } else if (_scoreTeam2 >= 11 && _scoreTeam2 >= _scoreTeam1 + 2) {
      _manchesGagneesTeam2++;
      isMancheFinished = true;
    }

    if (isMancheFinished) {
      _games.add(Game(score1: _scoreTeam1, score2: _scoreTeam2));
      if (!isMatchFinished) {
        _startNewManche();
      }
    }
  }

  void _startNewManche() {
    _scoreTeam1 = 0;
    _scoreTeam2 = 0;
    _manche++;
    _tempsMortTeam1Utilise = false;
    _tempsMortTeam2Utilise = false;
    changerDeCote(); // Automatically swap sides at the start of a new set
    // Swap initial server for the new set
    final tempServer = _joueurAuService;
    _joueurAuService = _joueurReceveur;
    _joueurReceveur = tempServer;
  }

  void _updateService() {
    final totalScore = _scoreTeam1 + _scoreTeam2;
    // In doubles, service changes every 2 points
    if (totalScore % 2 == 0) {
      final tempServer = _joueurAuService;
      _joueurAuService = _joueurReceveur;
      _joueurReceveur = tempServer;
    }
  }

  void setServer(String playerName) {
    final team1Players = _partie.team1Players.map((p) => p.name).toList();
    final team2Players = _partie.team2Players.map((p) => p.name).toList();

    if (team1Players.contains(playerName)) {
      _joueurAuService = playerName;
      // Find a receiver in the other team
      _joueurReceveur = team2Players.first; // Simplified: just pick the first
    } else if (team2Players.contains(playerName)) {
      _joueurAuService = playerName;
      // Find a receiver in the other team
      _joueurReceveur = team1Players.first; // Simplified: just pick the first
    }
    notifyListeners();
  }

  void changerDeCote() {
    _isSideSwapped = !_isSideSwapped;
    notifyListeners();
  }

  void attribuerCarton(int playerId, Carton carton) {
    // For timeout (Carton.blanc), toggle based on team
    if (carton == Carton.blanc) {
      final playerTeam1 = _partie.team1Players.any((p) => p.id == playerId);
      if (playerTeam1) {
        _tempsMortTeam1Utilise = !_tempsMortTeam1Utilise;
      } else {
        _tempsMortTeam2Utilise = !_tempsMortTeam2Utilise;
      }
    } else {
      if (_cartons[playerId] == carton) {
        _cartons.remove(playerId); // Un-set the card
      } else {
        _cartons[playerId] = carton; // Set the card
      }
    }
    notifyListeners();
  }

  Carton? getCartonForPlayer(int playerId) {
    return _cartons[playerId];
  }
}

class Game {
  final int score1;
  final int score2;

  Game({required this.score1, required this.score2});
}

enum Carton {
  blanc, // Timeout
  jaune,
  jauneRouge,
  rouge
}
