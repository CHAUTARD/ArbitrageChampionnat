import 'package:myapp/models/player_model.dart';

/// Retourne une liste statique de joueurs pré-définis.
List<Player> getStaticPlayers() {
  return [
    Player(id: 'A', name: 'N. Djokovic', equipe: 'France', lettre: 'A'),
    Player(id: 'B', name: 'C. Alcaraz', equipe: 'France', lettre: 'B'),
    Player(id: 'C', name: 'J. Sinner', equipe: 'France', lettre: 'C'),
    Player(id: 'D', name: 'D. Medvedev', equipe: 'France', lettre: 'D'),
    Player(id: 'W', name: 'A. Zverev', equipe: 'Espagne', lettre: 'W'),
    Player(id: 'X', name: 'A. Rublev', equipe: 'Espagne', lettre: 'X'),
    Player(id: 'Y', name: 'H. Rune', equipe: 'Espagne', lettre: 'Y'),
    Player(id: 'Z', name: 'C. Ruud', equipe: 'Espagne', lettre: 'Z'),
  ];
}
