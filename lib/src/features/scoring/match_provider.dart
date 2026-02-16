
import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';

class MatchProvider with ChangeNotifier {
  Partie? _partie;
  int _scoreTeam1 = 0;
  int _scoreTeam2 = 0;
  int _manche = 1; 
  bool _isSideSwapped = false; // Pour gérer l'affichage du changement de côté
  List<String> _scoresManches = [];

  int _serveurIndexTeam1 = 0;
  int _serveurIndexTeam2 = 0;
  int _equipeAuService = 1;

  Partie? get partie => _partie;
  int get scoreTeam1 => _scoreTeam1;
  int get scoreTeam2 => _scoreTeam2;
  int get manche => _manche;
  int get equipeAuService => _equipeAuService;
  bool get isSideSwapped => _isSideSwapped;
  List<String> get scoresManches => _scoresManches;

  String get joueurAuService {
    if (_partie == null) return "";
    if (_equipeAuService == 1) {
      return _partie!.team1Players[_serveurIndexTeam1].name;
    } else {
      return _partie!.team2Players[_serveurIndexTeam2].name;
    }
  }

  String get joueurReceveur {
    if (_partie == null) return "";
    if (_equipeAuService == 2) {
      return _partie!.team1Players[(_serveurIndexTeam1 + 1) % _partie!.team1Players.length].name;
    } else {
      return _partie!.team2Players[(_serveurIndexTeam2 + 1) % _partie!.team2Players.length].name;
    }
  }

  void startMatch(Partie newPartie) {
    _partie = newPartie;
    resetScores();
  }

  void incrementScore(int team) {
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
    if (_scoreTeam1 >= 11 && _scoreTeam1 >= _scoreTeam2 + 2) {
      _scoresManches.add('$_scoreTeam1 - $_scoreTeam2');
      _manche++;
      _scoreTeam1 = 0;
      _scoreTeam2 = 0;
    } else if (_scoreTeam2 >= 11 && _scoreTeam2 >= _scoreTeam1 + 2) {
       _scoresManches.add('$_scoreTeam1 - $_scoreTeam2');
      _manche++;
      _scoreTeam1 = 0;
      _scoreTeam2 = 0;
    }
  }

  void decrementScore(int team) {
    if (team == 1 && _scoreTeam1 > 0) {
      _scoreTeam1--;
    } else if (team == 2 && _scoreTeam2 > 0) {
      _scoreTeam2--;
    }
    notifyListeners();
  }

  void _prochainServeur() {
    if ((_scoreTeam1 + _scoreTeam2) % 2 == 0) {
        _equipeAuService = _equipeAuService == 1 ? 2 : 1;
    }
     if (_equipeAuService == 1) {
      _serveurIndexTeam1 = (_serveurIndexTeam1 + 1) % _partie!.team1Players.length;
    } else {
      _serveurIndexTeam2 = (_serveurIndexTeam2 + 1) % _partie!.team2Players.length;
    }
  }

  void changerDeCote() {
    _isSideSwapped = !_isSideSwapped;
    notifyListeners();
  }

  void resetScores() {
    _scoreTeam1 = 0;
    _scoreTeam2 = 0;
    _manche = 1;
    _equipeAuService = 1;
    _serveurIndexTeam1 = 0;
    _serveurIndexTeam2 = 0;
    _isSideSwapped = false;
    _scoresManches = [];
    notifyListeners();
  }
}
