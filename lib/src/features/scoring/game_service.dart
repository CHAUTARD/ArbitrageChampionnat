import 'package:hive/hive.dart';
import 'package:myapp/models/game_model.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/partie_model.dart';

class GameService {
  final Box<Game> _gameBox;

  GameService(this._gameBox);

  Future<Game> createGame(Partie partie) async {
    final isDouble = partie.team1PlayerIds.length == 2;
    final int numberOfManches = isDouble ? 5 : 3;
    final List<Manche> manches = [];

    for (int i = 0; i < numberOfManches; i++) {
      manches.add(Manche(partie: partie, numeroManche: i + 1));
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
