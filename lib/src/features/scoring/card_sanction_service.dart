import 'package:hive/hive.dart';

enum PersistentCardType { yellow, yellowRedPlus, red }

class PlayerPersistentCards {
  final bool yellow;
  final bool yellowRedPlus;
  final bool red;

  const PlayerPersistentCards({
    this.yellow = false,
    this.yellowRedPlus = false,
    this.red = false,
  });

  factory PlayerPersistentCards.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const PlayerPersistentCards();
    return PlayerPersistentCards(
      yellow: map['yellow'] == true,
      yellowRedPlus: map['yellowRedPlus'] == true,
      red: map['red'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'yellow': yellow,
      'yellowRedPlus': yellowRedPlus,
      'red': red,
    };
  }

  bool isGiven(PersistentCardType type) {
    switch (type) {
      case PersistentCardType.yellow:
        return yellow;
      case PersistentCardType.yellowRedPlus:
        return yellowRedPlus;
      case PersistentCardType.red:
        return red;
    }
  }

  PlayerPersistentCards markGiven(PersistentCardType type) {
    switch (type) {
      case PersistentCardType.yellow:
        return PlayerPersistentCards(
          yellow: true,
          yellowRedPlus: yellowRedPlus,
          red: red,
        );
      case PersistentCardType.yellowRedPlus:
        return PlayerPersistentCards(
          yellow: yellow,
          yellowRedPlus: true,
          red: red,
        );
      case PersistentCardType.red:
        return PlayerPersistentCards(
          yellow: yellow,
          yellowRedPlus: yellowRedPlus,
          red: true,
        );
    }
  }

  PlayerPersistentCards markRemoved(PersistentCardType type) {
    switch (type) {
      case PersistentCardType.yellow:
        return PlayerPersistentCards(
          yellow: false,
          yellowRedPlus: yellowRedPlus,
          red: red,
        );
      case PersistentCardType.yellowRedPlus:
        return PlayerPersistentCards(
          yellow: yellow,
          yellowRedPlus: false,
          red: red,
        );
      case PersistentCardType.red:
        return PlayerPersistentCards(
          yellow: yellow,
          yellowRedPlus: yellowRedPlus,
          red: false,
        );
    }
  }
}

class CardSanctionService {
  static const String _playerCardsBoxName = 'player_persistent_cards';
  static const String _whiteCardsBoxName = 'partie_white_cards';

  Future<Box<dynamic>> _openPlayerCardsBox() {
    return Hive.openBox<dynamic>(_playerCardsBoxName);
  }

  Future<Box<dynamic>> _openWhiteCardsBox() {
    return Hive.openBox<dynamic>(_whiteCardsBoxName);
  }

  Future<PlayerPersistentCards> getPlayerPersistentCards(String playerId) async {
    final box = await _openPlayerCardsBox();
    final value = box.get(playerId);
    if (value is Map) {
      return PlayerPersistentCards.fromMap(value);
    }
    return const PlayerPersistentCards();
  }

  Future<Map<String, PlayerPersistentCards>> getPlayersPersistentCards(
    List<String> playerIds,
  ) async {
    final result = <String, PlayerPersistentCards>{};
    for (final playerId in playerIds) {
      result[playerId] = await getPlayerPersistentCards(playerId);
    }
    return result;
  }

  Future<void> givePersistentCard(
    String playerId,
    PersistentCardType cardType,
  ) async {
    final box = await _openPlayerCardsBox();
    final current = await getPlayerPersistentCards(playerId);
    final updated = current.markGiven(cardType);
    await box.put(playerId, updated.toMap());
  }

  Future<void> removePersistentCard(
    String playerId,
    PersistentCardType cardType,
  ) async {
    final box = await _openPlayerCardsBox();
    final current = await getPlayerPersistentCards(playerId);
    final updated = current.markRemoved(cardType);
    await box.put(playerId, updated.toMap());
  }

  Future<Map<String, dynamic>> _getPartieWhiteState(String partieId) async {
    final box = await _openWhiteCardsBox();
    final value = box.get(partieId);
    if (value is Map) {
      final players = value['players'];
      return {
        'team1': value['team1'] == true,
        'team2': value['team2'] == true,
        'players': players is Map ? Map<String, bool>.from(players) : <String, bool>{},
      };
    }

    return {
      'team1': false,
      'team2': false,
      'players': <String, bool>{},
    };
  }

  Future<bool> hasWhiteForPlayer(String partieId, String playerId) async {
    final state = await _getPartieWhiteState(partieId);
    final players = state['players'] as Map<String, bool>;
    return players[playerId] == true;
  }

  Future<void> giveWhiteToPlayer(String partieId, String playerId) async {
    final box = await _openWhiteCardsBox();
    final state = await _getPartieWhiteState(partieId);
    final players = state['players'] as Map<String, bool>;
    players[playerId] = true;
    await box.put(partieId, {
      'team1': state['team1'] == true,
      'team2': state['team2'] == true,
      'players': players,
    });
  }

  Future<void> removeWhiteForPlayer(String partieId, String playerId) async {
    final box = await _openWhiteCardsBox();
    final state = await _getPartieWhiteState(partieId);
    final players = state['players'] as Map<String, bool>;
    players.remove(playerId);
    await box.put(partieId, {
      'team1': state['team1'] == true,
      'team2': state['team2'] == true,
      'players': players,
    });
  }

  Future<bool> hasWhiteForTeam(String partieId, int teamNumber) async {
    final state = await _getPartieWhiteState(partieId);
    if (teamNumber == 1) return state['team1'] == true;
    return state['team2'] == true;
  }

  Future<void> giveWhiteToTeam(String partieId, int teamNumber) async {
    final box = await _openWhiteCardsBox();
    final state = await _getPartieWhiteState(partieId);

    await box.put(partieId, {
      'team1': teamNumber == 1 ? true : state['team1'] == true,
      'team2': teamNumber == 2 ? true : state['team2'] == true,
      'players': state['players'],
    });
  }

  Future<void> removeWhiteForTeam(String partieId, int teamNumber) async {
    final box = await _openWhiteCardsBox();
    final state = await _getPartieWhiteState(partieId);
    await box.put(partieId, {
      'team1': teamNumber == 1 ? false : state['team1'] == true,
      'team2': teamNumber == 2 ? false : state['team2'] == true,
      'players': state['players'],
    });
  }

  Future<bool> hasAnyWhiteInPartie(String partieId) async {
    final state = await _getPartieWhiteState(partieId);
    final players = state['players'] as Map<String, bool>;
    final hasPlayerWhite = players.values.any((value) => value == true);
    return state['team1'] == true || state['team2'] == true || hasPlayerWhite;
  }

  Future<Map<String, bool>> getWhiteByTeam({
    required String partieId,
    required List<String> team1PlayerIds,
    required List<String> team2PlayerIds,
    required bool isDouble,
  }) async {
    final state = await _getPartieWhiteState(partieId);
    final players = state['players'] as Map<String, bool>;

    if (isDouble) {
      return {
        'team1': state['team1'] == true,
        'team2': state['team2'] == true,
      };
    }

    final team1HasWhite = team1PlayerIds.any((id) => players[id] == true);
    final team2HasWhite = team2PlayerIds.any((id) => players[id] == true);
    return {
      'team1': team1HasWhite,
      'team2': team2HasWhite,
    };
  }
}
