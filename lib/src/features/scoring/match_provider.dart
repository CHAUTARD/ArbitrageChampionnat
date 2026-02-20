import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/scoring/game_model.dart';

enum Carton { jaune, jauneRouge, rouge }

final matchProvider = StateNotifierProvider.autoDispose<MatchNotifier, MatchState>((ref) {
  final partieNotifier = ref.watch(partieProvider.notifier);
  return MatchNotifier(partieNotifier);
});

class MatchState {
  final int manche;
  final int scoreTeam1;
  final int scoreTeam2;
  final int manchesGagneesTeam1;
  final int manchesGagneesTeam2;
  final String? joueurAuService;
  final bool tempsMortTeam1Utilise;
  final bool tempsMortTeam2Utilise;
  final Map<String, Carton> cartons;
  final bool isSideSwapped;
  final bool isMatchFinished;
  final int? winnerTeam;
  final Partie? currentPartie;

  MatchState({
    this.manche = 1,
    this.scoreTeam1 = 0,
    this.scoreTeam2 = 0,
    this.manchesGagneesTeam1 = 0,
    this.manchesGagneesTeam2 = 0,
    this.joueurAuService,
    this.tempsMortTeam1Utilise = false,
    this.tempsMortTeam2Utilise = false,
    this.cartons = const {},
    this.isSideSwapped = false,
    this.isMatchFinished = false,
    this.winnerTeam,
    this.currentPartie,
  });

  MatchState copyWith({
    int? manche,
    int? scoreTeam1,
    int? scoreTeam2,
    int? manchesGagneesTeam1,
    int? manchesGagneesTeam2,
    String? joueurAuService,
    bool? tempsMortTeam1Utilise,
    bool? tempsMortTeam2Utilise,
    Map<String, Carton>? cartons,
    bool? isSideSwapped,
    bool? isMatchFinished,
    int? winnerTeam,
    Partie? currentPartie,
  }) {
    return MatchState(
      manche: manche ?? this.manche,
      scoreTeam1: scoreTeam1 ?? this.scoreTeam1,
      scoreTeam2: scoreTeam2 ?? this.scoreTeam2,
      manchesGagneesTeam1: manchesGagneesTeam1 ?? this.manchesGagneesTeam1,
      manchesGagneesTeam2: manchesGagneesTeam2 ?? this.manchesGagneesTeam2,
      joueurAuService: joueurAuService ?? this.joueurAuService,
      tempsMortTeam1Utilise: tempsMortTeam1Utilise ?? this.tempsMortTeam1Utilise,
      tempsMortTeam2Utilise: tempsMortTeam2Utilise ?? this.tempsMortTeam2Utilise,
      cartons: cartons ?? this.cartons,
      isSideSwapped: isSideSwapped ?? this.isSideSwapped,
      isMatchFinished: isMatchFinished ?? this.isMatchFinished,
      winnerTeam: winnerTeam ?? this.winnerTeam,
      currentPartie: currentPartie ?? this.currentPartie,
    );
  }
}

class MatchNotifier extends StateNotifier<MatchState> {
  final PartieNotifier _partieNotifier;
  final int nombreManches = 5;
  final int pointsParManche = 11;
  List<Game> historiqueManches = [];
  List<MatchState> historiqueActions = [];

  MatchNotifier(this._partieNotifier) : super(MatchState());

  void startMatch(Partie partie) {
    state = MatchState(currentPartie: partie);
  }

  void incrementScore(int team) {
    _enregistrerAction();
    if (team == 1) {
      state = state.copyWith(scoreTeam1: state.scoreTeam1 + 1);
    } else {
      state = state.copyWith(scoreTeam2: state.scoreTeam2 + 1);
    }
    _verifierFinDeManche();
  }

  void decrementScore(int team) {
    _enregistrerAction();
    if (team == 1) {
      if (state.scoreTeam1 > 0) {
        state = state.copyWith(scoreTeam1: state.scoreTeam1 - 1);
      }
    } else {
      if (state.scoreTeam2 > 0) {
        state = state.copyWith(scoreTeam2: state.scoreTeam2 - 1);
      }
    }
  }

  void _verifierFinDeManche() {
    if ((state.scoreTeam1 >= pointsParManche || state.scoreTeam2 >= pointsParManche) &&
        (state.scoreTeam1 - state.scoreTeam2).abs() >= 2) {
      int winner = state.scoreTeam1 > state.scoreTeam2 ? 1 : 2;
      _finirManche(winner);
    }
  }

  void _finirManche(int winner) {
    historiqueManches.add(Game(manche: state.manche, scoreTeam1: state.scoreTeam1, scoreTeam2: state.scoreTeam2));
    if (winner == 1) {
      state = state.copyWith(manchesGagneesTeam1: state.manchesGagneesTeam1 + 1);
    } else {
      state = state.copyWith(manchesGagneesTeam2: state.manchesGagneesTeam2 + 1);
    }

    if (state.manchesGagneesTeam1 > nombreManches / 2 || state.manchesGagneesTeam2 > nombreManches / 2) {
      state = state.copyWith(isMatchFinished: true, winnerTeam: winner);
      _savePartieToDatabase();
    } else {
      state = state.copyWith(manche: state.manche + 1, scoreTeam1: 0, scoreTeam2: 0, joueurAuService: null, tempsMortTeam1Utilise: false, tempsMortTeam2Utilise: false);
    }
  }

  void _savePartieToDatabase() {
    if (state.currentPartie != null && state.winnerTeam != null) {
      _partieNotifier.savePartie(
        int.parse(state.currentPartie!.id),
        state.winnerTeam!,
        historiqueManches,
      );
    }
  }

  void setServer(String playerName) {
    _enregistrerAction();
    state = state.copyWith(joueurAuService: playerName);
  }

  void utiliserTempsMort(int team) {
    _enregistrerAction();
    if (team == 1) {
      state = state.copyWith(tempsMortTeam1Utilise: true);
    } else {
      state = state.copyWith(tempsMortTeam2Utilise: true);
    }
  }

  void attribuerCarton(String playerId, Carton carton) {
    _enregistrerAction();
    final newCartons = Map<String, Carton>.from(state.cartons);
    newCartons[playerId] = carton;
    state = state.copyWith(cartons: newCartons);
  }

  void swapSides() {
    state = state.copyWith(isSideSwapped: !state.isSideSwapped);
  }

  void undoLastPoint() {
    if (historiqueActions.isNotEmpty) {
      state = historiqueActions.removeLast();
    }
  }

  void resetCurrentManche() {
    _enregistrerAction();
    state = state.copyWith(scoreTeam1: 0, scoreTeam2: 0, joueurAuService: null, tempsMortTeam1Utilise: false, tempsMortTeam2Utilise: false, cartons: {});
  }

  Carton? getCartonForPlayer(String playerId) {
    return state.cartons[playerId];
  }

  void _enregistrerAction() {
    historiqueActions.add(state);
  }
}
