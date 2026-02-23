import 'package:hive/hive.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/data/static_players_data.dart';

class PlayerService {
  static const String _boxName = 'players';

  Future<Box<Player>> _openBox() async {
    return await Hive.openBox<Player>(_boxName);
  }

  Future<void> initializeDatabase() async {
    final box = await _openBox();
    if (box.isEmpty) {
      final staticPlayers = getStaticPlayers();
      for (var player in staticPlayers) {
        await box.put(player.id, player);
      }
    }
  }

  Future<List<Player>> getPlayers() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<Player?> getPlayerById(String id) async {
    final box = await _openBox();
    return box.get(id);
  }
}
