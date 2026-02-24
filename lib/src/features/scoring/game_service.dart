// game_service.dart
import 'package:hive/hive.dart';
import 'package:myapp/models/game_model.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/partie_model.dart';

class GameService {
  final Box<Game> _gameBox;

  GameService(this._gameBox);

  Future<Game> createGame(Partie partie) async {
    final List<Manche> manches = [];

    for (int i = 0; i < 5; i++) {
      manches.add(Manche(partie: partie));
    }

    final newGame = Game(
      id: 'game_${partie.id}', // Ensure a unique ID for the game
      partie: partie,
      manches: manches,
    );
    await _gameBox.put(newGame.id, newGame);
    return newGame;
  }

  Future<Game?> getGame(String partieId) async {
    return _gameBox.get('game_$partieId');
  }

  Future<void> updateGame(Game game) async {
    await _gameBox.put(game.id, game);
  }
}
