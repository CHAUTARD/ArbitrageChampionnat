import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/core/data/database.dart';
import 'package:myapp/src/features/match_selection/partie_provider.dart';
import 'package:myapp/src/features/rencontre/rencontre_model.dart';
import 'package:drift/drift.dart';

class RencontreProvider with ChangeNotifier {
  final AppDatabase db;
  final PartieProvider partieProvider;
  bool _isLoading = true;
  List<RencontreAvecEquipes> _rencontres = [];

  RencontreProvider({required this.db, required this.partieProvider}) {
    loadRencontres();
  }

  List<RencontreAvecEquipes> get rencontres => _rencontres;
  bool get isLoading => _isLoading;

  Future<void> loadRencontres() async {
    _isLoading = true;
    notifyListeners();

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

    _rencontres = loadedRencontres;

    if (_rencontres.isEmpty) {
      await createDefaultRencontre();
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createNewRencontre(String nomEquipe1, String nomEquipe2, Map<String, String> playerNames) async {
    final players = {
      'A1': await db.into(db.players).insert(PlayersCompanion.insert(name: playerNames['A1']!)),
      'A2': await db.into(db.players).insert(PlayersCompanion.insert(name: playerNames['A2']!)),
      'A3': await db.into(db.players).insert(PlayersCompanion.insert(name: playerNames['A3']!)),
      'A4': await db.into(db.players).insert(PlayersCompanion.insert(name: playerNames['A4']!)),
      'B1': await db.into(db.players).insert(PlayersCompanion.insert(name: playerNames['B1']!)),
      'B2': await db.into(db.players).insert(PlayersCompanion.insert(name: playerNames['B2']!)),
      'B3': await db.into(db.players).insert(PlayersCompanion.insert(name: playerNames['B3']!)),
      'B4': await db.into(db.players).insert(PlayersCompanion.insert(name: playerNames['B4']!)),
    };

    final equipe1Id = await db.into(db.equipes).insert(EquipesCompanion.insert(name: nomEquipe1));
    final equipe2Id = await db.into(db.equipes).insert(EquipesCompanion.insert(name: nomEquipe2));

    final rencontreId = await db.into(db.rencontres).insert(RencontresCompanion.insert(
          equipe1Id: Value(equipe1Id),
          equipe2Id: Value(equipe2Id),
          niveau: Niveau.departemental,
          date: Value(DateTime.now()),
        ));

    await _createPartiesForRencontre(rencontreId, players);

    await loadRencontres();
    await partieProvider.loadData();
  }

  Future<void> createDefaultRencontre() async {
    final defaultPlayers = {
      'A1': 'Joueur A1', 'A2': 'Joueur A2', 'A3': 'Joueur A3', 'A4': 'Joueur A4',
      'B1': 'Joueur B1', 'B2': 'Joueur B2', 'B3': 'Joueur B3', 'B4': 'Joueur B4',
    };
    await createNewRencontre('Équipe A', 'Équipe B', defaultPlayers);
  }

  Future<void> _createPartiesForRencontre(int rencontreId, Map<String, int> players) async {
    await partieProvider.createPartieForRencontre(rencontreId, 1, players['A1']!, null, players['B1']!, null, players['A2']);
    await partieProvider.createPartieForRencontre(rencontreId, 2, players['A2']!, null, players['B2']!, null, players['A1']);
    await partieProvider.createPartieForRencontre(rencontreId, 3, players['A3']!, null, players['B3']!, null, players['A4']);
    await partieProvider.createPartieForRencontre(rencontreId, 4, players['A4']!, null, players['B4']!, null, players['A3']);
    await partieProvider.createPartieForRencontre(rencontreId, 5, players['A1']!, null, players['B2']!, null, players['B1']);
    await partieProvider.createPartieForRencontre(rencontreId, 6, players['A2']!, null, players['B1']!, null, players['B2']);
    await partieProvider.createPartieForRencontre(rencontreId, 7, players['A3']!, null, players['B4']!, null, players['B3']);
    await partieProvider.createPartieForRencontre(rencontreId, 8, players['A4']!, null, players['B3']!, null, players['B4']);
    await partieProvider.createPartieForRencontre(rencontreId, 9, players['A1']!, players['A3'], players['B1']!, players['B3'], null);
    await partieProvider.createPartieForRencontre(rencontreId, 10, players['A2']!, players['A4'], players['B2']!, players['B4'], null);
    await partieProvider.createPartieForRencontre(rencontreId, 11, players['A1']!, null, players['B3']!, null, null);
    await partieProvider.createPartieForRencontre(rencontreId, 12, players['A3']!, null, players['B1']!, null, null);
    await partieProvider.createPartieForRencontre(rencontreId, 13, players['A2']!, null, players['B4']!, null, null);
    await partieProvider.createPartieForRencontre(rencontreId, 14, players['A4']!, null, players['B2']!, null, null);
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
    await partieProvider.loadData();
  }

  Future<void> resetAndCreateDefault() async {
    _isLoading = true;
    notifyListeners();
    await partieProvider.resetData();
    await createDefaultRencontre();
  }
}
