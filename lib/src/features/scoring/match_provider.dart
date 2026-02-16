// features/scoring/match_provier.dart
import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';

enum Carton { blanc, jaune, jauneRouge, rouge }  

class MatchProvider with ChangeNotifier {
  Partie? _partie;
  int _scoreTeam1 = 0;
  int _scoreTeam2 = 0;
  int _manche = 1;
  bool _isSideSwapped = false;
  List<String> _scoresManches = [];

  // Suivi de la fin de match
  int _manchesGagneesTeam1 = 0;
  int _manchesGagneesTeam2 = 0;
  bool _isMatchFinished = false;
  int? _winnerTeam; // 1 ou 2

  int _serveurIndexTeam1 = 0;
  int _serveurIndexTeam2 = 0;
  int _equipeAuService = 1;

  bool _tempsMortTeam1Utilise = false;
  bool _tempsMortTeam2Utilise = false;
  Map<String, Carton> _cartonsJoueurs = {};

  // Getters
  Partie? get partie => _partie;
  int get scoreTeam1 => _scoreTeam1;
  int get scoreTeam2 => _scoreTeam2;
  int get manche => _manche;
  int get equipeAuService => _equipeAuService;
  bool get isSideSwapped => _isSideSwapped;
  List<String> get scoresManches => _scoresManches;
  bool get tempsMortTeam1Utilise => _tempsMortTeam1Utilise;
  bool get tempsMortTeam2Utilise => _tempsMortTeam2Utilise;
  bool get isMatchFinished => _isMatchFinished;
  int? get winnerTeam => _winnerTeam;
  int get manchesGagneesTeam1 => _manchesGagneesTeam1;
  int get manchesGagneesTeam2 => _manchesGagneesTeam2;

  String get joueurAuService {
    if (_partie == null || _partie!.team1Players.isEmpty || _partie!.team2Players.isEmpty) return "";
    if (_equipeAuService == 1) {
      return _partie!.team1Players[_serveurIndexTeam1].name;
    } else {
      return _partie!.team2Players[_serveurIndexTeam2].name;
    }
  }

  String get joueurReceveur {
    if (_partie == null || _partie!.team1Players.isEmpty || _partie!.team2Players.isEmpty) return "";
    if (_equipeAuService == 2) {
      return _partie!.team1Players[(_serveurIndexTeam1 + 1) % _partie!.team1Players.length].name;
    } else {
      return _partie!.team2Players[(_serveurIndexTeam2 + 1) % _partie!.team2Players.length].name;
    }
  }

  Carton? getCartonForPlayer(String playerId) {
    return _cartonsJoueurs[playerId];
  }

  void startMatch(Partie newPartie) {
    _partie = newPartie;
    resetScores();
  }

  void incrementScore(int team) {
    if (_isMatchFinished) return; 

    if (team == 1) {
      _scoreTeam1++;
    } else {
      _scoreTeam2++;
    }
    _prochainServeur();
    _checkMancheWin();
    notifyListeners();
  }

  void _checkMancheWin() {
    bool mancheGagnee = false;
    if (_scoreTeam1 >= 11 && _scoreTeam1 >= _scoreTeam2 + 2) {
      _scoresManches.add('$_scoreTeam1 - $_scoreTeam2');
      _manchesGagneesTeam1++;
      mancheGagnee = true;
    } else if (_scoreTeam2 >= 11 && _scoreTeam2 >= _scoreTeam1 + 2) {
      _scoresManches.add('$_scoreTeam1 - $_scoreTeam2');
      _manchesGagneesTeam2++;
      mancheGagnee = true;
    }

    if (mancheGagnee) {
      if (_manchesGagneesTeam1 == 3) {
        _isMatchFinished = true;
        _winnerTeam = 1;
      } else if (_manchesGagneesTeam2 == 3) {
        _isMatchFinished = true;
        _winnerTeam = 2;
      } else {
        _manche++;
        _scoreTeam1 = 0;
        _scoreTeam2 = 0;
      }
    }
  }

  void decrementScore(int team) {
    if (_isMatchFinished) return;

    bool shouldChangeServer = (_scoreTeam1 + _scoreTeam2) % 2 != 0;
    if (team == 1 && _scoreTeam1 > 0) {
      _scoreTeam1--;
      if (shouldChangeServer) _prochainServeur();
    } else if (team == 2 && _scoreTeam2 > 0) {
      _scoreTeam2--;
      if (shouldChangeServer) _prochainServeur();
    }
    notifyListeners();
  }

  void _prochainServeur() {
    if ((_scoreTeam1 + _scoreTeam2) % 2 == 0) {
      _equipeAuService = _equipeAuService == 1 ? 2 : 1;
    }
  }

  void setServer(String playerName) {
    if (_partie == null) return;
    final team1Index = _partie!.team1Players.indexWhere((p) => p.name == playerName);
    if (team1Index != -1) {
      _equipeAuService = 1;
      _serveurIndexTeam1 = team1Index;
      notifyListeners();
      return;
    }
    final team2Index = _partie!.team2Players.indexWhere((p) => p.name == playerName);
    if (team2Index != -1) {
      _equipeAuService = 2;
      _serveurIndexTeam2 = team2Index;
      notifyListeners();
    }
  }

  void changerDeCote() {
    _isSideSwapped = !_isSideSwapped;
    notifyListeners();
  }

  void _utiliserTempsMort(int team) {
    if (_isMatchFinished) return;
    if (team == 1 && !_tempsMortTeam1Utilise) {
      _tempsMortTeam1Utilise = true;
    } else if (team == 2 && !_tempsMortTeam2Utilise) {
      _tempsMortTeam2Utilise = true;
    }
    notifyListeners();
  }

  void attribuerCarton(String playerId, Carton carton) {
    if (_isMatchFinished) return;

    if (carton == Carton.blanc) {
      final isTeam1Player = _partie?.team1Players.any((p) => p.id == playerId) ?? false;
      if (isTeam1Player) {
        _utiliserTempsMort(1);
      } else {
        _utiliserTempsMort(2);
      }
      return;
    }

    final Carton? currentCarton = _cartonsJoueurs[playerId];

    if (currentCarton == carton) {
      _cartonsJoueurs.remove(playerId);
      notifyListeners();
      return;
    }

    bool canAssign = false;
    switch (carton) {
      case Carton.jaune:
        if (currentCarton == null) canAssign = true;
        break;
      case Carton.jauneRouge:
        if (currentCarton == Carton.jaune) canAssign = true;
        break;
      case Carton.rouge:
        if (currentCarton == Carton.jauneRouge) canAssign = true;
        break;
      case Carton.blanc:
        break;
    }

    if (canAssign) {
      _cartonsJoueurs[playerId] = carton;
    }

    notifyListeners();
  }

  void resetScores() {
    _scoreTeam1 = 0;
    _scoreTeam2 = 0;
    _manche = 1;
    _scoresManches = [];
    _equipeAuService = 1;
    _serveurIndexTeam1 = 0;
    _serveurIndexTeam2 = 0;
    _isSideSwapped = false;
    _tempsMortTeam1Utilise = false;
    _tempsMortTeam2Utilise = false;
    _cartonsJoueurs = {};
    _manchesGagneesTeam1 = 0;
    _manchesGagneesTeam2 = 0;
    _isMatchFinished = false;
    _winnerTeam = null;
    notifyListeners();
  }
}
