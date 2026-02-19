import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';

class MatchProvider with ChangeNotifier {
  late Partie _partie;
  final PartieProvider _partieProvider;
  int _scoreTeam1 = 0;
  int _scoreTeam2 = 0;
  int _manche = 1;
  int _manchesGagneesTeam1 = 0;
  int _manchesGagneesTeam2 = 0;
  bool _isSideSwapped = false;
  String? _joueurAuService;
  String? _joueurReceveur;
  final List<Game> _games = [];
  final Map<String, Carton> _cartons = {};
  bool _tempsMortTeam1Utilise = false;
  bool _tempsMortTeam2Utilise = false;
  bool _isServiceSelectionDone = false;

  // New properties to track server/receiver for subsequent games
  String? _lastServerOfPrevManche;
  String? _lastReceiverOfPrevManche;


  MatchProvider(this._partieProvider);

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
  bool get isServiceSelectionDone => _isServiceSelectionDone;

  // Getters for the new properties
  String? get lastServerOfPrevManche => _lastServerOfPrevManche;
  String? get lastReceiverOfPrevManche => _lastReceiverOfPrevManche;

  String get player1Name => _partie.team1Players.map((p) => p.name).join(' & ');
  String get player2Name => _partie.team2Players.map((p) => p.name).join(' & ');

  bool get isMatchFinished =>
      _manchesGagneesTeam1 >= 3 || _manchesGagneesTeam2 >= 3;

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
    _joueurAuService = null;
    _joueurReceveur = null;
    _isServiceSelectionDone = false;
    _lastServerOfPrevManche = null;
    _lastReceiverOfPrevManche = null;
    notifyListeners();
  }

  void completeServiceSelection() {
    _isServiceSelectionDone = true;
    notifyListeners();
  }

  void incrementScore(int team) {
    if (isMatchFinished || !_isServiceSelectionDone) return;

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
    if (isMatchFinished || !_isServiceSelectionDone) return;

    if (team == 1 && _scoreTeam1 > 0) {
      _scoreTeam1--;
    } else if (team == 2 && _scoreTeam2 > 0) {
      _scoreTeam2--;
    }
    _updateService();
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
        // Store server/receiver before starting new game
        _lastServerOfPrevManche = _joueurAuService;
        _lastReceiverOfPrevManche = _joueurReceveur;
        _startNewManche();
      } else {
        _endMatch();
      }
    }
  }

  void _startNewManche() {
    _scoreTeam1 = 0;
    _scoreTeam2 = 0;
    _manche++;
    _tempsMortTeam1Utilise = false;
    _tempsMortTeam2Utilise = false;
    _isServiceSelectionDone = false; // Force re-selection
    _joueurAuService = null;
    _joueurReceveur = null;
    changerDeCote();
  }

  void _endMatch() {
    _partie.isPlayed = true;
    _partie.score = '$_manchesGagneesTeam1/$_manchesGagneesTeam2';
    if (_manchesGagneesTeam1 > _manchesGagneesTeam2) {
      _partie.winner = _partie.team1Players.map((p) => p.name).join(' & ');
    } else {
      _partie.winner = _partie.team2Players.map((p) => p.name).join(' & ');
    }
    _partieProvider.saveMatchResult(_partie);
    notifyListeners();
  }

  void _updateService() {
    final totalScore = _scoreTeam1 + _scoreTeam2;
    final isDouble = _partie.team1Players.length > 1;

    if (totalScore % 2 == 0 && totalScore > 0) {
      if (isDouble) {
        final currentServerName = _joueurAuService;
        final currentReceiverName = _joueurReceveur;

        final team1 = _partie.team1Players.map((p) => p.name).toList();
        final team2 = _partie.team2Players.map((p) => p.name).toList();

        final partnerOfCurrentServer = team1.contains(currentServerName)
            ? team1.firstWhereOrNull((p) => p != currentServerName)
            : team2.firstWhereOrNull((p) => p != currentServerName);

        _joueurAuService = currentReceiverName;
        _joueurReceveur = partnerOfCurrentServer;
      } else {
        final tempServer = _joueurAuService;
        _joueurAuService = _joueurReceveur;
        _joueurReceveur = tempServer;
      }
    }
    notifyListeners();
  }

 void setServer(String playerName) {
    _joueurAuService = playerName;
    // For games > 1, the receiver is determined automatically
    if (_manche > 1 && _lastServerOfPrevManche != null) {
      final lastServerPartner = _partie.team1Players.any((p) => p.name == _lastServerOfPrevManche) 
          ? _partie.team1Players.firstWhereOrNull((p) => p.name != _lastServerOfPrevManche)?.name
          : _partie.team2Players.firstWhereOrNull((p) => p.name != _lastServerOfPrevManche)?.name;
      _joueurReceveur = lastServerPartner;
    } else {
      _joueurReceveur = null; // Reset for game 1
    }
    notifyListeners();
  }

  void setReceiver(String playerName) {
    if (_joueurAuService == null) return;

    final serverIsInTeam1 = _partie.team1Players.any((p) => p.name == _joueurAuService);
    final receiverIsInTeam1 = _partie.team1Players.any((p) => p.name == playerName);

    if (serverIsInTeam1 != receiverIsInTeam1) {
      _joueurReceveur = playerName;
      notifyListeners();
    }
  }

  void changerDeCote() {
    _isSideSwapped = !_isSideSwapped;
    notifyListeners();
  }

  void utiliserTempsMort(int teamNumber) {
    if (teamNumber == 1) {
      _tempsMortTeam1Utilise = !_tempsMortTeam1Utilise;
    } else {
      _tempsMortTeam2Utilise = !_tempsMortTeam2Utilise;
    }
    notifyListeners();
  }

  void attribuerCarton(String playerId, Carton carton) {
    if (_cartons[playerId] == carton) {
      _cartons.remove(playerId);
    } else {
      _cartons[playerId] = carton;
    }
    notifyListeners();
  }

  Carton? getCartonForPlayer(String playerId) {
    return _cartons[playerId];
  }
}

class Game {
  final int score1;
  final int score2;
  

  Game({required this.score1, required this.score2});
}

enum Carton { jaune, jauneRouge, rouge }
