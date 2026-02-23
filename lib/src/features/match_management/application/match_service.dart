// lib/src/features/match_management/application/match_service.dart
import 'package:hive/hive.dart';
import 'package:myapp/models/match.dart';
import 'package:rxdart/rxdart.dart';

class MatchService {
  final Box<Match> _matchBox;

  MatchService(this._matchBox);

  Future<void> addMatch(Match match) async {
    await _matchBox.put(match.id, match);
  }

  Future<void> updateMatch(Match match) async {
    await _matchBox.put(match.id, match);
  }

  Future<void> deleteMatch(String matchId) async {
    await _matchBox.delete(matchId);
  }

  Future<void> deleteAllMatches() async {
    await _matchBox.clear();
  }

  Stream<List<Match>> getMatches() {
    return _matchBox
        .watch()
        .map((_) => _matchBox.values.toList())
        .startWith(_matchBox.values.toList());
  }
}
