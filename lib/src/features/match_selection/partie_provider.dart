// lib/src/features/match_selection/partie_provider.dart
//
// Fournit la logique de gestion des parties (matchs).
// Gère la création, la récupération, la mise à jour et la suppression des parties
// en interagissant avec la base de données.

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/core/data/database.dart' as db;
import 'package:myapp/src/features/match_selection/partie_model.dart' as model;
import 'package:myapp/src/features/scoring/game_model.dart';
import 'package:myapp/src/features/match_selection/player_model.dart'
    as player_model;

final partieProvider =
    StateNotifierProvider<PartieNotifier, List<model.Partie>>((ref) {
      return PartieNotifier();
    });

class PartieNotifier extends StateNotifier<List<model.Partie>> {
  PartieNotifier() : super([]);

  final _db = db.AppDatabase();

  Future<void> getPartiesForRencontre(int rencontreId) async {
    final parties = await (_db.select(
      _db.parties,
    )..where((p) => p.rencontreId.equals(rencontreId))).get();

    final List<model.Partie> partiesWithPlayers = [];

    for (var p in parties) {
      final j1e1 = await (_db.select(
        _db.players,
      )..where((pl) => pl.id.equals(p.joueur1Equipe1Id))).getSingle();
      final j2e1 = p.joueur2Equipe1Id == null
          ? null
          : await (_db.select(
              _db.players,
            )..where((pl) => pl.id.equals(p.joueur2Equipe1Id!))).getSingle();
      final j1e2 = await (_db.select(
        _db.players,
      )..where((pl) => pl.id.equals(p.joueur1Equipe2Id))).getSingle();
      final j2e2 = p.joueur2Equipe2Id == null
          ? null
          : await (_db.select(
              _db.players,
            )..where((pl) => pl.id.equals(p.joueur2Equipe2Id!))).getSingle();
      final arbitre = p.arbitreId == null
          ? null
          : await (_db.select(
              _db.players,
            )..where((pl) => pl.id.equals(p.arbitreId!))).getSingle();

      partiesWithPlayers.add(
        model.Partie(
          id: p.id.toString(),
          rencontreId: p.rencontreId,
          numeroPartie: p.partieNumber,
          team1Players: [
            player_model.Player(
              id: j1e1.id.toString(),
              name: j1e1.name,
              equipeId: j1e1.equipeId.toString(),
            ),
            if (j2e1 != null)
              player_model.Player(
                id: j2e1.id.toString(),
                name: j2e1.name,
                equipeId: j2e1.equipeId.toString(),
              ),
          ],
          team2Players: [
            player_model.Player(
              id: j1e2.id.toString(),
              name: j1e2.name,
              equipeId: j1e2.equipeId.toString(),
            ),
            if (j2e2 != null)
              player_model.Player(
                id: j2e2.id.toString(),
                name: j2e2.name,
                equipeId: j2e2.equipeId.toString(),
              ),
          ],
          arbitreId: arbitre?.id.toString(),
          arbitreName: arbitre?.name,
        ),
      );
    }
    state = partiesWithPlayers;
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
    return await _db
        .into(_db.parties)
        .insert(
          db.PartiesCompanion.insert(
            rencontreId: rencontreId,
            partieNumber: partieNumber,
            joueur1Equipe1Id: j1e1,
            joueur2Equipe1Id: Value(j2e1),
            joueur1Equipe2Id: j1e2,
            joueur2Equipe2Id: Value(j2e2),
            arbitreId: Value(arbitreId),
          ),
        );
  }

  Future<void> savePartie(
    int partieId,
    int winnerTeam,
    List<Game> manches,
  ) async {
    await (_db.update(_db.parties)..where((p) => p.id.equals(partieId))).write(
      db.PartiesCompanion(winner: Value(winnerTeam)),
    );

    for (var manche in manches) {
      await _db
          .into(_db.manches)
          .insert(
            db.ManchesCompanion.insert(
              partieId: partieId,
              mancheNumber: Value(manche.manche),
              scoreEquipe1: manche.scoreTeam1,
              scoreEquipe2: manche.scoreTeam2,
            ),
          );
    }
  }

  Future<Map<String, List<db.Player>>> getPlayersForRencontre(
    int rencontreId,
  ) async {
    final rencontre = await (_db.select(
      _db.rencontres,
    )..where((r) => r.id.equals(rencontreId))).getSingleOrNull();
    if (rencontre == null) {
      return {'equipe1': [], 'equipe2': []};
    }

    final equipe1 = await (_db.select(
      _db.equipes,
    )..where((e) => e.id.equals(rencontre.equipe1Id))).getSingleOrNull();
    final equipe2 = await (_db.select(
      _db.equipes,
    )..where((e) => e.id.equals(rencontre.equipe2Id))).getSingleOrNull();

    if (equipe1 == null || equipe2 == null) {
      return {'equipe1': [], 'equipe2': []};
    }

    final playersE1Data = await (_db.select(
      _db.players,
    )..where((p) => p.equipeId.equals(equipe1.id))).get();
    final playersE2Data = await (_db.select(
      _db.players,
    )..where((p) => p.equipeId.equals(equipe2.id))).get();

    return {'equipe1': playersE1Data, 'equipe2': playersE2Data};
  }

  Future<void> updateDoublesComposition(
    int partieId,
    int j1e1,
    int j2e1,
    int j1e2,
    int j2e2,
  ) async {
    final result =
        await (_db.update(
          _db.parties,
        )..where((p) => p.id.equals(partieId))).write(
          db.PartiesCompanion(
            joueur1Equipe1Id: Value(j1e1),
            joueur2Equipe1Id: Value(j2e1),
            joueur1Equipe2Id: Value(j1e2),
            joueur2Equipe2Id: Value(j2e2),
          ),
        );
    if (result > 0) {
      final partie = await (_db.select(
        _db.parties,
      )..where((p) => p.id.equals(partieId))).getSingle();
      await getPartiesForRencontre(partie.rencontreId);
    }
  }

  Future<void> deletePartie(int partieId) async {
    await (_db.delete(_db.parties)..where((p) => p.id.equals(partieId))).go();
    state = [
      for (final partie in state)
        if (partie.id != partieId.toString()) partie,
    ];
  }
}
