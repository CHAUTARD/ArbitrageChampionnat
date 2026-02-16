
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:myapp/src/features/match_selection/team_provider.dart';

class PartieProvider with ChangeNotifier {
  List<Partie> _parties = [];
  final TeamProvider _teamProvider;
  bool _isLoading = true;

  List<Partie> get parties => _parties;
  bool get isLoading => _isLoading;

  PartieProvider(this._teamProvider) {
    if (_teamProvider.isLoading) {
      _teamProvider.addListener(_onTeamProviderReady);
    } else {
      loadParties();
    }
  }

  void _onTeamProviderReady() {
    if (!_teamProvider.isLoading) {
      loadParties();
      _teamProvider.removeListener(_onTeamProviderReady);
    }
  }

  @override
  void dispose() {
    _teamProvider.removeListener(_onTeamProviderReady);
    super.dispose();
  }

  Future<void> loadParties() async {
    try {
      final List<Player> allPlayers = _teamProvider.players;
      if (allPlayers.isEmpty) {
         _parties = [];
         if (kDebugMode) {
          print("PartieProvider: La liste des joueurs est vide. Aucune partie ne sera chargée.");
        }
      } else {
        final jsonString = await rootBundle.loadString('assets/data/parties.json');
        final List<dynamic> partiesJson = json.decode(jsonString);

        _parties = partiesJson.map((json) {
          List<Player> team1 = (json['equipe1'] as List<dynamic>)
              .map((playerLetter) =>
                  _findPlayerByLetter(playerLetter.toString(), allPlayers))
              .toList();

          List<Player> team2 = (json['equipe2'] as List<dynamic>)
              .map((playerLetter) =>
                  _findPlayerByLetter(playerLetter.toString(), allPlayers))
              .toList();

          Player? arbitre;
          if (json['arbitre'] != null) {
            arbitre = _findPlayerByLetter(json['arbitre'].toString(), allPlayers);
          }

          return Partie(
            numero: json['numero'] as int,
            name: json['nom'] as String,
            team1Players: team1,
            team2Players: team2,
            arbitre: arbitre,
          );
        }).toList();
        if (kDebugMode) {
          print('PartieProvider: ${_parties.length} parties chargées.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du chargement des parties: $e');
      }
      _parties = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Player _findPlayerByLetter(String letter, List<Player> players) {
    return players.firstWhere(
      (p) => p.letter == letter,
      orElse: () {
        if (kDebugMode) {
          print("Avertissement: Joueur avec la lettre '$letter' non trouvé.");
        }
        return Player(id: 'unknown', name: 'Joueur inconnu', letter: letter);
      },
    );
  }

  void updateDoublesComposition(
    List<Player> double1Team1,
    List<Player> double1Team2,
  ) {
    final allTeam1 = _teamProvider.equipe1;
    final allTeam2 = _teamProvider.equipe2;

    final double2Team1 = allTeam1.where((p) => !double1Team1.contains(p)).toList();
    final double2Team2 = allTeam2.where((p) => !double1Team2.contains(p)).toList();

    final double1Index = _parties.indexWhere((p) => p.name == 'Double N° 1');
    final double2Index = _parties.indexWhere((p) => p.name == 'Double N° 2');

    if (double1Index != -1) {
      _parties[double1Index] = Partie(
        numero: _parties[double1Index].numero,
        name: _parties[double1Index].name,
        team1Players: double1Team1,
        team2Players: double1Team2,
      );
    }

    if (double2Index != -1) {
      _parties[double2Index] = Partie(
        numero: _parties[double2Index].numero,
        name: _parties[double2Index].name,
        team1Players: double2Team1,
        team2Players: double2Team2,
      );
    }

    notifyListeners();
  }
}
