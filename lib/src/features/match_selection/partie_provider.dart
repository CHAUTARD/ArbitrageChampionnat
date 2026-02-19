import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/core/data/database.dart';
import 'package:drift/drift.dart';
import 'package:myapp/src/features/partie_detail/partie_model.dart';

class PartieProvider with ChangeNotifier {
  final AppDatabase db;
  List<PartieAvecJoueurs> _parties = [];
  bool _isLoading = true;

  PartieProvider({required this.db}) {
    loadData();
  }

  List<PartieAvecJoueurs> get parties => _parties;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    final allParties = await db.select(db.parties).get();
    final List<PartieAvecJoueurs> loadedParties = [];

    for (final p in allParties) {
      final team1Players = await _getPlayers(p.joueur1Equipe1Id, p.joueur2Equipe1Id);
      final team2Players = await _getPlayers(p.joueur1Equipe2Id, p.joueur2Equipe2Id);
      final arbitre = p.arbitreId == null ? null : await _getPlayer(p.arbitreId!); 

      loadedParties.add(PartieAvecJoueurs(
        partie: p,
        team1Players: team1Players,
        team2Players: team2Players,
        arbitreName: arbitre?.name,
        numeroPartie: p.partieNumber,
      ));
    }

    _parties = loadedParties;
    _isLoading = false;
    notifyListeners();
  }

  Future<Player?> _getPlayer(int id) async {
    return await (db.select(db.players)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<Player>> _getPlayers(int player1Id, int? player2Id) async {
    final p1 = await _getPlayer(player1Id);
    final players = [p1!];
    if (player2Id != null) {
      final p2 = await _getPlayer(player2Id);
      if (p2 != null) players.add(p2);
    }
    return players;
  }

  List<PartieAvecJoueurs> getPartiesForRencontre(int rencontreId) {
    return _parties.where((p) => p.partie.rencontreId == rencontreId).toList();
  }

  Future<void> resetData() async {
    _isLoading = true;
    notifyListeners();

    await db.delete(db.scores).go();
    await db.delete(db.parties).go();
    await db.delete(db.rencontres).go();
    await db.delete(db.equipes).go();
    await db.delete(db.players).go();

    _parties = [];
    _isLoading = false;
    notifyListeners();
  }

  Future<int> createPartieForRencontre(
    int rencontreId,
    int partieNumber,
    int j1e1, int? j2e1,
    int j1e2, int? j2e2,
    int? arbitreId,
  ) async {
    final partieId = await db.into(db.parties).insert(
          PartiesCompanion.insert(
            rencontreId: rencontreId,
            partieNumber: partieNumber,
            joueur1Equipe1Id: j1e1,
            joueur2Equipe1Id: Value(j2e1),
            joueur1Equipe2Id: j1e2,
            joueur2Equipe2Id: Value(j2e2),
            arbitreId: Value(arbitreId),
          ),
        );
    return partieId;
  }

  Future<Map<String, List<Player>>> getPlayersForRencontre(int rencontreId) async {
    final partiesOfRencontre = getPartiesForRencontre(rencontreId);
    if (partiesOfRencontre.isEmpty) return {'equipe1': [], 'equipe2': []};

    final Set<Player> equipe1Players = {};
    final Set<Player> equipe2Players = {};

    for (final partie in partiesOfRencontre) {
      equipe1Players.addAll(partie.team1Players);
      equipe2Players.addAll(partie.team2Players);
    }

    return {
      'equipe1': equipe1Players.toList(),
      'equipe2': equipe2Players.toList(),
    };
  }
}
