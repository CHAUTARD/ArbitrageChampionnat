import 'package:hive/hive.dart';
import 'package:myapp/models/match.dart';

class MatchService {
  final Box<Match> _matchBox;

  MatchService(this._matchBox);

  Future<void> addMatch(Match match) async {
    await _matchBox.put(match.id, match);
  }

  Future<void> deleteMatch(String matchId) async {
    await _matchBox.delete(matchId);
  }

  Stream<List<Match>> getMatches() {
    return _matchBox.watch().map((_) => _matchBox.values.toList());
  }
}
