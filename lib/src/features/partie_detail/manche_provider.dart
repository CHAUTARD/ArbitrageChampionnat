import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/core/data/database.dart' as db;
import 'package:myapp/src/features/partie_detail/manche_model.dart';
import 'package:drift/drift.dart';

class MancheProvider with ChangeNotifier {
  final db.AppDatabase database;
  List<Manche> _manches = [];
  bool _isLoading = false;

  MancheProvider({required this.database});

  List<Manche> get manches => _manches;
  bool get isLoading => _isLoading;

  Future<void> loadManches(int partieId) async {
    _isLoading = true;
    notifyListeners();

    final manchesFromDb = await (database.select(database.manches)..where((tbl) => tbl.partieId.equals(partieId))).get();
    _manches = manchesFromDb.map((m) => Manche(
      id: m.id,
      partieId: m.partieId,
      numeroManche: m.numeroManche,
      scoreTeam1: m.scoreTeam1,
      scoreTeam2: m.scoreTeam2,
      pointGagne1: m.pointGagne1,
      pointGagne2: m.pointGagne2,
    )).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addManche(int partieId, int numeroManche, int score1, int score2) async {
    await database.into(database.manches).insert(db.ManchesCompanion(
      partieId: Value(partieId),
      numeroManche: Value(numeroManche),
      scoreTeam1: Value(score1),
      scoreTeam2: Value(score2),
    ));
    await loadManches(partieId);
  }

  Future<void> updateManche(Manche manche) async {
    await (database.update(database.manches)..where((tbl) => tbl.id.equals(manche.id))).write(
      db.ManchesCompanion(
        scoreTeam1: Value(manche.scoreTeam1),
        scoreTeam2: Value(manche.scoreTeam2),
      ),
    );
    await loadManches(manche.partieId);
  }

}
