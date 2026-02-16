
// lib/src/features/match_selection/partie_provider.dart
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

          return Partie(
            numero: json['numero'] as int,
            name: json['nom'] as String,
            team1Players: team1,
            team2Players: team2,
          );
        }).toList();
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
}
