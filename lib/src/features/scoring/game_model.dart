
import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';

class GameModel extends ChangeNotifier {
  List<Player> team1;
  List<Player> team2;
  String team1Name;
  String team2Name;

  int team1Score = 0;
  int team2Score = 0;
  List<String> setScores = [];

  Player? server;
  Player? receiver;

  GameModel({
    required this.team1,
    required this.team2,
    required this.team1Name,
    required this.team2Name,
    required this.server,
    required this.receiver,
  });

  void incrementScore(int teamNumber) {
    if (teamNumber == 1) {
      team1Score++;
    } else {
      team2Score++;
    }

    _checkSetWin();

    if ((team1Score + team2Score) > 0 && (team1Score + team2Score) % 2 == 0) {
      _rotateServer();
    }

    notifyListeners();
  }

  void _checkSetWin() {
    if ((team1Score >= 11 && (team1Score - team2Score) >= 2) || 
        (team2Score >= 11 && (team2Score - team1Score) >= 2)) {
      setScores.add('$team1Score-$team2Score');
      team1Score = 0;
      team2Score = 0;
    }
  }

  void decrementScore(int teamNumber) {
    if (teamNumber == 1) {
      if (team1Score > 0) team1Score--;
    } else {
      if (team2Score > 0) team2Score--;
    }
    notifyListeners();
  }

  void resetScores() {
    team1Score = 0;
    team2Score = 0;
    setScores = [];
    notifyListeners();
  }

  void swapTeams() {
    final tempTeam = team1;
    team1 = team2;
    team2 = tempTeam;

    final tempName = team1Name;
    team1Name = team2Name;
    team2Name = tempName;

    server = team1[0];
    receiver = team2[0];

    notifyListeners();
  }

  void toggleInitialServer() {
    final temp = server;
    server = receiver;
    receiver = temp;
    notifyListeners();
  }

  void _rotateServer() {
    // CORRECTION: Variable 'oldServer' inutilisée supprimée.
    if (team1.length == 1) { // Singles
      final temp = server;
      server = receiver;
      receiver = temp;
    } else { // Doubles
      if (server == team1[0]) {
        server = team2[0];
        receiver = team1[1];
      } else if (server == team2[0]) {
        server = team1[1];
        receiver = team2[1];
      } else if (server == team1[1]) {
        server = team2[1];
        receiver = team1[0];
      } else if (server == team2[1]) {
        server = team1[0];
        receiver = team2[0];
      }
    }
  }
}
