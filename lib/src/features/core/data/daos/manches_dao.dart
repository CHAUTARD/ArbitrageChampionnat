import 'package:drift/drift.dart';
import 'package:mölkky_scorer/src/features/core/data/database.dart';

part 'manches_dao.g.dart';

@DriftAccessor(tables: [Manches])
class ManchesDao extends DatabaseAccessor<AppDatabase> with _$ManchesDaoMixin {
  ManchesDao(AppDatabase db) : super(db);

  Future<List<Manche>> getManchesForPartie(int partieId) =>
      (select(manches)..where((m) => m.partieId.equals(partieId))).get();
  Stream<List<Manche>> watchManchesForPartie(int partieId) =>
      (select(manches)..where((m) => m.partieId.equals(partieId))).watch();
  Future<int> createManche(ManchesCompanion manche) => into(manches).insert(manche);
}
