import 'package:drift/drift.dart';
import 'package:mölkky_scorer/src/features/core/data/database.dart';

part 'parties_dao.g.dart';

@DriftAccessor(tables: [Parties])
class PartiesDao extends DatabaseAccessor<AppDatabase> with _$PartiesDaoMixin {
  PartiesDao(AppDatabase db) : super(db);

  Future<List<Partie>> getAllParties() => select(parties).get();
  Stream<List<Partie>> watchAllParties() => select(parties).watch();
  Future<Partie> getPartieById(int id) => (select(parties)..where((p) => p.id.equals(id))).getSingle();
  Future<int> createPartie(PartiesCompanion partie) => into(parties).insert(partie);
  Future<void> updatePartie(Partie partie) => update(parties).replace(partie);
  Future<void> deletePartie(Partie partie) => delete(parties).delete(partie);
}
