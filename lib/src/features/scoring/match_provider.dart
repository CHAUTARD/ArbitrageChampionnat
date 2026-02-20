import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/scoring/game_model.dart';

enum Carton { jaune, jauneRouge, rouge }

class MatchProvider with ChangeNotifier {
  final PartieProvider partieProvider;
  final int nombreManches;
  final int pointsParManche;

  int manche = 1;
  int scoreTeam1 = 0;
  int scoreTeam2 = 0;
  int manchesGagneesTeam1 = 0;
  int manchesGagneesTeam2 = 0;

  String? joueurAuService;
  bool tempsMortTeam1Utilise = false;
  bool tempsMortTeam2Utilise = false;
  Map<String, Carton> cartons = {};

  List<Game> historiqueManches = [];
  List<Map<String, dynamic>> historiqueActions = [];

  bool isSideSwapped = false;
  bool isMatchFinished = false;
  int? winnerTeam;

  Partie? _currentPartie;
  Partie? get currentPartie => _currentPartie;

  MatchProvider(this.nombreManches, this.pointsParManche, {required this.partieProvider});

  void startMatch(Partie partie) {
    _currentPartie = partie;
    manche = 1;
    scoreTeam1 = 0;
    scoreTeam2 = 0;
    manchesGagneesTeam1 = 0;
    manchesGagneesTeam2 = 0;
    joueurAuService = null;
    tempsMortTeam1Utilise = false;
    tempsMortTeam2Utilise = false;
    cartons = {};
    historiqueManches = [];
    historiqueActions = [];
    isSideSwapped = false;
    isMatchFinished = false;
    winnerTeam = null;
    notifyListeners();
  }

  void incrementScore(int team) {
    _enregistrerAction();
    if (team == 1) {
      scoreTeam1++;
    } else {
      scoreTeam2++;
    }
    _verifierFinDeManche();
    notifyListeners();
  }

  void decrementScore(int team) {
    _enregistrerAction();
    if (team == 1) {
      if (scoreTeam1 > 0) scoreTeam1--;
    } else {
      if (scoreTeam2 > 0) scoreTeam2--;
    }
    notifyListeners();
  }

  void _verifierFinDeManche() {
    if ((scoreTeam1 >= pointsParManche || scoreTeam2 >= pointsParManche) &&
        (scoreTeam1 - scoreTeam2).abs() >= 2) {
      int winner = scoreTeam1 > scoreTeam2 ? 1 : 2;
      _finirManche(winner);
    }
  }

  void _finirManche(int winner) {
    historiqueManches.add(
        Game(manche: manche, scoreTeam1: scoreTeam1, scoreTeam2: scoreTeam2));
    if (winner == 1) {
      manchesGagneesTeam1++;
    } else {
      manchesGagneesTeam2++;
    }

    if (manchesGagneesTeam1 > nombreManches / 2 ||
        manchesGagneesTeam2 > nombreManches / 2) {
      isMatchFinished = true;
      winnerTeam = winner;
      _savePartieToDatabase();
    } else {
      manche++;
      scoreTeam1 = 0;
      scoreTeam2 = 0;
      joueurAuService = null;
      tempsMortTeam1Utilise = false;
      tempsMortTeam2Utilise = false;
    }
    notifyListeners();
  }

  void _savePartieToDatabase() {
    if (_currentPartie != null && winnerTeam != null) {
      partieProvider.savePartie(
        int.parse(_currentPartie!.id),
        winnerTeam!,
        historiqueManches,
      );
    }
  }

  void setServer(String playerName) {
    _enregistrerAction();
    joueurAuService = playerName;
    notifyListeners();
  }

  void utiliserTempsMort(int team) {
    _enregistrerAction();
    if (team == 1) {
      tempsMortTeam1Utilise = true;
    } else {
      tempsMortTeam2Utilise = true;
    }
    notifyListeners();
  }

  void attribuerCarton(String playerId, Carton carton) {
    _enregistrerAction();
    cartons[playerId] = carton;
    notifyListeners();
  }

  void swapSides() {
    isSideSwapped = !isSideSwapped;
    notifyListeners();
  }

  void undoLastPoint() {
    if (historiqueActions.isNotEmpty) {
      var derniereAction = historiqueActions.removeLast();
      manche = derniereAction['manche'];
      scoreTeam1 = derniereAction['scoreTeam1'];
      scoreTeam2 = derniereAction['scoreTeam2'];
      manchesGagneesTeam1 = derniereAction['manchesGagneesTeam1'];
      manchesGagneesTeam2 = derniereAction['manchesGagneesTeam2'];
      joueurAuService = derniereAction['joueurAuService'];
      tempsMortTeam1Utilise = derniereAction['tempsMortTeam1Utilise'];
      tempsMortTeam2Utilise = derniereAction['tempsMortTeam2Utilise'];
      cartons = Map<String, Carton>.from(derniereAction['cartons']);
      isMatchFinished = false;
      winnerTeam = null;
      notifyListeners();
    }
  }

  void resetCurrentManche() {
    _enregistrerAction();
    scoreTeam1 = 0;
    scoreTeam2 = 0;
    joueurAuService = null;
    tempsMortTeam1Utilise = false;
    tempsMortTeam2Utilise = false;
    cartons.clear();
    notifyListeners();
  }

  Carton? getCartonForPlayer(String playerId) {
    return cartons[playerId];
  }

  void _enregistrerAction() {
    historiqueActions.add({
      'manche': manche,
      'scoreTeam1': scoreTeam1,
      'scoreTeam2': scoreTeam2,
      'manchesGagneesTeam1': manchesGagneesTeam1,
      'manchesGagneesTeam2': manchesGagneesTeam2,
      'joueurAuService': joueurAuService,
      'tempsMortTeam1Utilise': tempsMortTeam1Utilise,
      'tempsMortTeam2Utilise': tempsMortTeam2Utilise,
      'cartons': Map<String, Carton>.from(cartons),
    });
  }
}
