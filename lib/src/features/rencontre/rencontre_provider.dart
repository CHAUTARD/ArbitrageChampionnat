// lib/src/features/rencontre/rencontre_provider.dart
//
// Fournit la logique de gestion des rencontres.
// Gère la création, le chargement, la mise à jour et la suppression des rencontres,
// ainsi que la création des parties associées.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/core/data/database.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/rencontre/rencontre_model.dart';
import 'package:drift/drift.dart';

final rencontreProvider = StateNotifierProvider<RencontreNotifier, RencontreState>((ref) {
  return RencontreNotifier(ref.watch(partieProvider.notifier));
});

class RencontreState {
  final bool isLoading;
  final List<RencontreAvecEquipes> rencontres;

  RencontreState({this.isLoading = true, this.rencontres = const []});

  RencontreState copyWith({
    bool? isLoading,
    List<RencontreAvecEquipes>? rencontres,
  }) {
    return RencontreState(
      isLoading: isLoading ?? this.isLoading,
      rencontres: rencontres ?? this.rencontres,
    );
  }
}

class RencontreNotifier extends StateNotifier<RencontreState> {
  final PartieNotifier _partieNotifier;
  final AppDatabase db = AppDatabase();

  RencontreNotifier(this._partieNotifier) : super(RencontreState()) {
    loadRencontres();
  }

  Future<void> loadRencontres() async {
    state = state.copyWith(isLoading: true);

    final allRencontres = await db.select(db.rencontres).get();
    final List<RencontreAvecEquipes> loadedRencontres = [];

    for (final r in allRencontres) {
      final equipe1 = await (db.select(db.equipes)..where((tbl) => tbl.id.equals(r.equipe1Id))).getSingle();
      final equipe2 = await (db.select(db.equipes)..where((tbl) => tbl.id.equals(r.equipe2Id))).getSingle();
      loadedRencontres.add(RencontreAvecEquipes(
        rencontre: r,
        nomEquipe1: equipe1.name,
        nomEquipe2: equipe2.name,
        date: r.date,
      ));
    }

    if (loadedRencontres.isEmpty) {
      await createDefaultRencontre();
    } else {
      state = state.copyWith(isLoading: false, rencontres: loadedRencontres);
    }
  }

  Future<void> createNewRencontre(String nomEquipe1, String nomEquipe2, Map<String, String> playerNames) async {
    final equipe1Id = await db.into(db.equipes).insert(EquipesCompanion.insert(name: nomEquipe1));
    final equipe2Id = await db.into(db.equipes).insert(EquipesCompanion.insert(name: nomEquipe2));

    final Map<String, int> playerIds = {};
    for (var entry in playerNames.entries) {
      final key = entry.key;
      final name = entry.value;
      final equipeId = key.startsWith('A') ? equipe1Id : equipe2Id;
      final newPlayerId = await db.into(db.players).insert(
        PlayersCompanion.insert(
          name: name,
          letter: key,
          equipeId: equipeId,
        ),
      );
      playerIds[key] = newPlayerId;
    }

    final rencontreId = await db.into(db.rencontres).insert(RencontresCompanion.insert(
          equipe1Id: equipe1Id,
          equipe2Id: equipe2Id,
          niveau: Niveau.departemental,
          date: DateTime.now(),
        ));

    await _createPartiesForRencontre(rencontreId, playerIds);
    await loadRencontres();
    await _partieNotifier.getPartiesForRencontre(rencontreId);
  }

  Future<void> createDefaultRencontre() async {
    final defaultPlayers = {
      'A1': 'Joueur A1', 'A2': 'Joueur A2', 'A3': 'Joueur A3', 'A4': 'Joueur A4',
      'B1': 'Joueur B1', 'B2': 'Joueur B2', 'B3': 'Joueur B3', 'B4': 'Joueur B4',
    };
    await createNewRencontre('Équipe A', 'Équipe B', defaultPlayers);
  }

  Future<void> _createPartiesForRencontre(int rencontreId, Map<String, int> players) async {
    await _partieNotifier.createPartieForRencontre(rencontreId, 1, players['A1']!, null, players['B1']!, null, players['A2']);
    await _partieNotifier.createPartieForRencontre(rencontreId, 2, players['A2']!, null, players['B2']!, null, players['A1']);
    await _partieNotifier.createPartieForRencontre(rencontreId, 3, players['A3']!, null, players['B3']!, null, players['A4']);
    await _partieNotifier.createPartieForRencontre(rencontreId, 4, players['A4']!, null, players['B4']!, null, players['A3']);
    await _partieNotifier.createPartieForRencontre(rencontreId, 5, players['A1']!, null, players['B2']!, null, players['B1']);
    await _partieNotifier.createPartieForRencontre(rencontreId, 6, players['A2']!, null, players['B1']!, null, players['B2']);
    await _partieNotifier.createPartieForRencontre(rencontreId, 7, players['A3']!, null, players['B4']!, null, players['B3']);
    await _partieNotifier.createPartieForRencontre(rencontreId, 8, players['A4']!, null, players['B3']!, null, players['B4']);
    await _partieNotifier.createPartieForRencontre(rencontreId, 9, players['A1']!, players['A3'], players['B1']!, players['B3'], null);
    await _partieNotifier.createPartieForRencontre(rencontreId, 10, players['A2']!, players['A4'], players['B2']!, players['B4'], null);
    await _partieNotifier.createPartieForRencontre(rencontreId, 11, players['A1']!, null, players['B3']!, null, null);
    await _partieNotifier.createPartieForRencontre(rencontreId, 12, players['A3']!, null, players['B1']!, null, null);
    await _partieNotifier.createPartieForRencontre(rencontreId, 13, players['A2']!, null, players['B4']!, null, null);
    await _partieNotifier.createPartieForRencontre(rencontreId, 14, players['A4']!, null, players['B2']!, null, null);
  }

  Future<void> deleteRencontre(int rencontreId) async {
    await (db.delete(db.parties)..where((tbl) => tbl.rencontreId.equals(rencontreId))).go();
    await (db.delete(db.rencontres)..where((tbl) => tbl.id.equals(rencontreId))).go();
    await loadRencontres();
  }

  Future<void> updatePlayerNames(Map<int, String> playerNames) async {
    for (final entry in playerNames.entries) {
      await (db.update(db.players)..where((tbl) => tbl.id.equals(entry.key)))
          .write(PlayersCompanion(name: Value(entry.value)));
    }
    final rencontreId = state.rencontres.first.rencontre.id;
    await _partieNotifier.getPartiesForRencontre(rencontreId);
  }

  Future<void> resetAndCreateDefault() async {
    state = state.copyWith(isLoading: true);
    await (db.delete(db.parties)..where((tbl) => tbl.id.isNotNull())).go();
    await (db.delete(db.rencontres)..where((tbl) => tbl.id.isNotNull())).go();
    await createDefaultRencontre();
  }
}
