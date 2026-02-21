import 'package:isar/isar.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/models/equipe_model.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/game_model.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [PlayerSchema, EquipeSchema, PartieSchema, MancheSchema, GameSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // You can add methods here to interact with the database
  // For example:
  // Future<void> savePlayer(Player player) async {
  //   final isar = await db;
  //   isar.writeTxnSync<int>(() => isar.players.putSync(player));
  // }
}
