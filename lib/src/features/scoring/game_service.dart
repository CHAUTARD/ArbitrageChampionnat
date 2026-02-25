import 'package:hive/hive.dart';
import 'package:myapp/models/game_model.dart';
import 'package:myapp/models/manche_model.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:uuid/uuid.dart';

class GameService {
  final Box<Game> gameBox;
  final Uuid uuid;

  GameService({required this.gameBox, required this.uuid});

  Game createGame(Partie partie) {
    final newGame = Game(
      id: uuid.v4(),
      partie: partie,
      manches: [Manche(partie: partie, scoreTeam1: 0, scoreTeam2: 0)], // Correction ici
      scores: [0, 0],
    );
    gameBox.put(newGame.id, newGame);
    return newGame;
  }

  Game? getGame(String partieId) {
    return gameBox.values.cast<Game?>().firstWhere(
          (game) => game?.partie.id == partieId,
          orElse: () => null,
        );
  }

  void updateGame(Game game) {
    gameBox.put(game.id, game);
  }
}
