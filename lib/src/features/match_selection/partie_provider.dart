import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/core/data/database.dart';
import 'package:drift/drift.dart';
import 'package:myapp/src/features/scoring/game_model.dart';

// Nouvelle classe pour contenir les détails complets d'une partie
class PartieDetails {
  final Partie partie;
  final String? joueur1Equipe1Name;
  final String? joueur2Equipe1Name;
  final String? joueur1Equipe2Name;
  final String? joueur2Equipe2Name;
  final String? arbitreName;

  PartieDetails({
    required this.partie,
    this.joueur1Equipe1Name,
    this.joueur2Equipe1Name,
    this.joueur1Equipe2Name,
    this.joueur2Equipe2Name,
    this.arbitreName,
  });
}

class PartieProvider with ChangeNotifier {
  final AppDatabase db;
  List<PartieDetails> _partiesDetails = [];
  bool _isLoading = true;

  PartieProvider({required this.db}) {
    loadData();
  }

  List<PartieDetails> get parties => _partiesDetails;
  bool get isLoading => _isLoading;

  Future<List<Player>> get allPlayers => db.select(db.players).get();

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    final j1e1 = db.alias(db.players, 'j1e1');
    final j2e1 = db.alias(db.players, 'j2e1');
    final j1e2 = db.alias(db.players, 'j1e2');
    final j2e2 = db.alias(db.players, 'j2e2');
    final arbitre = db.alias(db.players, 'arbitre');

    final query = db.select(db.parties).join([
      leftOuterJoin(j1e1, j1e1.id.equalsExp(db.parties.joueur1Equipe1Id)),
      leftOuterJoin(j2e1, j2e1.id.equalsExp(db.parties.joueur2Equipe1Id)),
      leftOuterJoin(j1e2, j1e2.id.equalsExp(db.parties.joueur1Equipe2Id)),
      leftOuterJoin(j2e2, j2e2.id.equalsExp(db.parties.joueur2Equipe2Id)),
      leftOuterJoin(arbitre, arbitre.id.equalsExp(db.parties.arbitreId)),
    ]);

    final result = await query.get();

    _partiesDetails = result.map((row) {
      return PartieDetails(
        partie: row.readTable(db.parties),
        joueur1Equipe1Name: row.readTableOrNull(j1e1)?.name,
        joueur2Equipe1Name: row.readTableOrNull(j2e1)?.name,
        joueur1Equipe2Name: row.readTableOrNull(j1e2)?.name,
        joueur2Equipe2Name: row.readTableOrNull(j2e2)?.name,
        arbitreName: row.readTableOrNull(arbitre)?.name,
      );
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  List<PartieDetails> getPartiesForRencontre(int rencontreId) {
    return _partiesDetails
        .where((p) => p.partie.rencontreId == rencontreId)
        .toList();
  }

  Future<void> resetData() async {
    _isLoading = true;
    notifyListeners();
    // Utilise une transaction pour assurer la cohérence
    await db.transaction(() async {
      await db.delete(db.parties).go();
      await db.delete(db.rencontres).go();
      await db.delete(db.equipes).go();
      await db.delete(db.players).go();
    });
    _partiesDetails = [];
    _isLoading = false;
    notifyListeners();
  }

  Future<int> createPartieForRencontre(
    int rencontreId,
    int partieNumber,
    int j1e1,
    int? j2e1,
    int j1e2,
    int? j2e2,
    int? arbitreId,
  ) async {
    final partieId = await db
        .into(db.parties)
        .insert(
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

  Future<Map<String, List<Player>>> getPlayersForRencontre(
    int rencontreId,
  ) async {
    final rencontre = await (db.select(
      db.rencontres,
    )..where((r) => r.id.equals(rencontreId))).getSingleOrNull();
    if (rencontre == null) return {'equipe1': [], 'equipe2': []};

    final equipe1Players = await (db.select(
      db.players,
    )..where((p) => p.equipeId.equals(rencontre.equipe1Id))).get();
    final equipe2Players = await (db.select(
      db.players,
    )..where((p) => p.equipeId.equals(rencontre.equipe2Id))).get();

    return {'equipe1': equipe1Players, 'equipe2': equipe2Players};
  }

  Future<void> updatePlayerName(int playerId, String newName) async {
    await (db.update(db.players)..where((p) => p.id.equals(playerId))).write(
      PlayersCompanion(name: Value(newName)),
    );
    await loadData(); // Recharge les données pour refléter le changement
  }

  Future<void> updateDoublesComposition(
    int partieId,
    int j1e1,
    int? j2e1,
    int j1e2,
    int? j2e2,
  ) async {
    await (db.update(db.parties)..where((p) => p.id.equals(partieId))).write(
      PartiesCompanion(
        joueur1Equipe1Id: Value(j1e1),
        joueur2Equipe1Id: Value(j2e1),
        joueur1Equipe2Id: Value(j1e2),
        joueur2Equipe2Id: Value(j2e2),
      ),
    );
    await loadData();
  }

  Future<void> savePartie(int partieId, int winner, List<Game> sets) async {
    await db.transaction(() async {
      // 1. Update the Partie status
      await (db.update(db.parties)..where((p) => p.id.equals(partieId))).write(
        PartiesCompanion(isPlayed: const Value(true), winner: Value(winner)),
      );

      // 2. Delete old scores for this partie to avoid duplicates
      await (db.delete(
        db.scores,
      )..where((s) => s.partieId.equals(partieId))).go();

      // 3. Insert new scores for each set
      for (final set in sets) {
        await db
            .into(db.scores)
            .insert(
              ScoresCompanion.insert(
                partieId: partieId,
                setNumber: set.manche,
                scoreEquipe1: set.scoreTeam1,
                scoreEquipe2: set.scoreTeam2,
              ),
            );
      }
    });

    await loadData(); // Refresh data to reflect the changes in the UI
  }
}
