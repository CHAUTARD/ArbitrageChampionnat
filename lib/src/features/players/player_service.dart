// Path: lib/src/features/players/player_service.dart
// Rôle: Fournit des services pour la gestion des joueurs, en interagissant avec la base de données locale (Hive).
// Ce service gère l'initialisation de la base de données.
// Il permet de récupérer la liste complète des joueurs ou un joueur spécifique par son identifiant.

import 'package:hive/hive.dart';
import 'package:myapp/models/player_model.dart';

class PlayerService {
  static const String _boxName = 'players';

  Future<Box<Player>> _openBox() async {
    return await Hive.openBox<Player>(_boxName);
  }

  Future<void> initializeDatabase() async {
    // This method ensures the Hive box for players is open when the app starts.
    // It no longer pre-populates the database with static data.
    await _openBox();
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
