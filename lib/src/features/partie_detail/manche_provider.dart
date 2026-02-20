import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/core/data/database.dart';
import 'package:myapp/src/features/partie_detail/manche_model.dart' as model;
import 'package:drift/drift.dart';

final mancheProvider = StateNotifierProvider<MancheNotifier, MancheState>((ref) {
  return MancheNotifier();
});

class MancheState {
  final bool isLoading;
  final List<model.Manche> manches;

  MancheState({this.isLoading = true, this.manches = const []});

  MancheState copyWith({
    bool? isLoading,
    List<model.Manche>? manches,
  }) {
    return MancheState(
      isLoading: isLoading ?? this.isLoading,
      manches: manches ?? this.manches,
    );
  }
}

class MancheNotifier extends StateNotifier<MancheState> {
  final AppDatabase _db = AppDatabase();

  MancheNotifier() : super(MancheState());

  Future<void> loadManches(int partieId) async {
    state = state.copyWith(isLoading: true);
    final manchesFromDb = await (_db.select(_db.manches)
          ..where((m) => m.partieId.equals(partieId)))
        .get();

    final manches = manchesFromDb.map((dbManche) {
      return model.Manche(
        id: dbManche.id,
        partieId: dbManche.partieId,
        numeroManche: dbManche.mancheNumber,
        scoreTeam1: dbManche.scoreEquipe1,
        scoreTeam2: dbManche.scoreEquipe2,
      );
    }).toList();

    state = state.copyWith(isLoading: false, manches: manches);
  }

  Future<void> addManche(
      int partieId, int numeroManche, int score1, int score2) async {
    await _db.into(_db.manches).insert(
          ManchesCompanion.insert(
            partieId: partieId,
            mancheNumber: Value(numeroManche),
            scoreEquipe1: score1,
            scoreEquipe2: score2,
          ),
        );
    await loadManches(partieId); // Reload to update state
  }

  Future<void> updateManche(int partieId, model.Manche manche) async {
    await (_db.update(_db.manches)
          ..where((m) =>
              m.partieId.equals(partieId) &
              m.mancheNumber.equals(manche.numeroManche)))
        .write(
      ManchesCompanion(
        scoreEquipe1: Value(manche.scoreTeam1),
        scoreEquipe2: Value(manche.scoreTeam2),
      ),
    );
    await loadManches(partieId); // Reload to update state
  }
}
