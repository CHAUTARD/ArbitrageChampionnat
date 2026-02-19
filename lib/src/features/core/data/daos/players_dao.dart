import 'package:drift/drift.dart';
import 'package:mölkky_scorer/src/features/core/data/database.dart';

part 'players_dao.g.dart';

@DriftAccessor(tables: [Players])
class PlayersDao extends DatabaseAccessor<AppDatabase> with _$PlayersDaoMixin {
  PlayersDao(AppDatabase db) : super(db);

  Future<List<Player>> getAllPlayers() => select(players).get();
  Stream<List<Player>> watchAllPlayers() => select(players).watch();
  Future<int> createPlayer(PlayersCompanion player) => into(players).insert(player);
  Future<void> updatePlayer(Player player) => update(players).replace(player);
  Future<void> deletePlayer(Player player) => delete(players).delete(player);
}
